import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {

    var data = [87.46735,83.72176,69.20964,22.98934,54.01596,3.33306,26.87905,98.22666,57.40952,6.49221,20.76210,90.81320,79.39495,42.47922,59.08498,37.44724,64.34899,83.40307,15.67635,61.07346,13.89759,42.46647,98.19771,95.88364,85.90779,16.27655,48.39985,18.17205,37.47623,14.34084,12.91949,81.91059,35.24519,72.78184,30.71271,18.88061,48.90382,52.57156,70.43436,95.65400,89.88772,25.87272,29.40074,37.24680,33.47007,51.27674,38.75379,99.06398,8.48028,55.51606,65.64432,85.93267,12.31031,98.84450,68.51148,98.73263,83.35198,32.83553,39.84237,8.19447,97.90474,58.01564,35.33556,36.37792,29.96108,64.15246,64.52937,79.65637,83.24324,27.02783,16.46550,41.02470,50.57405,96.47769,72.75031,55.47269,25.56160,22.37658,37.35558,80.36929,6.02488,67.53873,23.81774,25.63850,39.47652,22.32359,49.31687,6.60921,67.33152,47.13076,16.16737,5.45345,58.20066,81.98958,20.24940,12.69224,9.97610,61.95621,98.80476,5.41409,94.59842,60.66964,12.15265,10.47777,20.96440,11.61265,96.58650,78.25907,71.05802,49.52132,9.88468,40.26110,29.15069,76.70992,65.90221,94.77005,18.63113,46.24727,64.12497,51.78470,18.57228,49.69654,78.34220,73.00507,98.61458,15.33703,35.10334,28.79094,12.66753,94.07483,87.21858,84.93575,51.84862,94.88034,37.03129,80.12616,56.47822,39.66431,33.53900,27.33056,88.18292,76.63924,3.99213,2.35187,11.89460,44.77855,23.56341,19.16932,66.20313,76.54035,18.54363,38.34890,82.70715,32.02775,82.36039,21.19587,62.41325,58.48074,52.12887,31.16396,99.95892,80.42563,79.32969,23.93673,43.06518,51.05724,8.99087,54.42024,61.73603,4.37241,23.00047,25.06575,45.80867,3.29202,8.98605,41.16890,17.62916,23.95075,95.64287,78.00703,47.04360,74.47625,13.15803,95.92670,43.47745,37.38048,59.77506,85.25297,1.21314,92.47113,23.84108,87.77989,72.26116,44.44319,88.69903,57.68703,89.10736,82.30663,53.19073,5.93364,7.64546,48.43726,45.42279,78.18033,85.35994,34.23099,58.59518,53.88477,84.30298,44.60248,38.57399,19.21403,44.60828,75.67676,69.68032,94.51197,62.85231,39.16042,7.06847,19.14645,42.38120,72.55955,28.70433,47.96642,8.91232,51.32765,71.84002,53.50140,91.75305,90.51021,99.64366,92.78019,9.41530,94.61580,21.62949,88.90173,26.44876,34.60799,46.48675,20.76364,56.89035,42.85360,74.48182,57.52518,14.37685,37.18417,83.86431,78.84289,56.98532,40.68313];
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Stack(children: [
        finished && _offsets.isNotEmpty ? chart(data)  : Container(),
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