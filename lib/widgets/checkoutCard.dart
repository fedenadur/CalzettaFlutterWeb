import 'package:provider/provider.dart';
import '../providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CheckoutCard extends StatelessWidget {
  // final Producto item;
  final int index;
  static const double height = 120.0;
  final ShapeBorder shape = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide:
          BorderSide(color: Colors.grey, width: 2.0, style: BorderStyle.solid));

  // CheckoutCard({this.item});
  CheckoutCard(this.index);

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context);

    executeAfterBuild(myProvider);

    return Column(
      children: <Widget>[
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.centerRight,
            child: Text(
              "Eliminar",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Roboto', fontSize: 16.0),
            ),
            color: Colors.red,
          ),
          key: Key(myProvider.obtenerListaCarrito[index].descripcion),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              print("se elimino el index " +
                  index.toString() +
                  " y articulo Id  " +
                  myProvider.obtenerListaCarrito[index].articuloId.toString());
              myProvider.removerItemCarrito =
                  myProvider.obtenerListaCarrito[index];
            }
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
            color: Colors.transparent,
            child: Wrap(
                spacing: 5.0,
                runSpacing: 2.0,
                direction: Axis.vertical,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        image:
                            myProvider.obtenerListaCarrito[index].imagen == null
                                ? AssetImage("assets/Logo Calzetta.png")
                                : myProvider.obtenerListaCarrito[index].imagen,
                        width: 80.0,
                        height: 80.0,
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width * 0.22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                                myProvider
                                    .obtenerListaCarrito[index].descripcion,
                                softWrap: true,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            Row(
                              children: <Widget>[
                                IconButton(                                  
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),                                  
                                  onPressed: () {
                                    myProvider.bajarCantidad = myProvider
                                        .obtenerListaCarrito[index].articuloId;

                                    myProvider.calcularSubtotal =
                                        myProvider.obtenerListaCarrito;
                                    myProvider.calcularTotal = true;
                                  },
                                ),
                                Text(myProvider
                                    .obtenerListaCarrito[index].cantidad
                                    .toInt()
                                    .toString()),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    myProvider.aumentarCantidad = myProvider
                                        .obtenerListaCarrito[index].articuloId;

                                    myProvider.calcularSubtotal =
                                        myProvider.obtenerListaCarrito;
                                    myProvider.calcularTotal = true;
                                  },
                                ),
                                Text(
                                    '\$ ' +
                                        myProvider.obtenerListaCarrito[index]
                                            .itemprice
                                            .toStringAsFixed(2),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   color: Colors.red,
                      //   icon: Icon(
                      //     Icons.delete,
                      //     size: 34.0,
                      //   ),
                      //   onPressed: () {
                      //     myProvider.quitarCheckout =
                      //         myProvider.obtenerListaCarrito[index];

                      //     myProvider.calcularSubtotal =
                      //         myProvider.obtenerListaCarrito;
                      //     myProvider.calcularTotal = true;
                      //   },
                      // )
                    ],
                  ),
                ]),
          ),
        ),
        myProvider.obtenerListaCarrito.length == (index + 1)
            ? Container()
            : Divider(color: Colors.black.withOpacity(0.5)),
      ],
    );
  }

  Future<void> executeAfterBuild(MyProvider myProvider) async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      myProvider.calcularSubtotal = myProvider.obtenerListaCarrito;
      myProvider.calcularTotal = true;
    });
  }
}
