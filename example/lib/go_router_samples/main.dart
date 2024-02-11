// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
void main() => runApp(MyApp());

/// The route configuration.

/// The main app.
class MyApp extends StatelessWidget {
  final MavItem? mavItem;

  /// Constructs a [MyApp]
  MyApp({super.key, this.mavItem});

  late final GoRouter _router = GoRouter(
    // MAV customization
    // add [item?.navigatorKey]
    navigatorKey: mavItem?.navigatorKey,
    // add item!.navigatorObserver
    observers: mavItem?.navigatorObserver == null
        ? null
        : [mavItem!.navigatorObserver],
    routes: <RouteBase>[
      GoRoute(
        name: '/',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen(
            state.uri.queryParameters['response'] ?? 'Empty',
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: 'details',
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              return DetailsScreen(
                parameter: state.uri.queryParameters['id1'] ?? 'Empty',
              );
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: mavItem?.identifier == null ? UniqueKey() : Key(mavItem!.identifier),
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, rootWidget) {
        mavItem?.onNavigationCallback =
            (String routeName, int index, {Object? arguments}) {
          if (index != mavItem?.index) {
            if (arguments != null) {
              _router.goNamed(routeName,
                  queryParameters: arguments as Map<String, dynamic>);
            } else {
              _router.goNamed(routeName);
            }
          }
        };
        return Directionality(
          textDirection:
              mavItem?.configuration.textDirection ?? TextDirection.ltr,
          child: Theme(
              key: UniqueKey(),
              data: Theme.of(context).copyWith(
                  brightness: Brightness.dark,
                  platform: mavItem?.configuration.targetPlatform),
              child: rootWidget!),
        );
      },
      routerConfig: _router,
    );
  }
}

/// The home screen
class HomeScreen extends StatefulWidget {
  final String response;

  const HomeScreen(this.response, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  late final MavItem? mavItem = MavItemInherited.maybeOf(context)?.item;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    mavItem?.publish('_counterValue', _counter);
  }

  @override
  void dispose() {
    super.dispose();
    mavItem?.dispose('_counterValue');
  }

  @override
  Widget build(BuildContext context) {
    mavItem?.listen('_counterValue', (value) {
      setState(() {
        _counter = value;
      });
    });

    return Scaffold(
      appBar: AppBar(
          title: const Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Home Screen'),
        ],
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/details?id1=${_counter.toString()}');
              },
              child: const Text('Go to the Details screen'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// The details screen
class DetailsScreen extends StatelessWidget {
  final String parameter;

  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key, required this.parameter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  parameter,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ElevatedButton(
                onPressed: () => context
                    .goNamed('/', queryParameters: {'response': parameter}),
                child: const Text('Go back to the Home screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
