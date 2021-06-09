import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/data_types/undo_redo.dart';
import 'package:graphical_search_interface/data_types/modification.dart';
import 'package:graphical_search_interface/providers/offset_provider.dart';

class DragBall extends StatelessWidget {
  final Offset _initialPosition;

  // ignore: use_key_in_widget_constructors
  const DragBall(this._initialPosition);

  @override
  Widget build(BuildContext context) {
    var offsetProvider = Provider.of<OffsetProvider>(context);
    offsetProvider.setPosition = _initialPosition;

    return offsetProvider.position != Offset.zero
        ? Positioned(
            left: offsetProvider.position.dx,
            top: offsetProvider.position.dy,
            height: 15,
            width: 15,
            child: Draggable<Offset>(
              axis: Axis.vertical,
              data: Offset(
                  offsetProvider.position.dx, offsetProvider.position.dy),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onDraggableCanceled: (velocity, offset) {
                offsetProvider.setDrawingLength = offsetProvider.drawing.length;
                offsetProvider.addToUndos(
                  UndoRedo(
                    Modification.revert,
                    offsetProvider.dragIndex - 4,
                    offsetProvider.drawing
                        .getRange(
                          offsetProvider.dragIndex - 4,
                          offsetProvider.dragIndex + 5,
                        )
                        .toList(),
                  ),
                );
                offsetProvider.setRedos = [];
                offsetProvider.changeDrawingValues(offset);
                offsetProvider.setPosition = offset;
                offsetProvider.setDragPosition = Offset.zero;
                offsetProvider.generateSearchResult(
                    offsetProvider.drawing, "result");
              },
              feedback: Container(
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(),
              ),
              childWhenDragging: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(),
              ),
            ),
          )
        : Container();
  }
}
