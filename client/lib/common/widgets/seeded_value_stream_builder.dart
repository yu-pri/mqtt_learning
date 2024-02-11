import 'package:flutter/widgets.dart';
import 'package:rxdart/streams.dart';

typedef SeededValueStreamBuilderBuilder<T> = Widget Function(
    BuildContext, T?, dynamic);

class SeededValueStreamBuilder<T> extends StatelessWidget {
  final ValueStream<T> seededValueStream;
  final SeededValueStreamBuilderBuilder<T> builder;
  const SeededValueStreamBuilder(
      {super.key, required this.seededValueStream, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: seededValueStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) return builder(context, snapshot.data, null);
        if (snapshot.hasError) return builder(context, null, snapshot.error);
        return builder(context, seededValueStream.value, null);
      },
    );
  }
}
