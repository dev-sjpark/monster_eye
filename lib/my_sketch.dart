import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

import 'dart:developer';

import 'drawing_object/circle.dart';
import 'drawing_object/mouth.dart';

class MySketch extends Sketch {

  MySketch({required this.maxSize});

  final Size maxSize;

  final List<Circle> circles = [];

  Offset? currentPoint;

  int cacheFrame = 0;

  final _registerPointThreshold = 10.0;

  Mouth? _mouth;

  @override
  Future<void> setup() async {
    size(
      width: maxSize.width.floor(),
      height: maxSize.height.floor(),
    );
  }

  void addCircle(Offset point) {
    if (_mouth != null) {
      return;
    }
    point = point.translate(random(-10, 10), random(-10, 10));
    if (currentPoint == null ||
        (currentPoint! - point).distance > _registerPointThreshold) {
      currentPoint = point;
      cacheFrame = 0;
      circles.add(Circle(offset: point, boundary: maxSize));
    }
  }

  void startDrawMouth() {
    if (_mouth != null) {
      _mouth = null;
    } else {
      _mouth = Mouth(boundary: maxSize);
    }
  }

  @override
  Future<void> draw() async {
    background(color: const Color(0xFF222222));
    _drawCircle();
    _drawEye();

    _mouth
      ?..transform()
      ..draw(this);
  }

  void _drawEye() {
    final center = Offset(maxSize.width / 2, maxSize.height / 2);
    fill(color: Colors.white);
    stroke(color: Colors.white);
    strokeWeight(0);
    circle(
      center: center,
      diameter: 60.0,
    );

    if (++cacheFrame > 20) {
      cacheFrame = 0;
      currentPoint = null;
    }

    Offset revisionPoint = Offset.zero;
    if (currentPoint != null) {
      final diff = currentPoint! - center;
      double xRatio = diff.dx / center.dx;
      double yRatio = diff.dy / center.dy;
      xRatio = xRatio > 1.0 ? 15.0 : xRatio * 15.0;
      yRatio = yRatio > 1.0 ? 15.0 : yRatio * 15.0;
      revisionPoint = Offset(xRatio, yRatio);
    }

    fill(color: Colors.black);
    stroke(color: Colors.black);
    strokeWeight(0);
    circle(
      center: center + revisionPoint,
      diameter: 20.0,
    );
  }

  void _drawCircle() {
    final removeIndex = <int>[];
    for (int i = 0; i < circles.length; i++) {
      final circle = circles[i];
      if (circle.isExtinction) {
        removeIndex.add(i);
        continue;
      }
      circle
        ..transform()
        ..draw(this);
    }
    for (var i in removeIndex) {
      circles.removeAt(i);
    }
  }

}