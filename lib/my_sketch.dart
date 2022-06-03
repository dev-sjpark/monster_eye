import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'dart:developer';

class MySketch extends Sketch {

  MySketch({required this.maxSize});

  final Size maxSize;

  final List<Circle> circles = [];

  Offset? currentPoint;

  int cacheFrame = 0;

  final _registerPointThreshold = 10.0;

  @override
  Future<void> setup() async {
    size(
      width: maxSize.width.floor(),
      height: maxSize.height.floor(),
    );
  }

  void addCircle(Offset point) {
    point = point.translate(random(-10, 10), random(-10, 10));
    if (currentPoint == null ||
        (currentPoint! - point).distance > _registerPointThreshold) {
      currentPoint = point;
      cacheFrame = 0;
      circles.add(Circle(offset: point, boundary: maxSize));
    }
  }

  @override
  Future<void> draw() async {
    background(color: Colors.black);
    _drawCircle();
    _drawEye();
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
        ..transformSize()
        ..draw(this);
    }
    for (var i in removeIndex) {
      circles.removeAt(i);
    }
  }
}

class Circle {
  Circle({
    required this.offset,
    required Size boundary,
  }) {
    _setMaxRadius(boundary);
  }

  void _setMaxRadius(Size boundary) {
    double bigger = boundary.width;
    bigger = boundary.height > bigger ? boundary.height : bigger;
    _maxRadius = bigger * 0.2;
  }

  final Offset offset;

  double _radius = 3;

  bool _isGrowing = true;

  late final double _maxRadius;

  bool get isExtinction => !_isGrowing && _radius.isNegative;

  void transformSize() {
    // circle should be max size in 12 frame
    final amount = _maxRadius / 12;
    if (_isGrowing) {
      _radius += amount;
      if (_radius >= _maxRadius) {
        _isGrowing = false;
      }
    } else {
      _radius -= (amount / 5);
    }
  }

  void draw(Sketch s) {
    s
      ..fill(color: Colors.red)
      ..strokeWeight(1)
      ..stroke(color: Colors.red)
      ..circle(center: offset, diameter: _radius);
  }
}