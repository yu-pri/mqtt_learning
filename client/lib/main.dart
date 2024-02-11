import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mqtt_learning_client/common/theme/app_theme.dart';
import 'package:mqtt_learning_client/feature/mqtt/mqtt_config.dart';
import 'package:mqtt_learning_client/feature/mqtt/state/mqtt_connection_provider.dart';
import 'package:mqtt_learning_client/feature/mqtt/ui/pages/mqtt_test_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  final config = MqttConfig.fromMap(dotenv.env);

  runApp(MqttTestClientApp(config: config));
}

class MqttTestClientApp extends StatelessWidget {
  final MqttConfig config;
  const MqttTestClientApp({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: config,
      child: MqttConnectionProvider(
        child: MaterialApp(
          title: 'MQTT test client',
          theme: theme,
          home: const MqttTestPage(),
        ),
      ),
    );
  }
}
