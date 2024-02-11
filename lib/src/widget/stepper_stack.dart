import 'package:flutter/material.dart';

class StepperStack extends StatefulWidget {
  final List<Widget> children;

  const StepperStack({super.key, required this.children});

  @override
  State<StepperStack> createState() => _StepperStackState();
}

class _StepperStackState extends State<StepperStack> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  if (index != 0) {
                    updateIndex(index - 1);
                  }
                },
                icon: Icon(
                  Icons.navigate_before,
                  color: index == 0 ? Colors.grey.shade300 : null,
                )),
            IconButton(
                onPressed: () {
                  if (index != widget.children.length - 1) {
                    updateIndex(index + 1);
                  }
                },
                icon: Icon(
                  Icons.navigate_next,
                  color: index == widget.children.length - 1
                      ? Colors.grey.shade300
                      : null,
                ))
          ],
        ),
        Expanded(
            child: SizedBox(
          width: 1000,
          child: IndexedStack(index: index, children: [
            ...widget.children.map((e) => e),
          ]),
        ))
      ],
    );
  }

  void updateIndex(int indexIn) {
    setState(() {
      index = indexIn < 0 ? 0 : indexIn;
    });
  }
}
