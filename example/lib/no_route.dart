import 'package:flutter/material.dart';

class NoRouting extends StatelessWidget {
  const NoRouting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home:
          Scaffold(appBar: AppBar(title: const Text('Flutter Demo Home Page'))),
    );
  }
}
