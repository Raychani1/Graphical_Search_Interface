import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/offset_provider.dart';
import 'package:graphical_search_interface/screens/tutorial_screen.dart';

// ignore: use_key_in_widget_constructors
class TutorialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OffsetProvider offsetProvider = Provider.of<OffsetProvider>(context);

    return IconButton(
      icon: const Icon(Icons.help),
      tooltip: 'Tutorial',
      onPressed: () {
        // Navigator.of(context).pushNamed(TutorialScreen.routeName);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: offsetProvider,
              child: TutorialScreen(),
            ),
          ),
        );
      },
    );
  }
}
