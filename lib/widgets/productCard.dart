import 'package:provider/provider.dart';
import '../providers/provider.dart';
import 'package:flutter/material.dart';

import '../models/Producto.dart';
import '../screens/ItemDetalles.dart';
import '../widgets/CustomBoxShadow.dart';

class ProductCard extends StatelessWidget {
  final Producto item;
  static const double height = 120.0;
  final ShapeBorder shape = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide:
          BorderSide(color: Colors.grey, width: .1, style: BorderStyle.solid));

  ProductCard({this.item});

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context);
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    // final TextStyle titleStyle =
    //     theme.textTheme.headline.copyWith(color: Colors.blue);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    void _logicaCarrito() {
      if (myProvider.obtenerListaCarrito
          .any((i) => i.articuloId == item.articuloId)) {
        myProvider.removerItemCarrito = item;
      } else {
        myProvider.agregarItemACarrito = item;
      }
    }

    Widget _buildBotonCarrito() {
      return IconButton(
        disabledColor: Colors.grey,
        color: Colors.green,
        // item.stockDisponible > 10
        //     ? Colors.green
        //     : item.stockDisponible > 5 ? Colors.deepOrange : Colors.red,
        icon: Icon(
          Icons.add_shopping_cart,
          size: 40,
        ),
        onPressed: item.stockDisponible == 0 ? null : _logicaCarrito,
      );
    }

    Widget _buildBotonCarritoQuitar() {
      return IconButton(
        // disabledColor: Colors.grey,
        color: Colors.deepOrange,
        icon: Icon(
          Icons.remove_shopping_cart,
          size: 40,
        ),
        onPressed: _logicaCarrito,
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        margin: EdgeInsets.all(2.0),
        height: height,
        // child: GestureDetector(
        //   onTap: () {
        //     print("KBIO PA");
        //   },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              CustomBoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0.0, 0.0),
                blurRadius: 2.6,
                blurStyle: BlurStyle.normal,
              )
            ],
          ),
          child: Card(
            color: Colors.white,
            shape: shape,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.15,
                  width: width * 0.4,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Hero(
                          tag: '${item.articuloId}',
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ItemDetalles(productSelected: item)));
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    alignment: Alignment.center,
                                    image: item.imagen == null
                                        ? AssetImage("assets/Logo Calzetta.png")
                                        : item.imagen),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(6.0, 4.0, 4.0, 6.0),
                    child: DefaultTextStyle(
                      style: descriptionStyle,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 0.0),
                            child: Text(item.descripcion,
                                softWrap: true,
                                style: descriptionStyle.copyWith(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Container(
                //   // padding: EdgeInsets.fromLTRB(6.0, 4.0, 4.0, 6.0),
                //   child: DefaultTextStyle(
                //     style: descriptionStyle,
                //     child: Column(
                //       // mainAxisSize: MainAxisSize.max,
                //       // mainAxisAlignment: MainAxisAlignment.start,
                //       // crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Padding(
                //           padding: EdgeInsets.only(bottom: 0.0),
                //           child: Text('\$ ${item.itemprice.toStringAsFixed(2)}',
                //           // textAlign: TextAlign.left,
                //               softWrap: true,
                //               style: descriptionStyle.copyWith(
                //                   fontFamily: 'Roboto',
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 16.0,
                //                   color: Colors.black.withOpacity(0.7))),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // IconButton(
                        //   // color: Colors.grey,
                        //   icon: Icon(
                        //     Icons.info_outline,
                        //     color: Colors.deepOrange[800],
                        //     size: 40,
                        //   ),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 ItemDetalles(productSelected: item)));
                        //   },
                        // ),
                        SizedBox(
                          width: 60.0,
                          child: myProvider.obtenerListaCarrito
                                  .any((i) => i.articuloId == item.articuloId)
                              ? _buildBotonCarritoQuitar()
                              : _buildBotonCarrito(),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
