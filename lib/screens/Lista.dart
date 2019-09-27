import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Producto.dart';
import '../providers/provider.dart';
import '../widgets/productCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Lista extends StatefulWidget {
  Lista({Key key}) : super(key: key);

  _Lista createState() => _Lista();
}

class _Lista extends State<Lista> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color secondary = Theme.of(context).primaryColorDark;
    var myProvider = Provider.of<MyProvider>(context);
    bool notNull(Object o) => o != null;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Widget _buildGrilla() {
      return Expanded(
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              if (myProvider.botonDisponible) {
                myProvider.botonDisponible = false;

                // myProvider.cancelarTimer();

                myProvider.modificarBoton(true);

                print("llego al final");

                myProvider.buscarArticulos(
                    clienteId: myProvider.cliente.clienteID == 0
                        ? ""
                        : myProvider.cliente.clienteID.toString(),
                    ancho: myProvider.ancho.codigo == 0
                        ? ""
                        : myProvider.ancho.codigo.toString(),
                    alto: myProvider.alto.codigo == 0
                        ? ""
                        : myProvider.alto.codigo.toString(),
                    tipo: "C",
                    descr: "",
                    marcaId: "",
                    rodado: myProvider.rodado.codigo == 0
                        ? ""
                        : myProvider.rodado.codigo.toString());
              }
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GridView.count(
                  crossAxisCount: 5,
                  childAspectRatio:  1.4,
                  controller: _controller,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(4.0),
                  children: myProvider.lista
                      .map((Producto item) {
                        if (myProvider.filtro == null ||
                            myProvider.filtro == "") {
                          return ProductCard(item: item);
                        } else if (item.descripcion
                            .toLowerCase()
                            .contains(myProvider.filtro.toLowerCase())) {
                          return ProductCard(item: item);
                        } else {
                          return null;
                        }
                      })
                      .where(notNull)
                      .toList(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                myProvider.isLoading
                    ? Container(
                        height: 50.0,
                        width: 50.0,
                        child: SpinKitFadingCircle(
                          color: secondary,
                          size: 50.0,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            myProvider.buscando
                ? Center(
                    child: Column(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 100.0,
                        child: SpinKitCircle(
                          color: secondary,
                          size: 70.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text("Buscando articulos...",
                          style:
                              TextStyle(color: secondary, fontFamily: 'Roboto'))
                    ],
                  ))
                : myProvider.lista.length == 0
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                (MediaQuery.of(context).size.height / 2) * 0.7),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "No se encontaron Articulos con los filtros seleccionados!!",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : _buildGrilla(),
          ],
        ),
      ),
    );
  }
}
