import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/providers/appbar_provider.dart';
import 'package:graphical_search_interface/widgets/appbar/buttons/undo_button.dart';
import 'package:graphical_search_interface/widgets/appbar/buttons/redo_button.dart';
import 'package:graphical_search_interface/widgets/appbar/buttons/clear_button.dart';
import 'package:graphical_search_interface/widgets/appbar/buttons/tutorial_button.dart';
import 'package:graphical_search_interface/widgets/appbar/buttons/open_toolbar_button.dart';
import 'package:graphical_search_interface/widgets/appbar/buttons/close_toolbar_button.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    AppBarProvider appBarProvider = Provider.of<AppBarProvider>(context);

    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xfff6f5f5)),
      title: const Text(
        'Graphical Search in Time Series',
        style: TextStyle(
          color: Color(
            0xfff6f5f5,
          ),
        ),
      ),
      actions: appBarProvider.isToolbarOpen
          ? <Widget>[
              UndoButton(),
              RedoButton(),
              ClearButton(),
              TutorialButton(),
              CloseToolbarButton(),
            ]
          : <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: MouseRegion(
                  onHover: (event) => appBarProvider.toggleToolbar(),
                  child: OpenToolbarButton(),
                ),
              )
            ],
    );
  }
}
