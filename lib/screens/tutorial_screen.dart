import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';
import 'package:graphical_search_interface/widgets/draw/displays/labels_display.dart';
import 'package:graphical_search_interface/widgets/draw/displays/min_max_display.dart';
import 'package:graphical_search_interface/widgets/tutorial_screen/zeroth_screen.dart';
import 'package:graphical_search_interface/widgets/tutorial_screen/first_screen.dart';
import 'package:graphical_search_interface/widgets/tutorial_screen/second_screen.dart';
import 'package:graphical_search_interface/widgets/tutorial_screen/third_screen.dart';
import 'package:graphical_search_interface/widgets/tutorial_screen/fourth_screen.dart';
import 'package:graphical_search_interface/widgets/tutorial_screen/fifth_screen.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class TutorialScreen extends StatefulWidget {
  static const routeName = '/tutorial';
  int position = 0;

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    final Offset startingPosition = Offset(
        offsetProvider.allowedMaximalStartingPosition / 2,
        offsetProvider.appHeight / 2);
    offsetProvider.setTutorialMin =
        startingPosition.dx + (offsetProvider.appWidth * 0.260416667);
    offsetProvider.setTutorialMax =
        startingPosition.dx + (offsetProvider.appWidth * 0.781250001);

    offsetProvider.generateSineData(
        startingPosition, offsetProvider.tutorialMax);
    offsetProvider.generateSearchResult(
        offsetProvider.tutorialDrawing, "tutorialResult");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
      ),
      body: Stack(
        children: [
          MinMaxDisplay(offsetProvider.tutorialMin, offsetProvider.tutorialMax),
          LabelsDisplay(offsetProvider.tutorialMin, offsetProvider.tutorialMax),
          (widget.position == 0) ? ZerothScreen() : Container(),
          (widget.position == 1) ? FirstScreen() : Container(),
          (widget.position == 2) ? SecondScreen() : Container(),
          (widget.position == 3) ? ThirdScreen() : Container(),
          (widget.position == 4) ? FourthScreen() : Container(),
          (widget.position == 5 &&
                  offsetProvider.changeTutorialValues(385).isNotEmpty &&
                  offsetProvider.regenerateTutorialResult().isNotEmpty)
              ? FifthScreen()
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                child: SizedBox(
                  height: 40,
                  width: 75,
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Next",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.arrow_forward_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  setState(
                    () {
                      if (widget.position == 5) {
                        Navigator.of(context).pop();
                      } else {
                        widget.position++;
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
