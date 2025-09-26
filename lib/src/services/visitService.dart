
import 'dart:async';
import 'dart:collection';

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../utils/user_preferences.dart';
import 'api_http_client.dart';

class VisitService extends ChangeNotifier {

  final String _prod = 'dostop.mx';

  VisitService({http.Client? client}) : _client = client ?? ApiHttpClient.instance.client;


  Future<http.Response> _retryGet(
      Uri uri, {
        required Map<String, String> headers,
        int retries = 3,
      }) async {
    late Object lastErr;
    for (var i = 0; i < retries; i++) {
      try {
        return await _client.get(uri, headers: headers);
      } catch (e) {
        lastErr = e;
        await Future.delayed(Duration(milliseconds: 300 * (i + 1))); // backoff
      }
    }
    throw lastErr;
  }


  final _storage = const FlutterSecureStorage();
  final UserPreferences _prefs = UserPreferences();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Map<String, Future<_NetworkResult>> _inflight = <String, Future<_NetworkResult>>{};
  final Map<String, DateTime> _lastHit = <String, DateTime>{};
  final Map<String, _CacheEntry> _cache = <String, _CacheEntry>{};
  final _SimpleSemaphore _semaphore = _SimpleSemaphore(2);

  Duration get _ttlDuration {
    final ttlSeconds = _prefs.cacheTtlSeconds.clamp(15, 120);
    return Duration(seconds: ttlSeconds);
  }

  Duration get _throttleDuration {
    final refreshSeconds = _prefs.refreshIntervalSeconds.clamp(5, 60);
    return Duration(seconds: refreshSeconds < 10 ? 10 : refreshSeconds);
  }

  ApiHttpClient? get _apiClient {
    try {
      return ApiHttpClient.instance;
    } catch (_) {
      return ApiHttpClient.maybeInstance;
    }
  }

  Future<Map<String, dynamic>> ultimaVisitaVehicular({bool forceRefresh = false}) async {
    return _getWithLogs(
      label: 'ultimaVisitaVehicular',
      uri: Uri.https(_prod, '/api/AppGuardias/mVisitaVehicular'),
      forceRefresh: forceRefresh,
    );
  }

  Future<Map<String, dynamic>> ultimaSalidaVehicular({bool forceRefresh = false}) async {
    return _getWithLogs(
      label: 'ultimaSalidaVehicular',
      uri: Uri.https(_prod, '/api/AppGuardias/mSalidaVehicular'),
      forceRefresh: forceRefresh,
    );
  }

  Future<Map<String, dynamic>> ultimaVisitaPeatonal({bool forceRefresh = false}) async {
    return _getWithLogs(
      label: 'ultimaVisitaPeatonal',
      uri: Uri.https(_prod, '/api/AppGuardias/mVisitaPeatonal'),
      forceRefresh: forceRefresh,
    );
  }

  Future<Map<String, dynamic>> ultimaSalidaPeatonal({bool forceRefresh = false}) async {
    return _getWithLogs(
      label: 'ultimaSalidaPeatonal',
      uri: Uri.https(_prod, '/api/AppGuardias/mSalidaPeatonal'),
      forceRefresh: forceRefresh,
    );
  }

  Future<Map<String, dynamic>> ultimaVisitafacial({bool forceRefresh = false}) async {
    return _getWithLogs(
      label: 'ultimaVisitaFacial',
      uri: Uri.https(_prod, '/api/AppGuardias/ultimaVisitaFacial'),
      forceRefresh: forceRefresh,
    );
  }

  Future<Map<String, dynamic>> ultimaSalidaFacial({bool forceRefresh = false}) async {
    return _getWithLogs(
      label: 'ultimaSalidaFacial',
      uri: Uri.https(_prod, '/api/AppGuardias/ultimaSalidaFacial'),
      forceRefresh: forceRefresh,
    );
  }

