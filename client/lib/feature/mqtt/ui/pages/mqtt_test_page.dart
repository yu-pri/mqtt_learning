import 'package:flutter/material.dart';
import 'package:mqtt_learning_client/common/utils/iter_util.dart';
import 'package:mqtt_learning_client/common/widgets/seeded_value_stream_builder.dart';
import 'package:mqtt_learning_client/feature/mqtt/model/mqtt_connection_state.dart';
import 'package:mqtt_learning_client/feature/mqtt/state/mqtt_connection_bloc.dart';
import 'package:mqtt_learning_client/feature/mqtt/ui/widgets/connection_status_badge.dart';
import 'package:mqtt_learning_client/feature/mqtt/ui/widgets/connection_toggle_button.dart';
import 'package:mqtt_learning_client/feature/mqtt/ui/widgets/mqtt_echo_section.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MqttTestPage extends StatelessWidget {
  const MqttTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT TEST CLIENT'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const ConenctionToggleButton(),
            const ConnectionStatusBadge(),
            SeededValueStreamBuilder(
              seededValueStream: context
                  .read<MqttConnectionBloc>()
                  .connectionStatus
                  .map((s) => s == MqttConnnectionState.connected)
                  .shareValueSeeded(false),
              builder: (context, isConnected, _) {
                if (!(isConnected ?? false)) return const SizedBox.shrink();
                return const MqttEchoSection();
              },
            )
          ]
              .intersperse(
                const SizedBox(height: 10),
              )
              .toList(),
        ),
      ),
    );
  }
}
