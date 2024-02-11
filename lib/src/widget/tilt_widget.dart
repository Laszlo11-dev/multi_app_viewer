import 'package:flutter/material.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';

/*
https://stackoverflow.com/questions/50457809/rotate-3d-on-x-in-flutter
Tushar Roy
 */

class Tilt extends StatefulWidget {
  final Widget child;
  final ItemConfiguration? configuration;
  final MavFrame? frame;

  const Tilt({
    super.key,
    required this.child,
    this.configuration,
    this.frame,
  });

  @override
  TiltState createState() => TiltState();
}

class TiltState extends State<Tilt> {
  late Offset tilt =
      (widget.configuration?.tilt ?? widget.frame?.frameConfiguration.tilt) ??
          const Offset(0, 0);
  late double x = tilt.dx;
  late double y = tilt.dy;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tilt =
        (widget.configuration?.tilt ?? widget.frame?.frameConfiguration.tilt) ??
            const Offset(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0002)
          ..rotateX(x)
          ..rotateY(y),
        alignment: widget.configuration?.tilt == null
            ? FractionalOffset.centerLeft
            : FractionalOffset.center,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (widget.frame?.frameConfiguration.isTiltMode ?? false) {
              setState(() {
                x = x + details.delta.dy / 100;
                y = y + details.delta.dx / 100;
                widget.configuration?.tilt = Offset(x, y);
                widget.frame?.frameConfiguration.tilt = Offset(x, y);
              });
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
