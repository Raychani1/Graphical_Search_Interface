import 'dart:math';
import 'package:flutter/material.dart';

import 'package:graphical_search_interface/data_types/modification.dart';
import 'package:graphical_search_interface/data_types/undo_redo.dart';

class OffsetProvider with ChangeNotifier {
  /// Variables

  /// The height of the canvas which the User draws on
  double _appHeight = 0.0;

  /// The width of the canvas which the User draws on
  double _appWidth = 0.0;

  /// The limiting factor for the starting point of the drawing
  double _allowedMaximalStartingPosition = 0.0;

  /// The minimal length the User has to draw
  double _min = -1.0;

  /// The maximal length the User should not exceed
  double _max = -1.0;

  /// The minimal length displayed on the TutorialScreen
  double _tutorialMin = -1.0;

  /// The maximal length displayed on the TutorialScreen
  double _tutorialMax = -1.0;

  /// Represents the User's drawing
  List<Offset> _drawing = [];

  /// Represents the drawing on the TutorialScreen
  List<Offset> _tutorialDrawing = [];

  /// This will represent the length of drawing, based on this we will
  /// be able to add newly drawn elements to undo
  int _drawingLength = 0;

  /// This variable represents if the User finished drawing
  bool _isFinished = false;

  /// Represents the search result
  List<Offset> _result = [];

  /// Represents the search result for the TutorialScreen
  List<Offset> _tutorialResult = [];

  /// This variable represents the index of the element we want to change
  int _dragIndex = 0;

  /// This variable represents the position of the ball which the user will
  /// use for local changes in the drawing
  Offset _dragPosition = Offset.zero;

  /// This will store data which we can Undo / Remove using the Undo button in
  /// the toolbar.
  List<UndoRedo> _undos = [];

  /// This will store data which we can Redo / Add again using the Redo button in
  /// the toolbar.
  List<UndoRedo> _redos = [];

  /// Position of the DragBall
  Offset _position = Offset.zero;


  /// Getters and Setters

  double get appHeight {
    return _appHeight;
  }

  set setAppHeight(double appHeight) {
    _appHeight = appHeight;
  }

  double get appWidth {
    return _appWidth;
  }

  set setAppWidth(double appWidth) {
    _appWidth = appWidth;
  }

  double get allowedMaximalStartingPosition {
    return _allowedMaximalStartingPosition;
  }

  set setAllowedMaximalStartingPosition(double allowedMaximalStartingPosition) {
    _allowedMaximalStartingPosition = allowedMaximalStartingPosition;
  }

  double get min {
    return _min;
  }

  set setMin(double minValue) {
    _min = minValue;
  }

  double get max {
    return _max;
  }

  set setMax(double maxValue) {
    _max = maxValue;
  }

  double get tutorialMin {
    return _tutorialMin;
  }

  set setTutorialMin(double minValue) {
    _tutorialMin = minValue;
  }

  double get tutorialMax {
    return _tutorialMax;
  }

  set setTutorialMax(double maxValue) {
    _tutorialMax = maxValue;
  }

  List<Offset> get drawing {
    return [..._drawing];
  }

  set setDrawing(List<Offset> drawing) {
    _drawing = drawing;
  }

  List<Offset> get tutorialDrawing {
    return [..._tutorialDrawing];
  }

  set setTutorialDrawing(List<Offset> drawing) {
    _tutorialDrawing = drawing;
  }

  int get drawingLength {
    return _drawingLength;
  }

  set setDrawingLength(int length) {
    _drawingLength = length;
  }

  bool get isFinished {
    return _isFinished;
  }

  set setIsFinished(bool isFinished) {
    _isFinished = isFinished;
  }

  List<Offset> get result {
    return [..._result];
  }

  set setResult(List<Offset> result) {
    _result = result;
  }

  List<Offset> get tutorialResult {
    return [..._tutorialResult];
  }

  set setTutorialResult(List<Offset> result) {
    _tutorialResult = result;
  }

  int get dragIndex {
    return _dragIndex;
  }

  set setDragIndex(int dragIndex) {
    _dragIndex = dragIndex;
  }

  Offset get dragPosition {
    return _dragPosition;
  }

  set setDragPosition(Offset dragPosition) {
    _dragPosition = dragPosition;
  }