  Future<Map<String, dynamic>> _getWithLogs({
    required String label,
    required Uri uri,
    required bool forceRefresh,
  }) async {
    final token = await _storage.read(key: 'token') ?? '';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final String cacheKey = uri.toString();
    final Duration ttl = _ttlDuration;
    final DateTime now = DateTime.now();
    final _CacheEntry? cachedEntry = _cache[cacheKey];

    if (!forceRefresh && cachedEntry != null && cachedEntry.isFresh(ttl)) {
      _lastHit[cacheKey] = now;
      _scheduleRevalidateIfNeeded(cacheKey, uri, headers, label);
      _logRequest(
        label,
        coalesced: false,
        throttled: false,
        fromCache: true,
        ttl: ttl,
        etagSent: false,
        got304: false,
        statusCode: cachedEntry.statusCode,
      );
      return cachedEntry.body;
    }

    bool throttled = false;
    if (!forceRefresh) {
      final DateTime? last = _lastHit[cacheKey];
      if (last != null && now.difference(last) < _throttleDuration) {
        throttled = true;
        if (cachedEntry != null) {
          _lastHit[cacheKey] = now;
          _logRequest(
            label,
            coalesced: false,
            throttled: true,
            fromCache: true,
            ttl: ttl,
            etagSent: false,
            got304: false,
            statusCode: cachedEntry.statusCode,
          );
          return cachedEntry.body;
        }
      }
    }

    Future<_NetworkResult>? requestFuture = _inflight[cacheKey];
    bool coalesced = false;
    if (requestFuture != null) {
      coalesced = true;
    } else {
      requestFuture = _executeRequest(
        cacheKey,
        uri,
        headers,
        label,
        useConditionalRequests: _prefs.useEtag,
      );
      _inflight[cacheKey] = requestFuture;
    }

    try {
      final _NetworkResult result = await requestFuture!;
      if (identical(_inflight[cacheKey], requestFuture)) {
        _inflight.remove(cacheKey);
      }
      final _CacheEntry? entry = result.cacheEntry;
      if (entry != null) {
        _cache[cacheKey] = entry;
      }
      _lastHit[cacheKey] = DateTime.now();
      _logRequest(
        label,
        coalesced: coalesced,
        throttled: throttled,
        fromCache: result.fromCache,
        ttl: ttl,
        etagSent: result.etagSent,
        got304: result.got304,
        statusCode: result.statusCode,
      );
      return result.body;
    } catch (error, stackTrace) {
      if (identical(_inflight[cacheKey], requestFuture)) {
        _inflight.remove(cacheKey);
      }
      log('[VisitService] $label request error: $error', stackTrace: stackTrace);
      return <String, dynamic>{
        'statusCode': 0,
        'status': 'error',
        'message': messageError(error),
      };
    }
  }

  void _scheduleRevalidateIfNeeded(
    String cacheKey,
    Uri uri,
    Map<String, String> headers,
    String label,
  ) {
    if (_inflight.containsKey(cacheKey)) {
      return;

    }
    final Future<_NetworkResult> future = _executeRequest(
      cacheKey,
      uri,
      headers,
      label,
      useConditionalRequests: _prefs.useEtag,
    );
    _inflight[cacheKey] = future;
    future.then((result) {
      if (result.cacheEntry != null) {
        _cache[cacheKey] = result.cacheEntry!;
      }
      _lastHit[cacheKey] = DateTime.now();
      _logRequest(
        label,
        coalesced: false,
        throttled: false,
        fromCache: result.fromCache,
        ttl: _ttlDuration,
        etagSent: result.etagSent,
        got304: result.got304,
        statusCode: result.statusCode,
        background: true,
      );
    }).catchError((Object error, StackTrace stackTrace) {
      log('[VisitService] $label background revalidation error: $error', stackTrace: stackTrace);
    }).whenComplete(() {
      if (identical(_inflight[cacheKey], future)) {
        _inflight.remove(cacheKey);
      }
    });
  }

  Future<_NetworkResult> _executeRequest(
    String cacheKey,
    Uri uri,
    Map<String, String> headers,
    String label, {
    required bool useConditionalRequests,
  }) {
    return _semaphore.withPermit(() async {
      final Map<String, String> requestHeaders = Map<String, String>.from(headers);
      bool conditionalSent = false;
      final ApiHttpClient? apiClient = useConditionalRequests ? _apiClient : null;

      if (apiClient != null) {
        final String? etag = apiClient.getEtag(cacheKey);
        if (etag != null && etag.isNotEmpty) {
          requestHeaders['If-None-Match'] = etag;
          conditionalSent = true;
        }
        final String? lastModified = apiClient.getLastModified(cacheKey);
        if (lastModified != null && lastModified.isNotEmpty) {
          requestHeaders['If-Modified-Since'] = lastModified;
          conditionalSent = true;
        }
      }

      final http.Response response = await _client.get(uri, headers: requestHeaders);
      final Map<String, String> responseHeaders = Map<String, String>.from(response.headers);

      if (apiClient != null) {
        final String? newEtag = responseHeaders['etag'];
        if (newEtag != null && newEtag.isNotEmpty) {
          apiClient.setEtag(cacheKey, newEtag);
        }
        final String? newLastModified = responseHeaders['last-modified'];
        if (newLastModified != null && newLastModified.isNotEmpty) {
          apiClient.setLastModified(cacheKey, newLastModified);
        }
      }

      if (response.statusCode == 304) {
        final _CacheEntry? cacheEntry = _cache[cacheKey];
        if (cacheEntry != null) {
          final _CacheEntry refreshedEntry = cacheEntry.refreshed();
          return _NetworkResult(
            body: refreshedEntry.body,
            cacheEntry: refreshedEntry,
            fromCache: true,
            etagSent: conditionalSent,
            got304: true,
            statusCode: cacheEntry.statusCode,
          );
        }
        log('[VisitService] $label received 304 without cache for $cacheKey');
        return _NetworkResult(
          body: <String, dynamic>{'statusCode': response.statusCode},
          cacheEntry: null,
          fromCache: true,
          etagSent: conditionalSent,
          got304: true,
          statusCode: response.statusCode,
        );
      }

      final Map<String, dynamic> decodedBody = _parseBody(response.body);
      final _CacheEntry entry = _CacheEntry(
        body: decodedBody,
        statusCode: response.statusCode,
        headers: responseHeaders,
        timestamp: DateTime.now(),
      );

      return _NetworkResult(
        body: decodedBody,
        cacheEntry: entry,
        fromCache: false,
        etagSent: conditionalSent,
        got304: false,
        statusCode: response.statusCode,
      );
    });
  }

