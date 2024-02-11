import 'package:flutter/material.dart';
import 'package:mqtt_learning_client/feature/mqtt/mqtt_config.dart';
import 'package:mqtt_learning_client/feature/mqtt/state/mqtt_connection_bloc.dart';
import 'package:provider/provider.dart';

class MqttConnectionProvider extends StatelessWidget {
  final Widget child;
  const MqttConnectionProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MqttConnectionBloc(context.read<MqttConfig>()),
      dispose: (_, bloc) => bloc.dispose(),
      child: child,
    );
  }
}