  List<UndoRedo> get undos {
    return [..._undos];
  }

  set setUndos(List<UndoRedo> modification) {
    _undos = modification;
  }

  List<UndoRedo> get redos {
    return [..._redos];
  }

  set setRedos(List<UndoRedo> modification) {
    _redos = modification;
  }

  Offset get position {
    return _position;
  }

  set setPosition(Offset offset) {
    _position = offset;
  }


  /// Functions

  /// Generate Minimal and Maximal lines
  List<Offset> generateMinMaxData(double value) {
    List<Offset> line = <Offset>[];

    for (int i = 0; i < _appHeight; i++) {
      line.add(Offset(value, i.toDouble()));
    }
    return line;
  }

  /// Generate Sine data for the TutorialScreen
  void generateSineData(Offset startingPosition, double max) {
    setTutorialDrawing = [];

    for (int i = 0; startingPosition.dx + i < max; i++) {
      _tutorialDrawing.add(Offset((startingPosition.dx + i),
          startingPosition.dy + (sin(i * -0.02) * 100)));
    }
  }

  /// Inserting value to the undos variable, which will be later used in undo
  void addToUndos(UndoRedo modification) {
    _undos.insert(0, modification);
  }

  void addNewDrawingsToUndos(int initialIndex) {
    for (int i = initialIndex; i < _drawing.length; i += 5) {
      if (_drawing.length - i < 5) {
        addToUndos(UndoRedo(Modification.remove, i,
            _drawing.getRange(i, _drawing.length).toList()));
      } else {
        addToUndos(UndoRedo(
            Modification.remove, i, _drawing.getRange(i, i + 5).toList()));
      }
    }
  }

  /// Inserting value to the redos variable, which will be later used in redo
  void addToRedos(UndoRedo modification) {
    _redos.insert(0, modification);
  }

  /// Undo latest modifications
  void undo() {
    if (_undos.isNotEmpty && _drawing.isNotEmpty) {
      if (_undos[0].modification == Modification.revert) {
        addToRedos(
          UndoRedo(
            Modification.change,
            _undos[0].index,
            _drawing
                .getRange(
              _undos[0].index,
              _undos[0].index + _undos[0].values.length + 1,
            )
                .toList(),
          ),
        );
        for (int i = 0; i < _undos[0].values.length; i++) {
          _drawing[_undos[0].index + i] = _undos[0].values[i];
        }
        _undos.removeAt(0);
      } else if (_undos[0].modification == Modification.remove) {
        addToRedos(
          UndoRedo(
            Modification.append,
            _undos[0].index,
            _drawing
                .getRange(
              _undos[0].index,
              _undos[0].index + _undos[0].values.length,
            )
                .toList(),
          ),
        );

        if (_undos[0].values.length - _undos[0].index == 5) {
          clearDrawing();
        } else {
          _drawing.removeRange(
            _undos[0].index,
            _undos[0].index + _undos[0].values.length,
          );

          _undos.removeAt(0);
        }
      }

      if (drawing.isNotEmpty &&
          min < drawing.last.dx &&
          drawing.last.dx < max) {
        setIsFinished = true;
      }

      setDrawingLength = drawing.length;

      generateSearchResult(_drawing, "result");
      notifyListeners();
    }
  }

  /// Redo latest undone modifications
  void redo() {
    if (_redos.isNotEmpty) {
      if (_redos[0].modification == Modification.change) {
        addToUndos(
          UndoRedo(
            Modification.revert,
            _redos[0].index,
            _drawing
                .getRange(
              _redos[0].index,
              _redos[0].index + _redos[0].values.length + 1,
            )
                .toList(),
          ),
        );
        for (int i = 0; i < _redos[0].values.length; i++) {
          _drawing[_redos[0].index + i] = _redos[0].values[i];
        }
        _redos.removeAt(0);
      } else if (_redos[0].modification == Modification.append) {
        addToUndos(
          UndoRedo(
            Modification.remove,
            _redos[0].index,
            _redos[0].values,
          ),
        );

        for (int i = 0; i < _redos[0].values.length; i++) {
          addToDrawing(_redos[0].values[i]);
        }

        if (_drawing.last.dx > _min) {
          setIsFinished = true;
        }
        _redos.removeAt(0);
      }

      generateSearchResult(_drawing, "result");
    }

    setDrawingLength = drawing.length;

    notifyListeners();
  }

