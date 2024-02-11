import 'package:flutter/material.dart';
import 'package:mqtt_learning_client/feature/mqtt/model/mqtt_connection_state.dart';
import 'package:mqtt_learning_client/feature/mqtt/state/mqtt_connection_bloc.dart';
import 'package:mqtt_learning_client/common/theme/app_theme.dart';
import 'package:mqtt_learning_client/common/widgets/seeded_value_stream_builder.dart';
import 'package:provider/provider.dart';

class ConnectionStatusBadge extends StatelessWidget {
  const ConnectionStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return SeededValueStreamBuilder(
      seededValueStream: context.read<MqttConnectionBloc>().connectionStatus,
      builder: (context, connState, error) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: switch (connState) {
            MqttConnnectionState.disconnected => [
                const ColoredCircle(color: AppColors.error),
                const Text('DISCONNECTED')
              ],
            MqttConnnectionState.connected => [
                const ColoredCircle(color: AppColors.fg),
                const Text('CONNECTED')
              ],
            _ => [
                const ColoredCircle(color: AppColors.pending),
                const Text('PENDING')
              ],
          },
        );
      },
    );
  }
}

class ColoredCircle extends StatelessWidget {
  final Color color;
  const ColoredCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 20,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
