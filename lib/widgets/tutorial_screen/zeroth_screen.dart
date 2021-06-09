import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';

// ignore: use_key_in_widget_constructors
class ZerothScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return Container(
      color: Colors.lightBlue.withOpacity(0.1),
      height: offsetProvider.appHeight,
      width: offsetProvider.allowedMaximalStartingPosition,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              const Text(
                "Start drawing in this region ",
                style: TextStyle(fontSize: 20.0),
              ),
              const Text(
                "and make sure to",
                style: TextStyle(fontSize: 20.0),
              ),
              const Text(
                "cross the Minimal line",
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
