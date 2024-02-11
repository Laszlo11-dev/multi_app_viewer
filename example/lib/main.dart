import './go_router_samples/main.dart';
import 'package:flutter/material.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MavFrame.loadConfiguration(
    // FrameConfiguration.fromFile('C:\\Users\\kissl\\Documents\\ggg.mavc')
    FrameConfiguration.lot(),
  );
  // // runs the script when the app load or reloads
  // MavFrame.autoRunScript = [
  //   MavFrame.preferredList[1],
  // // navigate to details with value 33
  //   (-1, 'details', {'id1': '33'}),
  // // navigates back to main
  //   (-1, '/', {'id1': '33'}),
  // // send value 99 to all listeners
  //   ('_counterValue', 99)
  // ];

  MavFrame.autoRunScript = [
    for (var i in MavFrame.preferredList) ...[
      i,
      (-1, 'details', {'id1': '55'}),
      (-1, '/', {'id1': '33'}),
      // ('_counterValue', 99)
    ]
  ];

  // runs the script when the toolbar menu Run scrip invoked
  MavFrame.buttonScript = [
    MavFrame.preferredList[2],
    (-1, 'details', {'id1': '55'}),
    (-1, '/', {'id1': '33'}),
    ('_counterValue', 99)
  ];

  // repeats the running script until the stop button is pressed on the toolbar
  MavFrame.autoRepeat = true;

  runApp(const MavGoRouterDemo());
}

class MavGoRouterDemo extends StatelessWidget {
  const MavGoRouterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const MavPage(
        key: Key('NavPage'),
      ),
    );
  }
}

class MavPage extends StatefulWidget {
  const MavPage({
    super.key,
  });

  @override
  State<MavPage> createState() => _MavPageState();
}

class _MavPageState extends State<MavPage> {
  @override
  Widget build(BuildContext context) {
    return MavFrameWidget(
      itemBuilder: (MavItem item) {
        // replace MyApp with your top widget
        return MyApp(
          mavItem: item,
          key: Key(item.identifier),
        );
      },
    );
  }
}
