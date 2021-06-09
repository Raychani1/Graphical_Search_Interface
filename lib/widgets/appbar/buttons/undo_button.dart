import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';

// ignore: use_key_in_widget_constructors
class UndoButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return  IconButton(
      icon: const Icon(Icons.undo),
      tooltip: 'Undo',
      onPressed: () {
        offsetProvider.undo();
        if (offsetProvider.drawing.isNotEmpty && offsetProvider.drawing.last.dx < offsetProvider.min) {
          offsetProvider.setIsFinished = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Your Input is less than Minimum ! Please continue drawing !',
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }
}