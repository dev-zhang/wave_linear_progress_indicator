/*
 * File Created: 2022-06-02 15:11:39
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-06 16:14:09
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WaveLinearProgressIndicator Demo',
      theme: ThemeData(
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
              SizedBox(
                height: 19,
                child: WaveLinearProgressIndicator(
                  value: _progress,
                  enableBounceAnimation: true,
                ),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
              ),
              const SizedBox(height: 20),
              Slider(
                value: _progress,
                onChanged: (value) {
                  setState(() {
                    _progress = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 19,
                child: StreamBuilder<double>(
                    stream: _getDownloadProgress(),
                    builder: (context, snapshot) {
                      double progress = 0;
                      if (snapshot.hasData) {
                        progress = snapshot.data!;
                      }
                      return WaveLinearProgressIndicator(
                        value: progress,
                        // waveColor: Colors.orange,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
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

  Stream<double> _getDownloadProgress() async* {
    final values = <double>[
      0,
      0.1,
      0.2,
      0.3,
      0.4,
      0.45,
      0.7,
      0.85,
      0.9,
      0.95,
      0.99,
      1.0
    ];
    for (final p in values) {
      yield p;
      await Future.delayed(const Duration(milliseconds: 1800));
    }
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