  Map<String, dynamic> _parseBody(String body) {
    if (body.isEmpty) {
      return <String, dynamic>{};
    }
    try {
      final dynamic decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{'data': decoded};

    } catch (e) {
      log('[VisitService] Failed to decode response body: $e');
      return <String, dynamic>{'raw': body};
    }
  }

  void _logRequest(
    String label, {
    required bool coalesced,
    required bool throttled,
    required bool fromCache,
    required Duration ttl,
    required bool etagSent,
    required bool got304,
    int? statusCode,
    bool background = false,
  }) {
    final String backgroundText = background ? ' background=true' : '';
    log('[VisitService] $label coalesced=$coalesced throttled=$throttled fromCache=$fromCache ttl=${ttl.inSeconds}s etagSent=$etagSent got304=$got304 statusCode=${statusCode ?? '-'}$backgroundText');
  }
}

class _CacheEntry {
  _CacheEntry({
    required this.body,
    required this.statusCode,
    required this.headers,
    required this.timestamp,
  });

  final Map<String, dynamic> body;
  final int statusCode;
  final Map<String, String> headers;
  final DateTime timestamp;

  bool isFresh(Duration ttl) => DateTime.now().difference(timestamp) < ttl;

  _CacheEntry refreshed() {
    return _CacheEntry(
      body: body,
      statusCode: statusCode,
      headers: headers,
      timestamp: DateTime.now(),
    );
  }
}

class _NetworkResult {
  _NetworkResult({
    required this.body,
    required this.cacheEntry,
    required this.fromCache,
    required this.etagSent,
    required this.got304,
    required this.statusCode,
  });

  final Map<String, dynamic> body;
  final _CacheEntry? cacheEntry;
  final bool fromCache;
  final bool etagSent;
  final bool got304;
  final int statusCode;
}

class _SimpleSemaphore {
  _SimpleSemaphore(this._maxConcurrent);

  final int _maxConcurrent;
  int _current = 0;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();

  Future<T> withPermit<T>(Future<T> Function() action) async {
    await _acquire();
    try {
      return await action();
    } finally {
      _release();
    }
  }

  Future<void> _acquire() {
    if (_current < _maxConcurrent) {
      _current++;
      return Future<void>.value();
    }
    final Completer<void> completer = Completer<void>();
    _waiters.add(completer);
    return completer.future.then((_) {
      _current++;
    });
  }

  void _release() {
    if (_current > 0) {
      _current--;
    }
    if (_waiters.isNotEmpty) {
      final Completer<void> completer = _waiters.removeFirst();
      if (!completer.isCompleted) {
        completer.complete();
      }

    }
  }

  // (Opcional) si en algún lugar ya llamas a estos nombres:

  Future<Map<String, dynamic>> getUltimaVisitaFacial({
    int retries = 3,
  }) async {
    final token = await _storage.read(key: 'token') ?? '';
    return _getJsonPath('/api/AppGuardias/ultimaVisitaFacial',
        token: token, hardened: true, retries: retries);
  }

  Future<Map<String, dynamic>> getUltimaSalidaFacial({
    int retries = 3,
  }) async {
    final token = await _storage.read(key: 'token') ?? '';
    return _getJsonPath('/api/AppGuardias/ultimaSalidaFacial',
        token: token, hardened: true, retries: retries);
  }
}
