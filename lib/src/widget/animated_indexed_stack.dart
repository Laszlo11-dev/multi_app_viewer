import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget>? children;

  const AnimatedIndexedStack({
    super.key,
    this.index = 0,
    this.children,
  });

  @override
  AnimatedIndexedStackState createState() => AnimatedIndexedStackState();
}

class AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _index;
  bool hidden = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _index = widget.index;
    _controller.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _index) {
      _controller.reverse().then((_) {
        setState(() => _index = widget.index);
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.children!.length - 1 < _index!) {
    //   widget.children!.add(Container(
    //     color: Colors.blueAccent,
    //   ));
    // }
    // widget.children![_index!] ??= Container(
    //   color: Colors.blueGrey,
    // );

    return AnimatedBuilder(
      animation: _animation,
      key: Key('${widget.key?.toString()} + fdsa'),
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
          //..scale(_controller.value)
          // ..translate(12)
          // ..setEntry(3, 2, 0.001)
          // ..rotateX(0)
          // ..rotateY((pi / 2) * (1 - _controller.value))
          ,
          alignment: FractionalOffset.centerRight,
          child: Opacity(
            opacity: _controller.value,
            child: Transform.scale(
              scale: 1.015 - (_controller.value * 0.015),
              child: child,
            ),
          ),
        );
      },
      child: IndexedStack(
        sizing: StackFit.expand,
        index: _index,
        children: widget.children!,
      ),
    );
  }
}
