import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';
import 'package:graphical_search_interface/widgets/appbar/my_app_bar.dart';
import 'package:graphical_search_interface/widgets/draw/draw_motion_detector.dart';
import 'package:graphical_search_interface/widgets/draw/displays/drawing_display.dart';
import 'package:graphical_search_interface/widgets/draw/displays/labels_display.dart';
import 'package:graphical_search_interface/widgets/draw/displays/min_max_display.dart';
import 'package:graphical_search_interface/widgets/local_changes/drag_ball.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatelessWidget {
  final myAppBar = const MyAppBar();

  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    if (offsetProvider.drawing.isEmpty) {
      offsetProvider.setDragPosition = Offset.zero;
    }

    /// Get the width and height of the app for search result generation
    offsetProvider.setAppHeight =
        MediaQuery.of(context).size.height - myAppBar.preferredSize.height;
    offsetProvider.setAppWidth = MediaQuery.of(context).size.width;
    offsetProvider.setAllowedMaximalStartingPosition =
        offsetProvider.appWidth / 3.0;

    return Scaffold(
      appBar: myAppBar,
      body: Stack(
        children: <Widget>[
          offsetProvider.drawing.isNotEmpty
              ? MinMaxDisplay(offsetProvider.min, offsetProvider.max)
              : Container(),
          offsetProvider.isFinished && offsetProvider.drawing.isNotEmpty
              ? DrawingDisplay(
                  offsetProvider.result, const Color(0xffee6f57), 3.0)
              : Container(),
          (offsetProvider.min != -1 && offsetProvider.max != -1)
              ? LabelsDisplay(
                  offsetProvider.min,
                  offsetProvider.max,
                )
              : Container(),
          DrawMotionDetector(),
          (offsetProvider.dragPosition != Offset.zero)
              ? DragBall(
                  Offset(offsetProvider.dragPosition.dx - 5,
                      offsetProvider.dragPosition.dy - 5),
                )
              : Container(),
        ],
      ),
    );
  }
}
