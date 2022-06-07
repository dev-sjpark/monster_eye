import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class Circle {
  Circle({
    required this.offset,
    required Size boundary,
  }) {
    _setMaxRadius(boundary);
    _movingDirection = _getDirection();
  }

  void _setMaxRadius(Size boundary) {
    double bigger = boundary.width;
    bigger = boundary.height > bigger ? boundary.height : bigger;
    _maxSize = bigger * 0.2;
  }

  Offset offset;

  double _diameter = 4;

  bool _isGrowing = true;

  late final double _maxSize;

  final _frameVelocity = 12;

  final _movementRange = 1.5;

  late final Offset _movingDirection;

  bool get isExtinction => !_isGrowing && _diameter.isNegative;

  Offset _getDirection() {
    final rand = Random();
    return Offset(
      rand.nextDouble() * (_movementRange * 2) - _movementRange,
      rand.nextDouble() * (_movementRange * 2) - _movementRange,
    );
  }

  void transform() {
    offset += _movingDirection;
    // circle should be max size in 12 frame
    final amount = _maxSize / _frameVelocity;
    if (_isGrowing) {
      _diameter += amount;
      if (_diameter >= _maxSize) {
        _isGrowing = false;
      }
    } else {
      _diameter -= (amount / 5);
    }
  }

  void draw(Sketch s) {
    s
      ..fill(color: Colors.red)
      ..strokeWeight(1)
      ..stroke(color: Colors.red)
      ..circle(center: offset, diameter: _diameter);
  }
}
