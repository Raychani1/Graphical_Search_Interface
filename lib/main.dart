import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'painter.dart';

void main() {
  runApp(MyApp());
}

bool toolbarOpen = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Graphical Search in Time Series',
      theme: ThemeData(
        primaryColor: Color(0xff070d59),
        fontFamily: 'Product Sans',
      ),
      home: MyHomePage(title: 'Graphical Search in Time Series'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _offsets = <Offset>[];

  void openToolbar() {
    setState(() {
      toolbarOpen = true;
    });
  }

  void closeToolbar() {
    setState(() {
      toolbarOpen = false;
    });
  }

  bool isContinuation(Offset last, Offset next) {
    return ((((next.dx - last.dx).abs() >= 0) &&
            ((next.dx - last.dx).abs() <= 20)) &&
        (((next.dy - last.dy).abs() >= 0) &&
            ((next.dy - last.dy).abs() <= 20)));
  }

  @override
  Widget build(BuildContext context) {
    bool finished = false;
    bool drawingMode = true;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xfff6f5f5)),
        title: Text(widget.title, style: TextStyle(color: Color(0xfff6f5f5))),
        actions: toolbarOpen
            ? <Widget>[
                MouseRegion(
                  onExit: (event) => closeToolbar(),
                  child: Row(
                      children: kIsWeb
                          ? <Widget>[
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit',
                                  color: drawingMode
                                      ? Color(0xffee6f57)
                                      : Color(0xfff6f5f5),
                                  onPressed: () {
                                    setState(() {
                                      drawingMode = true;
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(const IconData(0xe900,
                                      fontFamily: 'eraser')),
                                  tooltip: 'Erase',
                                  color: drawingMode
                                      ? Color(0xfff6f5f5)
                                      : Color(0xffee6f57),
                                  onPressed: () {
                                    setState(() {
                                      drawingMode = false;
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.undo),
                                  tooltip: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      if (_offsets.length < 5) {
                                        _offsets.removeRange(
                                            0, _offsets.length);
                                      } else {
                                        _offsets.removeRange(
                                            _offsets.length - 5,
                                            _offsets.length);
                                      }
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Clear Drawing',
                                  onPressed: () {
                                    setState(() {
                                      _offsets = [];
                                    });
                                  }),
                            ]
                          : <Widget>[
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit',
                                  color: drawingMode
                                      ? Color(0xffee6f57)
                                      : Color(0xfff6f5f5),
                                  onPressed: () {
                                    setState(() {
                                      drawingMode = true;
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(const IconData(0xe900,
                                      fontFamily: 'eraser')),
                                  tooltip: 'Erase',
                                  color: drawingMode
                                      ? Color(0xfff6f5f5)
                                      : Color(0xffee6f57),
                                  onPressed: () {
                                    setState(() {
                                      drawingMode = false;
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.undo),
                                  tooltip: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      if (_offsets.length < 5) {
                                        _offsets.removeRange(
                                            0, _offsets.length);
                                      } else {
                                        _offsets.removeRange(
                                            _offsets.length - 5,
                                            _offsets.length);
                                      }
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Clear Drawing',
                                  onPressed: () {
                                    setState(() {
                                      _offsets = [];
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.navigate_next),
                                  tooltip: 'Close Toolbar',
                                  splashRadius: 0.1,
                                  onPressed: () {
                                    closeToolbar();
                                  }),
                            ]),
                ),

//                IconButton(
//                    icon: const Icon(Icons.edit),
//                    tooltip: 'Edit',
//                    color: drawingMode ? Color(0xffee6f57) : Color(0xfff6f5f5),
//                    onPressed: () {
//                      setState(() {
//                        drawingMode = true;
//                      });
//                    }),
//                IconButton(
//                    icon: const Icon(
//                        const IconData(0xe900, fontFamily: 'eraser')),
//                    tooltip: 'Erase',
//                    color: drawingMode ? Color(0xfff6f5f5) : Color(0xffee6f57),
//                    onPressed: () {
//                      setState(() {
//                        drawingMode = false;
//                        closeToolbar();
//                      });
//                    }),
//                IconButton(
//                    icon: const Icon(Icons.undo),
//                    tooltip: 'Undo',
//                    onPressed: () {
//                      setState(() {
//                        if (_offsets.length < 5) {
//                          _offsets.removeRange(0, _offsets.length);
//                        } else {
//                          _offsets.removeRange(
//                              _offsets.length - 5, _offsets.length);
//                        }
//                      });
//                    }),
//                IconButton(
//                    icon: const Icon(Icons.clear),
//                    tooltip: 'Clear Drawing',
//                    onPressed: () {
//                      setState(() {
//                        _offsets = [];
//                        closeToolbar();
//                      });
//                    }),
//                IconButton(
//                    icon: const Icon(Icons.navigate_next),
//                    tooltip: 'Close Toolbar',
//                    splashRadius: 0.1,
//                    onPressed: () {
//                      closeToolbar();
//                    }),
              ]
            : <Widget>[
//                MouseRegion(
//                  onHover: (event) => openToolbar(),
//                  onExit: (event) => closeToolbar(),
//                  child: IconButton(
//                      icon: const Icon(Icons.navigate_before),
//                      tooltip: 'Show Toolbar',
//                      splashRadius: 0.1,
//                      onPressed: () {
//                        openToolbar();
//                      }),
//                ),
                MouseRegion(
                  onHover: (event) => openToolbar(),
                  child: IconButton(
                      icon: const Icon(Icons.construction),
                      tooltip: 'Show Toolbar',
                      splashRadius: 0.1,
                      onPressed: () {
                        openToolbar();
                      }),
                ),
              ],
      ),
      body: GestureDetector(
        onPanDown: (details) {
          if (_offsets.isNotEmpty) {
            if (isContinuation(
                _offsets[_offsets.length - 1], details.localPosition)) {
              finished = false;
              setState(() {
                _offsets.add(details.localPosition);
              });
            }
          } else {
            setState(() {
              _offsets.add(details.localPosition);
            });
          }
        },
        onPanUpdate: (details) {
          if (details.localPosition.dx >= _offsets.last.dx &&
              isContinuation(
                  _offsets[_offsets.length - 1], details.localPosition)) {
            // THIS CAUSES PROBLEMS
            setState(() {
              _offsets.add(details.localPosition);
            });
          }
        },
        onPanEnd: (details) {
          finished = true;
        },
        child: Center(
          child: CustomPaint(
            painter: Painter(_offsets),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
