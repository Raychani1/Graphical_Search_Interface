import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/widgets/draw/painter.dart';
import 'package:graphical_search_interface/providers/offset_provider.dart';

class DrawingDisplay extends StatelessWidget {
  final List<Offset> _data;
  final Color _color;
  final double _penWidth;

  // ignore: use_key_in_widget_constructors
  const DrawingDisplay(this._data, this._color, this._penWidth);

  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return CustomPaint(
      painter: Painter(_data, _color, _penWidth),
      child: SizedBox(
        height: offsetProvider.appHeight,
        // width: offsetProvider.appWidth,
      ),
    );
  }
}
