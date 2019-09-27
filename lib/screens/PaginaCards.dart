import '../screens/CuentaCorriente.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart';
import '../screens/Checkout.dart';
import '../screens/Lista.dart';
import '../common/DrawerPancita.dart';
import '../common/SidePancita.dart';

import '../models/Producto.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../presentation/custom_icons_icons.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class PaginaCards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaginaCards();
  }
}

class _PaginaCards extends State<PaginaCards> {
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color secondary = Theme.of(context).primaryColorDark;
    var myProvider = Provider.of<MyProvider>(context);

    double iconSize = 30.0;
    final List<Widget> _children = [
      Lista(),
      // Filtros(),
      Checkout(),
      CuentaCorriente()
    ];

    _searchQuery.addListener((() {
      myProvider.filtro = _searchQuery.text;
    }));

    void _onHorizontalSwipe(SwipeDirection direction) {
      setState(() {
        if (direction == SwipeDirection.left) {
          if (myProvider.currentIndex == 0)
            myProvider.currentIndex = 0;
          else
            myProvider.currentIndex -= 1;
        }

        if (direction == SwipeDirection.right) {
          if (myProvider.currentIndex == 2)
            myProvider.currentIndex = 2;
          else
            myProvider.currentIndex += 1;
        }
      });
    }

    Widget _buildLogoCal() {
      return Image.asset(
        'assets/calzetta_logo_white.png',
        fit: BoxFit.scaleDown,
        width: 120.0,
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: DrawerPancita(),
        primary: true,
        bottomNavigationBar: CurvedNavigationBar(
          // key: _bottomNavigationKey,
          index: myProvider.currentIndex,
          height: 50.0,
          items: <Widget>[
            // Icon(CustomIcons.format_list_numbered,color: Colors.white, size: 30),
            Icon(Icons.list, color: Colors.white, size: 30),
            // Icon(Icons.shopping_cart,color: Colors.white, size: 30),

            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                // myProvider.obtenerListaCarrito.length == 0
                //     ? Container()
                //     :
                Positioned(
                  top: 15.0,                 
                  // right: (30 * 2 ) - 10.0,
                  // right:-10,
                  // left: 0,
                  child: Stack(
                    children: <Widget>[
                      Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: secondary,
                      ),
                      Positioned(
                        top: 3.0,
                        right: 5.5,
                        child: Center(
                          child: Text(
                            "1",
                            // myProvider.obtenerListaCarrito.length
                            //     .toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Icon(Icons.account_balance, color: Colors.white, size: 30),
          ],
          color: primary,
          buttonBackgroundColor: secondary,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              myProvider.currentIndex = index;
            });
          },
        ),
        // bottomNavigationBar: Container(
        //   height: 60,
        //   child: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     showSelectedLabels: true,
        //     iconSize: iconSize,
        //     backgroundColor: Colors.blue,
        //     fixedColor: Colors.white,
        //     currentIndex: myProvider.currentIndex,
        //     onTap: (index) {
        //       setState(() {
        //         myProvider.currentIndex = index;
        //       });
        //     },
        //     items: [
        //       BottomNavigationBarItem(
        //         icon: Icon(CustomIcons.format_list_numbered),
        //         title: Text("Lista"),
        //       ),
        // BottomNavigationBarItem(
        //   icon: Stack(
        //     alignment: Alignment.topCenter,
        //     children: <Widget>[
        //       Icon(Icons.shopping_cart),
        //       myProvider.obtenerListaCarrito.length == 0
        //           ? Container()
        //           : Positioned(
        //               top: -1.0,
        //               left: 8.0,
        //               child: Stack(
        //                 children: <Widget>[
        //                   Icon(
        //                     Icons.brightness_1,
        //                     size: 20.0,
        //                     color: Colors.deepOrange,
        //                   ),
        //                   Positioned(
        //                     top: 4.0,
        //                     right: 5.5,
        //                     child: Center(
        //                       child: Text(
        //                         myProvider.obtenerListaCarrito.length
        //                             .toString(),
        //                         style: TextStyle(
        //                             color: Colors.white,
        //                             fontSize: 11.0,
        //                             fontWeight: FontWeight.w500),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //     ],
        //   ),
        //         title: Text("Carrito"),
        //       ),
        //       BottomNavigationBarItem(
        //         // icon: Icon(Icons.account_balance),
        //         icon: Icon(
        //           CustomIcons.bank,
        //           size: 24.0,
        //         ),
        //         title: Text("Cuenta Co."),
        //       ),
        //     ],
        //   ),
        // ),
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => Container(
                width: 100,
                child: IconButton(
                    icon: Row(
                      children: <Widget>[
                        Text(
                          "Filtro",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Icon(Icons.filter_list),
                      ],
                    ),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: "Abrir menu de Filtros"),
              ),
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildLogoCal(),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomPadding: false,
        body: SimpleGestureDetector(
            onHorizontalSwipe: _onHorizontalSwipe,
            swipeConfig: SimpleSwipeConfig(
                horizontalThreshold: 40.0,
                verticalThreshold: 40.0,
                swipeDetectionBehavior:
                    SwipeDetectionBehavior.continuousDistinct),
            child: Stack(
              children: <Widget>[
                _children[myProvider.currentIndex],
                SidePancita(),
              ],
            )),
      ),
    );
  }
}
