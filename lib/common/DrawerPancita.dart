import 'package:flutter/material.dart';

import '../screens/Filtros.dart';
import '../common/CurvedPainter.dart';

class DrawerPancita extends StatefulWidget {
  DrawerPancita({Key key}) : super(key: key);

  _DrawerPancitaState createState() => _DrawerPancitaState();
}

class _DrawerPancitaState extends State<DrawerPancita> {
  final double _btnSize = 48.0;
  double _btnY;
  double _height;
  double _width;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    super.initState();
  }

  //meterlo en el
  _afterLayout(_) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _btnY = _height / 2;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _btnY = _height / 2;

    return Stack(
      children: <Widget>[
        Positioned(
          right: _width * 0.8,
          child: CustomPaint(
            size: Size(_btnSize, _height),
            painter: CurvedPainter(_btnSize, _btnY),
          ),
        ),
        Positioned(
          top: _btnY - _btnSize / 2 + 5,
          right: _width * 0.8 + 5,
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
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          width: _width * 0.8,
          child: Container(
            color: Colors.white,
            child: Filtros(),
            height: _height,
            width: _width,
          ),
        ),
      ],
    );
  }
}
