// Source : https://youtu.be/yyHhloFMNNA?list=PLjxrf2q8roU3ahJVrSgAnPjzkpGmL9Czl
// and https://github.com/drinkthestars/flip-book

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Painter extends CustomPainter {
  final List<Offset> _offsets;
  final Color _color;
  final double _strokeWidth;

  Painter(this._offsets, this._color, this._strokeWidth) : super();

  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = PointMode.polygon;
    final paint = Paint()
      ..color = _color
      ..isAntiAlias = true
      ..strokeWidth = _strokeWidth;

    if (_offsets.isNotEmpty) {
      canvas.drawPoints(pointMode, _offsets, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
