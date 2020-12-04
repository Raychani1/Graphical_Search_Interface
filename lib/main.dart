import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

  bool isContinuation(Offset last, Offset next){
    return
      ((((next.dx -last.dx).abs() >=0) && ((next.dx -last.dx).abs() <=20)) &&
       (((next.dy -last.dy).abs() >=0) && ((next.dy -last.dy).abs() <=20)));
  }

  @override
  Widget build(BuildContext context) {
    bool finished = false;
    bool drawingMode = true;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color(0xfff6f5f5)
        ),
        title: Text(widget.title, style: TextStyle(
            color: Color(0xfff6f5f5)
        )),
        actions: toolbarOpen ? <Widget>[
            IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                color: drawingMode ? Color(0xffee6f57) : null,
                onPressed: () {
                  setState(() {
                    _offsets = [];
                  });
                }),
            IconButton(
                icon: const Icon(const IconData(0xe900, fontFamily: 'eraser')),
                tooltip: 'Erase',
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
                  closeToolbar();
                }),
        ] : <Widget>[
          IconButton(
              icon: const Icon(Icons.navigate_before),
              tooltip: 'Show Toolbar',
              splashRadius: 0.1,
              onPressed: () {
                openToolbar();

              }),
        ],
      ),
      body: GestureDetector(
          onPanDown: (details) {
            if (_offsets.isNotEmpty) {
              if (isContinuation(_offsets[_offsets.length-1],details.localPosition) ) {
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
//            if(_offsets.last != null) {
//              if (details.localPosition.dx >= _offsets.last.dx && (((details.localPosition.dy - _offsets.last.dy).abs() >0) && ((details.localPosition.dy - _offsets.last.dy).abs() <=1)) ) {
//                setState(() {
//                  _offsets.add(details.localPosition);
//                });
//              }
//            } else {
//              if(isContinuation(_offsets[_offsets.length-1], details.localPosition)){
//                setState(() {
//                  _offsets.add(details.localPosition);
//                });
//              }
//            }
            if(details.localPosition.dx >= _offsets.last.dx && isContinuation(_offsets[_offsets.length-1],details.localPosition)) { // THIS CAUSES PROBLEMS
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
