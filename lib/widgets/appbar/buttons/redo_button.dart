import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';

// ignore: use_key_in_widget_constructors
class RedoButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return  IconButton(
        icon: const Icon(Icons.redo),
        tooltip: 'Redo',
        onPressed: () {
          offsetProvider.redo();
        });
  }
}