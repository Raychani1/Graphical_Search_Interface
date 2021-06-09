import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';
import 'package:graphical_search_interface/widgets/draw/displays/drawing_display.dart';

// ignore: use_key_in_widget_constructors
class MinMaxDisplay extends StatelessWidget {
  final double _min;
  final double _max;

  // ignore: use_key_in_widget_constructors
  const MinMaxDisplay(this._min, this._max);

  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return Stack(
      children: <Widget>[
        DrawingDisplay(
          offsetProvider.generateMinMaxData(_min),
          Colors.grey,
          3.0,
        ),
        DrawingDisplay(
          offsetProvider.generateMinMaxData(_max),
          Colors.grey,
          3.0,
        ),
      ],
    );
  }
}
