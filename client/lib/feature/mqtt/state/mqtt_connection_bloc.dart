import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_learning_client/feature/mqtt/model/mqtt_connection_state.dart';
import 'package:mqtt_learning_client/feature/mqtt/mqtt_config.dart';
import 'package:rxdart/rxdart.dart';

class MqttConnectionBloc {
  final MqttConfig _config;
  late MqttServerClient _client;

  final _connectionStatusSubj =
      BehaviorSubject.seeded(MqttConnnectionState.disconnected);
  MqttConnectionBloc(this._config) {
    _client =
        MqttServerClient.withPort(_config.uri, _config.clientId, _config.port);

    _client.useWebSocket = true;

    _client.websocketProtocols = MqttClientConstants.protocolsMultipleDefault;
    _client.logging(on: true);

    _client.connectionStatus;
    _client.onConnected =
        () => _connectionStatusSubj.add(MqttConnnectionState.connected);
    _client.onDisconnected =
        () => _connectionStatusSubj.add(MqttConnnectionState.disconnected);
    _client.onAutoReconnect =
        () => _connectionStatusSubj.add(MqttConnnectionState.pending);
    _client.onAutoReconnected =
        () => _connectionStatusSubj.add(MqttConnnectionState.connected);
  }

  Stream<MqttMessage> _messagesForTopic(String topic) => _client.updates!
      .expand((e) => e)
      .where((msg) => msg.topic == topic)
      .map((e) => e.payload);

  ValueStream<MqttConnnectionState> get connectionStatus =>
      _connectionStatusSubj.stream;
  ValueStream<bool> get isConnected => connectionStatus
      .skip(1)
      .map((s) => s == MqttConnnectionState.connected)
      .distinct()
      .shareValueSeeded(
          connectionStatus.value == MqttConnnectionState.connected);

  void connect() async {
    try {
      await _client.connect();
    } catch (e) {
      _client.disconnect();
    }
  }

  void disconnect() => _client.disconnect();

  void publish(String topic, String message, {bool retain = false}) {
    final msgBuilder = MqttClientPayloadBuilder().addString(message);

    _client.publishMessage(topic, MqttQos.atLeastOnce, msgBuilder.payload!,
        retain: retain);
  }

  StreamSubscription? subscribe(String topic, ValueChanged<String> listener) {
    final _ = _client.subscribe(topic, MqttQos.atLeastOnce);
    return _messagesForTopic(topic)
        .whereType<MqttPublishMessage>()
        .map((e) => MqttPublishPayload.bytesToStringAsString(e.payload.message))
        .listen(listener);
  }

  void dispose() {
    _client.disconnect();
  }
}
