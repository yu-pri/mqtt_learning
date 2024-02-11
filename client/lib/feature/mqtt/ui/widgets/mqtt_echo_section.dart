import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_learning_client/common/utils/iter_util.dart';
import 'package:mqtt_learning_client/feature/mqtt/mqtt_config.dart';
import 'package:mqtt_learning_client/feature/mqtt/state/mqtt_connection_bloc.dart';
import 'package:provider/provider.dart';

class MqttEchoSection extends StatefulWidget {
  const MqttEchoSection({super.key});

  @override
  State<MqttEchoSection> createState() => _MqttEchoSectionState();
}

class _MqttEchoSectionState extends State<MqttEchoSection> {
  final List<String> sent = [];
  final List<String> received = [];
  late final topic = context.read<MqttConfig>().pubsubTopic;

  StreamSubscription? _sub;
  StreamSubscription? _connectionSub;
  bool _retainMessage = true;

  @override
  void initState() {
    final connBloc = context.read<MqttConnectionBloc>();

    _connectionSub = connBloc.isConnected.listen((isConnected) {
      _sub?.cancel();
      if (isConnected) {
        _sub = connBloc.subscribe(topic, _collectMessage);
      }
    });

    super.initState();
  }

  void _collectMessage(String message) {
    setState(() {
      received.add(message);
    });
  }

  void _toggleRetain(bool? retain) {
    setState(() {
      _retainMessage = retain ?? false;
    });
  }

  void _sendRandomWordPair() {
    final pair = generateWordPairs().first.join('-');
    setState(() {
      sent.add(pair);
    });
    final bloc = context.read<MqttConnectionBloc>();
    bloc.publish(topic, pair, retain: _retainMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: _sendRandomWordPair,
            child: const Text('SEND MESSAGE'),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _retainMessage,
              onChanged: _toggleRetain,
            ),
            const Text('RETAIN MESSAGE')
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [const Text('SENT'), ...sent.map(Text.new)],
              ),
            ),
            Expanded(
              child: Column(
                children: [const Text('RECEIVED'), ...received.map(Text.new)],
              ),
            )
          ],
        ),
      ].intersperse(const SizedBox(height: 10)).toList(),
    );
  }

  @override
  void dispose() {
    _connectionSub?.cancel();
    _sub?.cancel();
    super.dispose();
  }
}
