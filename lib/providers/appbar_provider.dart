import 'package:flutter/material.dart';

class AppBarProvider with ChangeNotifier {
  /// Variables

  /// By default our toolbar will be closed on starting the App
  bool _isToolbarOpen = false;


  /// Getters and Setters

  bool get isToolbarOpen {
    return _isToolbarOpen;
  }

  set setIsToolbarOpen(bool isOpen) {
    _isToolbarOpen = isOpen;
  }


  /// Functions

  /// Switch the visibility of the Toolbar
  void toggleToolbar() {
    setIsToolbarOpen = !isToolbarOpen;
    notifyListeners();
  }
}
