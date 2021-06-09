import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';

class LabelsDisplay extends StatelessWidget {
  final double _min;
  final double _max;

  // ignore: use_key_in_widget_constructors
  const LabelsDisplay(this._min, this._max);

  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return Stack(
      children: <Widget>[
        Positioned(
          left: _min + 10,
          top: 10,
          height: offsetProvider.appHeight,
          child: const Text("Min"),
        ),
        Positioned(
          left: _max + 10,
          top: 10,
          height: offsetProvider.appHeight,
          child: const Text("Max"),
        ),
      ],
    );
  }
}
