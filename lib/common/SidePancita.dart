import 'package:flutter/material.dart';

import '../common/CurvedPainter.dart';

class SidePancita extends StatefulWidget {
  SidePancita({Key key}) : super(key: key);

  _SidePancitaState createState() => _SidePancitaState();
}

class _SidePancitaState extends State<SidePancita> {
  final double _btnSize = 48.0;
  final double _rightPadding = 5;
  double _extraOffcet = -20;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    double _height = MediaQuery.of(context).size.height * 0.795;
    double _btnY = _height / 2.08;

    return Container(
        child: Stack(
      children: <Widget>[
        Positioned(
          right: _extraOffcet,
          child: CustomPaint(
            size: Size(_btnSize, _height),
            painter: CurvedPainter(_btnSize, _btnY),
          ),
        ),
        Positioned(
            top: _btnY - _btnSize / 2 + 5,
            right: _extraOffcet + _rightPadding,
            child: GestureDetector(
                child: Material(
                  type: MaterialType.circle,
                  color: primary,
                  elevation: 4.0,
                  child: Container(
                    width: _btnSize - 10,
                    height: _btnSize - 10,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                })),
      ],
    ));
  }
}
