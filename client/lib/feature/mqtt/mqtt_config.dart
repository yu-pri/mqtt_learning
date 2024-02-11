class MqttConfig {
  final String uri;
  final int port;
  final String clientId;
  final String pubsubTopic;

  factory MqttConfig.fromMap(Map<String, dynamic> map) {
    return MqttConfig(
      uri: map['SERVER_URI'],
      port: int.parse(map['SERVER_PORT']),
      clientId: map['CLIENT_ID'],
      pubsubTopic: map['TEST_PUBSUB_TOPIC'],
    );
  }

  MqttConfig({
    required this.uri,
    required this.port,
    required this.clientId,
    required this.pubsubTopic,
  });
}
