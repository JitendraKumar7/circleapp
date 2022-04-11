import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FutureWidgetBuilder<T> extends StatelessWidget {
  final Widget Function(T?) builder;
  final Future<T> future;

  const FutureWidgetBuilder({
    Key? key,
    required this.future,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) =>
            snapshot.hasData
                ? builder(snapshot.data)
                : const Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                    ),
                  ),
        //: Center(child: CupertinoActivityIndicator()),
      );
}

class StreamWidgetBuilder<T> extends StatelessWidget {
  final Widget Function(T?) builder;
  final Stream<T> stream;

  const StreamWidgetBuilder({
    Key? key,
    required this.stream,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) =>
            snapshot.hasData
                ? builder(snapshot.data)
                : const Center(
                    child: SpinKitSquareCircle(color: Colors.blue),
                  ),
        //: Center(child: CupertinoActivityIndicator()),
      );
}
