import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'dart:developer';
import 'my_sketch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  MySketch? sketch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: GestureDetector(
        onPanUpdate: (detail) => sketch?.addCircle(detail.localPosition),
        onDoubleTap: () => sketch?.startDrawMouth(),
        child: LayoutBuilder(
          builder: (context, box) {
            sketch = MySketch(maxSize: box.biggest);
            return Processing(
              sketch: sketch!,
            );
          }
        ),
      ),
    );
  }
}
