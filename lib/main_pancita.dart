import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Test(),
      ),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
  }


class _TestState extends State<Test> {
  final double _btnSize = 48.0;
  final double _rightPadding = 0;

  double _extraOffcet = 0;
  double _btnY;
  double _currentX;
  double _height;
  double _width;

  bool _isHorizontalActive = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    super.initState();
  }

  _afterLayout(_) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _btnY = _height / 2;
    setState(() {});
  }

  _onDrag(details) {
    _updateCoordinates(
      details.globalPosition.dx,
      details.globalPosition.dy,
    );
  }

  _updateCoordinates(double x, double y) {
    setState(() {
      if (_isHorizontalActive) {
        _updateX(x);
      }
    });
  }

  _updateX(x) {
    var dx = _currentX - x;
    _currentX = x;
    _extraOffcet = _extraOffcet + dx;
    _extraOffcet = math.max(_extraOffcet, _rightPadding);
    _extraOffcet = math.min(_extraOffcet, _width - _btnSize);
  }

  _listItem(String text, double height) {
    return Container(
      height: height,
      child: Text(text, style: TextStyle(fontSize: 20.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _height == null
        ? Container()
        : Stack(
            children: <Widget>[
              Positioned(
                right: _extraOffcet + _rightPadding,
                child: CustomPaint(
                  size: Size(_btnSize, _height),
                  painter: CurvedPainter(_btnSize, _btnY),
                ),
              ),
              Positioned(
                top: _btnY - _btnSize / 2 + 5,
                right: _extraOffcet + _rightPadding + 5,
                child: GestureDetector(
                  onPanDown: (details) {
                    _currentX = details.globalPosition.dx;
                  },
                  onPanStart: _onDrag,
                  onPanUpdate: _onDrag,
                  child: Material(
                    type: MaterialType.circle,
                    color: Colors.white,
                    elevation: 8.0,
                    child: Container(
                      width: _btnSize - 10,
                      height: _btnSize - 10,
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: _width - _extraOffcet,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(8, (index) => _listItem('from right', 20)),
                  ),
                  height: _height,
                  width: _width,
                ),
              ),
            ],
          );
  }
}

class CurvedPainter extends CustomPainter {
  CurvedPainter(this.btnSize, this.btnY);

  final double btnSize;
  final double btnY;

  @override
  void paint(Canvas canvas, Size size) {
    var halfBtnSize = btnSize / 2;
    var xMax = size.width;
    var yMax = size.height;

    var path = Path()
      ..moveTo(halfBtnSize, yMax)
      ..lineTo(halfBtnSize, btnY + halfBtnSize * 2)
      ..cubicTo(halfBtnSize, btnY + halfBtnSize, 0, btnY + halfBtnSize, 0, btnY)
      ..cubicTo(0, btnY - halfBtnSize, halfBtnSize, btnY - halfBtnSize, halfBtnSize,
          btnY - halfBtnSize * 2)
      ..lineTo(halfBtnSize, 0)
      ..lineTo(xMax, 0)
      ..lineTo(xMax, yMax);

    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CurvedPainter oldDelegate) => oldDelegate.btnY != btnY;
}