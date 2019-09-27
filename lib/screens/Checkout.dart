import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../widgets/checkoutCard.dart';
import '../screens/ConfirmarPed.dart';

import '../widgets/CustomBoxShadow.dart';

class Checkout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Checkout();
  }
}

class _Checkout extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context);
    Color primary = Theme.of(context).primaryColor;
    Color secondary = Theme.of(context).primaryColorDark;

    TextStyle styleTotal =
        TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold);
    // TextStyle style1 = TextStyle(
    //   fontSize: 18.0,
    // );

    BoxDecoration boxDeco = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      color: Colors.white,
      boxShadow: [
        CustomBoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: Offset(0.0, 0.0),
          blurRadius: 4.6,
          blurStyle: BlurStyle.normal,
        )
      ],
    );

    Widget _buildTotalWidget() {
      return Container(
        // height: 200,
        alignment: Alignment.center,
        decoration: boxDeco,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(3.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Total:",
                  style: styleTotal,
                ),
                SizedBox(
                  width: 50.0,
                ),
                Text("\$ " + myProvider.obtenerTotal.toStringAsFixed(2),
                    style: styleTotal)
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 125.0,
                  height: 40.0,
                  child: RaisedButton(
                    color: Colors.grey,
                    onPressed: () {
                      myProvider.limpiarCarrito();
                      // Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(
                      "Limpiar",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 125.0,
                  height: 40.0,
                  child: RaisedButton(
                    color: primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmarPed(),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(
                      "Confirmar",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: myProvider.obtenerListaCarrito.length == 0
            ? Container(
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                      "¡El carrito esta vacio!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18.0,
                      )),
                ),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: boxDeco,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(4.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: myProvider.obtenerListaCarrito.length,
                        itemBuilder: (BuildContext context, index) {
                          return CheckoutCard(index);
                          // Dismissible(
                          //   direction: DismissDirection.endToStart,
                          //   background: Container(
                          //     padding: EdgeInsets.all(20.0),
                          //     alignment: Alignment.centerRight,
                          //     child: Text("Eliminar", style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 16.0),),
                          //     color: Colors.red,
                          //   ),
                          //   key: Key(myProvider
                          //       .obtenerListaCarrito[index].descripcion),
                          //   onDismissed: (direction) {
                          //     if (direction == DismissDirection.endToStart) {
                          //       print("se elimino el index " + index.toString() + " y articulo Id  " + myProvider.obtenerListaCarrito[index].articuloId.toString() );
                          //       myProvider.removerItemCarrito = myProvider.obtenerListaCarrito[index];
                          //     }
                          //   },
                          //   child: CheckoutCard(index),
                          // );
                        },
                      ),
                    ),
                  ),
                  _buildTotalWidget(),
                ],
              ),
      ),
    );
  }
}
