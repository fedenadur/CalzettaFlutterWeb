import '../models/DireccionEntregas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:calzetta_mobile/database/Database.dart';
import '../providers/provider.dart';
// import 'dart:math' as math;
import '../models/Pedido.dart';
import '../screens/PaginaCards.dart';

import '../widgets/CustomBoxShadow.dart';

class ConfirmarPed extends StatefulWidget {
  ConfirmarPed();

  @override
  State<StatefulWidget> createState() {
    return _ConfirmarPed();
  }
}

class _ConfirmarPed extends State<ConfirmarPed>
    with SingleTickerProviderStateMixin {
  String toolbarname = 'Confirmar Pedido';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _observaController;
  DireccionEntregas _currentDir;
  Choice _selectedChoice = choices[0];

  // AnimationController animationController;
  // Animation animation;
  // int currentState = 0;

  @override
  void initState() {
    _observaController = TextEditingController();

    // animationController =
    //     AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    // animation = Tween(begin: 0, end: 60).animate(animationController)
    //   ..addListener(() {});

    // animationController.forward();

    super.initState();
  }

  _ConfirmarPed();

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _heigth = MediaQuery.of(context).size.height;
    Color primary = Theme.of(context).primaryColor;
    Color secondary = Theme.of(context).primaryColorDark;

    void _select(Choice choice) {
      setState(() {
        _selectedChoice = choice;
        if (choice.title == "Limpiar") {
          myProvider.limpiarCarrito();
          myProvider.currentIndex = 0;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PaginaCards()));
        }
      });
    }

    Widget _buildSwitchAcceptTerms() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SwitchListTile(
          activeTrackColor: Theme.of(context).accentColor,
          inactiveThumbColor: Theme.of(context).primaryColor,
          title: Text(
            'Retirar en Depósito?',
            style: TextStyle(fontSize: 20.0, fontFamily: 'Roboto'),
          ),
          value: myProvider.recordarDatos, //cambiar el value
          onChanged: (bool value) {
            myProvider.recordarDatos = value; //cambiar el value
          },
          activeColor: Theme.of(context).primaryColor,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: true,
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
          title: Text(toolbarname),
          backgroundColor: primary,
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            )
          ]),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          alignment: Alignment.topCenter,
          // height: height,
          decoration: BoxDecoration(
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
          ),
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(15.0),
          child: Column(children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Text(
              "CONFIRMACION DEL PEDIDO",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  fontSize: 24.0),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              "El Total de su Pedido es:",
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "\$ " + myProvider.obtenerTotal.toStringAsFixed(2),
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5.0,
            ),
            _buildSwitchAcceptTerms(),
            SizedBox(
              height: 15.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              color: Colors.white,
              child: Center(
                child: DropdownButton<DireccionEntregas>(
                  value: myProvider.recordarDatos
                      ? null
                      : _currentDir, //cambiar el recordarDatos
                  onChanged: (DireccionEntregas newValue) {
                    setState(() {
                      _currentDir = newValue;
                    });
                  },
                  items: myProvider.dirEntregas.map((DireccionEntregas dirs) {
                    return DropdownMenuItem<DireccionEntregas>(
                        value: dirs,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              dirs.descripcion,
                              style: TextStyle(fontSize: 13.5),
                            )));
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: _observaController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Observaciones...',
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 40.0,
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.indigo,
                      size: 30.0,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              // title: Text("Title"),
                              contentPadding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              children: <Widget>[
                                Text(
                                  "En caso de corresponder por su condición fiscal, se sumarán percepciones que se calcularán al momento de la emisión de la factura de acuerdo a las tasas impositivas vigentes",
                                  //  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    // fontSize: 15.0,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                FlatButton(
                                  // child: Text("Entiendo"),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.lightBlue,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                  ),
                ),
                ButtonTheme(
                  minWidth: _width * 0.6,
                  height: 40.0,
                  child: RaisedButton(
                    color: primary,
                    onPressed: () {
                      Pedido ped = new Pedido(
                          clienteId: myProvider.cliente.clienteID == 0
                              ? 0
                              : myProvider.cliente.clienteID,
                          direccionEntregaId: _currentDir == null
                              ? null
                              : _currentDir.direccionID,
                          observaciones: _observaController.text,
                          impuestos: myProvider.obtenerImpuestos,
                          subtotal: myProvider.obtnerSubtotal,
                          total: myProvider.obtenerTotal,
                          articulos: myProvider.obtenerListaCarrito);

                      myProvider.grabarPedido(pedidoNuevo: ped);

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Grabo con exito"),
                              content: Text(
                                  "El pedido ingresado se grabo con exito"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Cerrar"),
                                  onPressed: () {
                                    myProvider.limpiarCarrito();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaginaCards()));
                                  },
                                )
                              ],
                            );
                          });
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
            ),
          ]),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Limpiar', icon: Icons.delete_outline),
];
