import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';
import 'package:graphical_search_interface/widgets/draw/displays/drawing_display.dart';

// ignore: use_key_in_widget_constructors
class FourthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          bottom: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 2),
            child: Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                color: const Color(
                  0xff1f3c88,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    const Text(
                      "Once you finished dragging",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    const Text(
                      "just release the ball",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        DrawingDisplay(
          offsetProvider.tutorialResult,
          const Color(
            0xffee6f57,
          ),
          3.0,
        ),
        DrawingDisplay(
          offsetProvider.tutorialDrawing,
          const Color(
            0xff1f3c88,
          ),
          5.0,
        ),
        Positioned(
          left: offsetProvider.tutorialDrawing[385].dx - 5,
          top: offsetProvider.tutorialDrawing[385].dy - 5,
          height: 15,
          width: 15,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Positioned(
          left: offsetProvider.tutorialDrawing[385].dx - 5,
          top: offsetProvider.tutorialDrawing[385].dy + 105,
          height: 15,
          width: 15,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
