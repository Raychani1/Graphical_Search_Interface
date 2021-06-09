import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';
import 'package:graphical_search_interface/widgets/draw/displays/drawing_display.dart';

// ignore: use_key_in_widget_constructors
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return DrawingDisplay(
      offsetProvider.tutorialDrawing,
      const Color(
        0xff1f3c88,
      ),
      5.0,
    );
  }
}
