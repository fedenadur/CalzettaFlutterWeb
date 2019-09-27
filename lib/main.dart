import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:simple_animations/simple_animations.dart';

import 'screens/Auth.dart';
import 'screens/PaginaCards.dart';
import 'providers/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
  //   runApp(MyApp());
  // });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FadeIn();
}

class FadeIn extends State<MyApp> {
  bool _redirect = false;

  FadeIn() {
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _redirect = true;
      });
    });
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          child: child,
          alignment: Alignment.bottomCenter,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => MyProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        title: 'Calzetta App',
        routes: {
          '/Auth': (context) => Auth(),
          '/PaginaCards': (context) => PaginaCards(),
        },
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(0, 21, 42, 1),
          primaryColorDark: Colors.lightBlue,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: 
        // _redirect
        //     ? 
            Auth(
                title: 'CALZETTA APP',
              )
            // : Scaffold(
            //     body: Stack(
            //       children: <Widget>[
            //         Positioned.fill(
            //           child: Container(
            //             decoration: BoxDecoration(
            //               gradient: RadialGradient(
            //                 center: Alignment(0, 0),
            //                 radius: 0.85,
            //                 colors: [
            //                   Colors.white,
            //                   Color.fromRGBO(76, 152, 227, 1),

            //                   // Color.fromRGBO(76, 152, 227, 0.2),
            //                   // Color.fromRGBO(76, 152, 227, 1),
            //                 ],
            //                 stops: [0.1, 50],
            //               ),
            //             ),
            //             child: Center(
            //               child: Container(
            //                 height: 80,
            //                 child: Image.asset('assets/Logo Calzetta.png',
            //                     fit: BoxFit.scaleDown),
            //               ),
            //             ),
            //           ),
            //         ),
            //         onBottom(AnimatedWave(
            //           height: 160,
            //           speed: 0.5,
            //         )),
            //         onBottom(AnimatedWave(
            //           height: 120,
            //           speed: 0.9,
            //           offset: pi,
            //         )),
            //         onBottom(
            //           AnimatedWave(
            //             height: 220,
            //             speed: 1.2,
            //             offset: pi / 5,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
      ),
    );
  }
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}