import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

/// In-memory WebSocket channel for unit tests.
///
/// Provides [addServerEvent] to push fake server messages into the service and
/// [sent] to inspect the raw JSON strings the service has sent.
class FakeWebSocketChannel implements WebSocketChannel {
  // sync: true so events reach the listener immediately without a round-trip
  // through the event loop — keeps test assertions deterministic.
  final StreamController<dynamic> _inbound =
      StreamController<dynamic>(sync: true);
  final List<String> sent = [];
  final Completer<void> _readyCompleter = Completer<void>();

  FakeWebSocketChannel({bool readyImmediately = true}) {
    if (readyImmediately) _readyCompleter.complete();
  }

  /// Simulate a message arriving from the server.
  void addServerEvent(Map<String, dynamic> event) {
    _inbound.add(jsonEncode(event));
  }

  /// Simulate the server closing the connection.
  void closeFromServer() => _inbound.close();

  /// Return all decoded events the service has sent.
  List<Map<String, dynamic>> get sentEvents =>
      sent.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();

  // ─── WebSocketChannel interface ───────────────────────────────────────────

  @override
  Stream<dynamic> get stream => _inbound.stream;

  @override
  WebSocketSink get sink => _FakeWebSocketSink(sent);

  @override
  Future<void> get ready => _readyCompleter.future;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  String? get protocol => null;

  // StreamChannelMixin required methods — delegate to stream/sink.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeWebSocketSink implements WebSocketSink {
  final List<String> _log;
  _FakeWebSocketSink(this._log);

  @override
  void add(dynamic data) => _log.add(data as String);

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<dynamic> addStream(Stream stream) async {}

  @override
  Future<dynamic> close([int? closeCode, String? closeReason]) async {}

  @override
  Future<dynamic> get done => Future.value();
}