  /// Clear the drawing board
  void clearDrawing() {
    setDrawing = [];
    setResult = [];
    setMin = -1.0;
    setMax = -1.0;
    setUndos = [];
    setRedos = [];
    setIsFinished = false;
    setDrawingLength = 0;
    notifyListeners();
  }

  /// Append to drawing
  void addToDrawing(Offset point) {
    _drawing.add(point);
    notifyListeners();
  }

  /// Checks if the User is drawing the continuation of a line
  bool isContinuation(Offset last, Offset next) {
    return ((last.dx <= next.dx) && ((next.dx - last.dx).abs() >= 0));
  }

  /// Check if the drawing is within the upper and lower border
  bool isOnScreen(Offset offset) {
    return (offset.dy > 0 && offset.dy < _appHeight);
  }

  /// Generates search result based on drawing
  void generateSearchResult(List<Offset> source, String destination) {
    if (source.isNotEmpty) {
      if (destination == "result") {
        setResult = [];
      } else {
        setTutorialResult = [];
      }

      var random = Random();

      for (int i = 0; i < source.length; i++) {
        Offset point = Offset(
          source[i].dx,
          (source[i].dy + (random.nextInt(31) - 20)),
        );
        if (destination == "result") {
          _result.add(point);
        } else {
          _tutorialResult.add(point);
        }
      }
    }
  }

  /// Return the nearest element for local changes
  Offset returnPosition(Offset cursor) {
    cursor = Offset(cursor.dx.round().toDouble(), cursor.dy.round().toDouble());

    for (int i = (cursor.dx - 5).round(); i <= cursor.dx + 5; i++) {
      for (int j = (cursor.dy - 5).round(); j <= cursor.dy + 5; j++) {
        if (_drawing.contains(Offset(i.toDouble(), j.toDouble()))) {
          setDragIndex = _drawing.indexOf(Offset(i.toDouble(), j.toDouble()));
          if (Offset(i.toDouble(), j.toDouble()) != _dragPosition) {
            notifyListeners();
            return Offset(i.toDouble(), j.toDouble());
          }
        }
      }
    }
    return Offset.zero;
  }

  /// Modify elements during local changes
  void changeDrawingValues(Offset offset) {
    double changeValue;
    double number = 1.8;
    int direction;

    if (offset.dy < _drawing[_dragIndex].dy) {
      changeValue = (offset - _drawing[_dragIndex]).dy.abs();
      direction = 1;
      notifyListeners();
    } else {
      changeValue = (offset - _drawing[_dragIndex]).dy;
      direction = -1;
      notifyListeners();
    }

    for (int i = _dragIndex - 4; i <= _dragIndex + 4; i++) {
      if (i == _dragIndex) {
        _drawing[i] = Offset(_drawing[i].dx, offset.dy);
        number += 0.2;
      } else {
        _drawing[i] = Offset(
          _drawing[i].dx,
          _drawing[i].dy - (changeValue * (1 - (number % 1.0)) * direction),
        );

        if (i < _dragIndex) {
          number -= 0.2;
        } else {
          number += 0.2;
        }
      }
    }
    notifyListeners();
  }

  /// Change Values for the Local Change on the Tutorial Screen
  List<Offset> changeTutorialValues(int index) {
    double number = 1.8;

    for (int i = index - 4; i <= index + 4; i++) {
      if (i == index) {
        _tutorialDrawing[i] =
            Offset(_tutorialDrawing[i].dx, _tutorialDrawing[i].dy + 50);
        number += 0.2;
      } else {
        _tutorialDrawing[i] = Offset(
          _tutorialDrawing[i].dx,
          _tutorialDrawing[i].dy - (150 * (1 - (number % 1.0)) * -1),
        );

        if (i < index) {
          number -= 0.2;
        } else {
          number += 0.2;
        }
      }
    }

    return _tutorialDrawing;
  }

  /// Regenerate the result on the Tutorial Screen after the Local Change
  List<Offset> regenerateTutorialResult() {
    generateSearchResult(_tutorialDrawing, "tutorialResult");
    return _tutorialResult;
  }
}
