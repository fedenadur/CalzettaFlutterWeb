import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../models/Producto.dart';

class ItemDetalles extends StatefulWidget {
  final Producto productSelected;

  ItemDetalles({this.productSelected});

  @override
  State<StatefulWidget> createState() {
    return _ItemDetalles(productSelected);
  }
}

class _ItemDetalles extends State<ItemDetalles> {
  //String toolbarname = 'Detalle Producto';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Producto _productoSelected;

  _ItemDetalles(this._productoSelected);

  @override
  Widget build(BuildContext context) {

    var myProvider = Provider.of<MyProvider>(context);
    final ThemeData theme = Theme.of(context);
    // final TextStyle titleStyle =
    //     theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.display1;

    // Widget _buildIconCarrito() {
    //   return Stack(children: <Widget>[
    //     IconButton(
    //         icon: Icon(
    //           Icons.shopping_cart,
    //           color: Colors.white,
    //         ),
    //         onPressed: () {
    //           Navigator.push(
    //               context, MaterialPageRoute(builder: (context) => Checkout()));
    //         }),
    //     myProvider.obtenerListaCarrito.length == 0
    //         ? Container()
    //         : Positioned(
    //             child: Stack(
    //               children: <Widget>[
    //                 Icon(Icons.brightness_1,
    //                     size: 20.0, color: Colors.deepOrange),
    //                 Positioned(
    //                     top: 4.0,
    //                     right: 5.5,
    //                     child: Center(
    //                       child: Text(
    //                         myProvider.obtenerListaCarrito.length.toString(),
    //                         style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 11.0,
    //                             fontWeight: FontWeight.w500),
    //                       ),
    //                     )),
    //               ],
    //             ),
    //           )
    //   ]);
    // }

    Widget _buildBottonAgregar() {
      return ButtonTheme(
        minWidth: 260.0,
        height: 50.0,
        child: RaisedButton(
          color: Colors.green,
          child: const Text(
            'Agregar',
            style: TextStyle(fontSize: 25.0),
          ),
          textColor: Colors.white,
          onPressed: () {
            if (!myProvider.obtenerListaCarrito
                .any((i) => i.articuloId == _productoSelected.articuloId)) {
              myProvider.agregarItemACarrito = _productoSelected;
            } else {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text("El articulo ya se encuentra en el carrito"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Aceptar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      );
    }

    Widget _buildBotonSinStock() {
      return ButtonTheme(
        minWidth: 260.0,
        height: 50.0,
        child: FlatButton(
          color: Colors.red,
          // borderSide: BorderSide(color: Colors.amber.shade500),
          child: const Text(
            'Sin Stock',
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
          textColor: Colors.white,
          onPressed: () {
            // myProvider.quitarCheckout = _productoSelected;
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      );
    }

    Widget _buildBottonQuitar() {
      return ButtonTheme(
        minWidth: 260.0,
        height: 50.0,
        child: RaisedButton(
          color: Colors.red,
          // borderSide: BorderSide(color: Colors.amber.shade500),
          child: const Text(
            'Quitar',
            style: TextStyle(fontSize: 25.0),
          ),
          textColor: Colors.white,
          onPressed: () {
            myProvider.quitarCheckout = _productoSelected;
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          tooltip: 'Atras',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _productoSelected.descripcion,
          maxLines: 2,
          softWrap: true,
          style: TextStyle(fontFamily: 'Roboto', fontSize: 22.0),
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 0.0,
                child: Container(
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: '${_productoSelected.articuloId}',
                          child: Container(
                            height: 250.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: _productoSelected.imagen == null
                                    ? AssetImage("assets/Logo Calzetta.png")
                                    : _productoSelected.imagen,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: DefaultTextStyle(
                      style: descriptionStyle,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Stock: ' +
                                    _productoSelected.stockDisponible
                                        .toStringAsFixed(0),
                                style: descriptionStyle.copyWith(
                                    fontSize: 20.0, color: Colors.black),
                              ),
                              Text(
                                '\$ ' + _productoSelected.itemprice.toString(),
                                style: descriptionStyle.copyWith(
                                    fontSize: 20.0, color: Colors.black),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       bottom: 20.0, left: 40.0),
                              //   child: Text(
                              //     'Stock: ' +
                              //         _productoSelected.stockDisponible
                              //             .toStringAsFixed(0),
                              //     style: descriptionStyle.copyWith(
                              //         fontSize: 20.0, color: Colors.black),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       bottom: 20.0, left: 100.0),
                              //   child: Text(
                              //     '\$ ' +
                              //         _productoSelected.itemprice.toString(),
                              //     style: descriptionStyle.copyWith(
                              //         fontSize: 20.0, color: Colors.black),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _productoSelected.descripcion,
                              softWrap: true,
                              style: descriptionStyle.copyWith(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ))),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                    child: DefaultTextStyle(
                      style: descriptionStyle,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, left: 5.0, right: 5.0),
                            child: Container(
                              // alignment: Alignment.topLeft,
                              child: _productoSelected.stockDisponible == 0
                                  ? _buildBotonSinStock()
                                  : myProvider.obtenerListaCarrito.any((i) =>
                                          i.articuloId ==
                                          _productoSelected.articuloId)
                                      ? _buildBottonQuitar()
                                      : _buildBottonAgregar(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
