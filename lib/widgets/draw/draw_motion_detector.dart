import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/widgets/draw/painter.dart';
import 'package:graphical_search_interface/providers/offset_provider.dart';

// ignore: use_key_in_widget_constructors
class DrawMotionDetector extends StatefulWidget {
  @override
  _DrawMotionDetectorState createState() => _DrawMotionDetectorState();
}

class _DrawMotionDetectorState extends State<DrawMotionDetector> {
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);
    return GestureDetector(
      onPanDown: (details) {
        if (offsetProvider.drawing.isNotEmpty) {
          /// If the drawing is not empty we will check if the given local
          /// position is in the range of [5,-10], where -10 represents the 10th
          /// element from the end of the drawing. After checking these
          /// conditions we need to make sure if the given local position is in
          /// our drawing already.
          /// In case of match offsetProvider.returnPosition(...) returns an
          /// Object of type Offset which is not Offset.zero .
          /// If all these conditions return the value true that means that the
          /// User clicked on line, to enable Local Changes Mode, so we need to
          /// set up our DragPosition which will be used for Local Changes.

          if (details.localPosition.dx <
                  offsetProvider
                      .drawing[offsetProvider.drawing.length - 10].dx &&
              details.localPosition.dx > offsetProvider.drawing[5].dx &&
              offsetProvider.returnPosition(details.localPosition) !=
                  Offset.zero) {
            offsetProvider.setDragPosition = details.localPosition;
          }
        } else {
          /// Otherwise if the drawing is empty, the User is about to start
          /// drawing. Since we want to limit our User's drawing space so no
          /// problems occur during drawing. In the OffsetProvider we created
          /// a variable for this limit, which is called
          /// _allowedMaximalStartingPosition. This way the User will be able to
          /// start drawing below ( to the left ) of this value.
          /// If the User starts drawing in the allowed region we need to
          /// dynamically calculate the min and max values which will represent
          /// the Min and Max lines on the screen.

          /// These values ( 0.260416667 and 0.781250001 ) were chosen so the
          /// lines can be displayed on almost every device. If this application
          /// will be used for real search in Time Series further consultations
          /// will be needed with the search algorithm developer on the topic of
          /// index lengths.

          if (details.localPosition.dx <
              offsetProvider.allowedMaximalStartingPosition) {
            offsetProvider.setMin = details.localPosition.dx +
                (offsetProvider.appWidth * 0.260416667);

            offsetProvider.setMax = details.localPosition.dx +
                (offsetProvider.appWidth * 0.781250001);

            offsetProvider.addToDrawing(
              Offset(
                details.localPosition.dx.round().toDouble(),
                details.localPosition.dy.round().toDouble(),
              ),
            );
          }
        }
      },
      onPanUpdate: (details) {
        /// We need to check first if the drawing is not empty. If it is not
        /// empty, that means a point was added in the onPanDown segment, and
        /// the User is currently drawing. We need to make sure that the User
        /// is not drawing backwards, because there are no loops in Time Series
        /// Data. If this newPoint is not in the drawing yet, we can add to it.

        if (offsetProvider.drawing.isNotEmpty) {
          Offset newPoint = Offset(details.localPosition.dx.round().toDouble(),
              details.localPosition.dy.round().toDouble());

          if (offsetProvider.isContinuation(
                  offsetProvider.drawing.last, newPoint) &&
              newPoint.dx < offsetProvider.max &&
              !offsetProvider.drawing.contains(newPoint) &&
              offsetProvider.isOnScreen(details.localPosition)) {
            offsetProvider.addToDrawing(
              newPoint,
            );
          }
        }
      },
      onPanEnd: (details) {
        /// If the User finished drawing, yet the drawing is shorter than the
        /// Minimum line, we need to inform the User to continue drawing,
        /// because this way we are unable to return ( generate ) results.
        /// The notification will be displayed on the bottom of the screen.

        if (offsetProvider.drawing.isNotEmpty &&
            offsetProvider.drawing.last.dx < offsetProvider.min) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Your Input is less than Minimum ! Please continue drawing !',
                textAlign: TextAlign.center,
              ),
              duration: Duration(
                seconds: 3,
              ),
            ),
          );
        } else {
          /// Otherwise if the User managed to draw a drawing above the Minimum
          /// line, we can now generate the result. We clear the redos, because
          /// we are now unable to redo anything since we just added new values.
          /// After this we save the length of the drawing, which will be used
          /// later during the Undo and Redo processes.

          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          offsetProvider.setIsFinished = true;

          offsetProvider.generateSearchResult(
            offsetProvider.drawing,
            "result",
          );

          offsetProvider.setRedos = [];

          if (offsetProvider.drawingLength != offsetProvider.drawing.length) {
            offsetProvider.addNewDrawingsToUndos(offsetProvider.drawingLength);
          }

          offsetProvider.setDrawingLength = offsetProvider.drawing.length;

          offsetProvider.addNewDrawingsToUndos(
            offsetProvider.drawingLength,
          );

          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          offsetProvider.notifyListeners();
        }
      },
      child: Center(
        child: CustomPaint(
          painter:
              Painter(offsetProvider.drawing, const Color(0xff1f3c88), 5.0),
          child: SizedBox(
            height: offsetProvider.appHeight,
            width: offsetProvider.appWidth,
          ),
        ),
      ),
    );
  }
}
