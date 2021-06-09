import 'package:flutter/material.dart';

import 'package:graphical_search_interface/data_types/modification.dart';

class UndoRedo {
  final Modification _modification;
  final int _index;
  final List<Offset> _values;

  UndoRedo(this._modification, this._index, this._values);

  Modification get modification => _modification;

  int get index => _index;

  List<Offset> get values => _values;
}
