/*
 * File Created: 2022-06-02 15:11:39
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-02 17:49:21
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WaveLinearProgressIndicator Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:
          const MyHomePage(title: 'WaveLinearProgressIndicator Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WaveLinearProgressIndicator(
                value: _progress,
                waveColor: Colors.orange,
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _updateProgress,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: _increase,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: _decrease,
          tooltip: 'Decrease',
          child: const Icon(Icons.remove),
        )
      ],
    );
  }

  void _increase() {
    final delta = Random().nextDouble();
    double newValue = _progress + delta;
    newValue = newValue.clamp(0, 1);
    setState(() {
      _progress = newValue;
    });
  }

  void _decrease() {
    final delta = Random().nextDouble();
    double newValue = _progress - delta;
    newValue = newValue.clamp(0, 1);
    setState(() {
      _progress = newValue;
    });
  }
}
