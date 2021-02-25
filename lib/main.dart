import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'painter.dart';

void main() {
  runApp(MyApp());
}

bool toolbarOpen = false;
bool drawingMode = true;
bool finished = false;

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

  void toggleToolbar() {
    setState(() {
      toolbarOpen = !toolbarOpen;
    });
  }

  void draw() {
    setState(() {
      drawingMode = true;
    });
  }

  void erase() {
    setState(() {
      drawingMode = false;
    });
  }

  bool isContinuation(Offset last, Offset next) {
    return ((((next.dx - last.dx).abs() >= 0) &&
            ((next.dx - last.dx).abs() <= 20)) &&
        (((next.dy - last.dy).abs() >= 0) &&
            ((next.dy - last.dy).abs() <= 20)));
  }

  List<double> generateData(double appWidth, double appHeight) {
    List<double> result = [];
    if (_offsets.isNotEmpty) {
      Random random = new Random();

      for (int i = 0; i < appWidth; i++) {
        if (i < _offsets[0].dx.floor() || i > _offsets.last.dx.floor()) {
          result.add((random.nextInt(appHeight.floor())+ 1).toDouble());
        } else {
          for (int j = 0; j < _offsets.length; j++) {
            result.add(
                ((-_offsets[j].dy.floor()+appHeight) + random.nextInt(21) - 10).toDouble());
            i++;
          }
        }
      }
    }
    return result;
  }

  List<double> readServerResponse(String jsonString){
    Map<String,dynamic> data = jsonDecode(jsonString);
    print(data);
    return null;
  }

  //

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xfff6f5f5)),
      title: Text(widget.title, style: TextStyle(color: Color(0xfff6f5f5))),
      actions: toolbarOpen
          ? <Widget>[
              MouseRegion(
                onExit: (event) => toggleToolbar(),
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
                                    draw();
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
                                    erase();
                                  });
                                }),
                            IconButton(
                                icon: const Icon(Icons.undo),
                                tooltip: 'Undo',
                                onPressed: () {
                                  setState(() {
                                    if (_offsets.length < 5) {
                                      _offsets.removeRange(0, _offsets.length);
                                    } else {
                                      _offsets.removeRange(
                                          _offsets.length - 5, _offsets.length);
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
                                })
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
                                    draw();
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
                                    erase();
                                  });
                                }),
                            IconButton(
                                icon: const Icon(Icons.undo),
                                tooltip: 'Undo',
                                onPressed: () {
                                  setState(() {
                                    if (_offsets.length < 5) {
                                      _offsets.removeRange(0, _offsets.length);
                                    } else {
                                      _offsets.removeRange(
                                          _offsets.length - 5, _offsets.length);
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
                                  toggleToolbar();
                                }),
                          ]),
              ),
            ]
          : <Widget>[
              MouseRegion(
                onHover: (event) => toggleToolbar(),
                child: IconButton(
                    icon: const Icon(Icons.construction),
                    tooltip: 'Show Toolbar',
                    splashRadius: 0.1,
                    onPressed: () {
                      toggleToolbar();
                    }),
              ),
            ],
    );

    // Get the width and height of the app for search result generation
    var mediaQuery = MediaQuery.of(context);
    var appHeight = mediaQuery.size.height - appBar.preferredSize.height;
    var appWidth = mediaQuery.size.width;
    print(appHeight);

    List<double> data = generateData(appWidth, appHeight);
//    String json =
//    List<double> data = readServerResponse("json/server_response.json");
    return Scaffold(
      appBar: appBar,
      body: Stack(children: [
        finished && _offsets.isNotEmpty ? chart(data) : Container(),
        GestureDetector(
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
            finished = false;
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
            setState(() {
              finished = true;
            });
            print(data);
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
      ]),
    );
  }
}

Material chart(data) {
  return Material(
    color: Colors.white,
    child: Center(
      child: new Sparkline(
        data: data,
        lineColor: Color(0xffee6f57),
        pointsMode: PointsMode.none,
        pointSize: 8.0,
      ),
    ),
  );
}
