import 'package:flutter/material.dart';
import 'package:mqtt_learning_client/feature/mqtt/model/mqtt_connection_state.dart';
import 'package:mqtt_learning_client/feature/mqtt/state/mqtt_connection_bloc.dart';
import 'package:mqtt_learning_client/common/widgets/seeded_value_stream_builder.dart';
import 'package:provider/provider.dart';

class ConenctionToggleButton extends StatelessWidget {
  const ConenctionToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SeededValueStreamBuilder(
      seededValueStream: context.read<MqttConnectionBloc>().connectionStatus,
      builder: (context, connState, _) {
        return switch (connState) {
          MqttConnnectionState.disconnected =>
            ConnectButton(onTap: context.read<MqttConnectionBloc>().connect),
          MqttConnnectionState.connected => DisconnectButton(
              onTap: context.read<MqttConnectionBloc>().disconnect),
          _ => const WaitingButton()
        };
      },
    );
  }
}

class ConnectButton extends StatelessWidget {
  final VoidCallback onTap;
  const ConnectButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onTap,
        child: const Text('CONNECT'),
      );
}

class WaitingButton extends StatelessWidget {
  const WaitingButton({super.key});

  @override
  Widget build(BuildContext context) => const ElevatedButton(
        onPressed: null,
        child: Text('WAITING'),
      );
}

class DisconnectButton extends StatelessWidget {
  final VoidCallback onTap;
  const DisconnectButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onTap,
        child: const Text('DISCONNECT'),
      );
}
