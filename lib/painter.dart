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
    final pointMode = PointMode.polygon;
    final paint = Paint()
      ..color = this._color
      ..isAntiAlias = true
      ..strokeWidth = this._strokeWidth;

//    for (var i = 0; i<offsets.length-1;i++) {
//      if(shouldDrawLine(i)){
//        canvas.drawLine(offsets[i], offsets[i+1], paint);
//      } else if(shouldDrawPoint(i)) {
//        canvas.drawPoints(PointMode.points, [offsets[i]], paint);
//      }
//    }

    if (_offsets.length > 0) {
      print("${_offsets[0]}, ${_offsets.last}");
      canvas.drawPoints(pointMode, _offsets, paint);
    }
  }

  bool shouldDrawPoint(int i) =>
      _offsets[i] != null && _offsets.length > i + 1 && _offsets[i + 1] == null;

  bool shouldDrawLine(int i) =>
      _offsets[i] != null && _offsets.length > i + 1 && _offsets[i + 1] != null;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
