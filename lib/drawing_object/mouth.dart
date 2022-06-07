
import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class Mouth {
  Mouth({required this.boundary}) {
    upperEndY = boundary.height / 4;
    upperControlY = upperEndY - boundary.height;
    lowerStartY = 3 * boundary.height / 4;
    lowerControlY = lowerStartY + boundary.height;
  }

  final outsideX = 20;

  final Size boundary;

  final frameVelocity = 10;

  double upperEndY = 0;

  double upperControlY = 0;

  double lowerStartY = 0;

  double lowerControlY = 0;

  void transform() {
    if (upperControlY < boundary.height / 2) {
      upperEndY += (boundary.height / 2 - upperEndY) / frameVelocity;
      upperControlY += (boundary.height / 2 - upperControlY) / frameVelocity;
      lowerStartY -= (lowerStartY - boundary.height / 2) / frameVelocity;
      lowerControlY -= (lowerControlY - boundary.height / 2) / frameVelocity;
    }
  }

  void draw(Sketch s) {
    s
      ..fill(color: Colors.redAccent)
      ..stroke(color: Colors.redAccent);
    _drawUpside(s);
    _drawDownSide(s);
  }

  void _drawUpside(Sketch s) {
    s
      ..beginShape()
      // left bottom of top mouth;
      ..vertex(-outsideX, upperEndY)
      // bezier line to right bottom
      ..quadraticVertex(
        boundary.width / 2, upperControlY,
        boundary.width + outsideX, upperEndY,
      )
      // to right top
      ..vertex(
        boundary.width + outsideX,
        -(boundary.height / 2) - 100,
      )
      // to left top
      ..vertex(
        -outsideX,
        -(boundary.height / 2) - 100,
      )
      // close path
      ..endShape(close: true);
  }

  void _drawDownSide(Sketch s) {
    s
      ..beginShape()
      // left up of top mouth;
      ..vertex(-outsideX, lowerStartY)
      // bezier line to right up
      ..quadraticVertex(
        boundary.width / 2, lowerControlY,
        boundary.width + outsideX, lowerStartY,
      )
      // to right down
      ..vertex(
        boundary.width + outsideX,
        boundary.height + 100,
      )
      // to left down
      ..vertex(
        -outsideX,
        boundary.height + 100,
      )
      // close path
      ..endShape(close: true);
  }
}