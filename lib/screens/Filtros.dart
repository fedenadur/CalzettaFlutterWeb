import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/provider.dart';

class Filtros extends StatefulWidget {
  Filtros({Key key}) : super(key: key);

  _FiltrosState createState() => _FiltrosState();
}

class _FiltrosState extends State<Filtros> {
  final TextEditingController _searchQuery = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context);
    Color primary = Theme.of(context).primaryColor;
    Color secondary = Theme.of(context).primaryColorDark;
    var widthMax = MediaQuery.of(context).size.width;
    var anchoButton = widthMax * 0.6;
    var altoButton = MediaQuery.of(context).size.height * 0.06;
    var filtroTextStyle = TextStyle(color: secondary, fontSize: 16.0);

    _searchQuery.addListener((() {
      // myProvider.clienteDesc = _searchQuery.text;
      print(_searchQuery.text);

      myProvider.traerPosiblesClientes(_searchQuery.text);
    }));

    Widget _buildButtonAncho(String title) {
      return Container(
        width: anchoButton,
        height: altoButton,
        child: RaisedButton(
          child: Text(title, style: TextStyle(color: Colors.white)),
          color: primary,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35.0),
              borderSide: BorderSide(color: Colors.white)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("SELECCIONAR $title:"),
                content: Container(
                  height: 300.0,
                  width: 300.0,
                  child: ListView.builder(
                    itemCount: myProvider.listaAnchos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          FlatButton(
                            child: Text(myProvider.listaAnchos[index].descr,
                                style: TextStyle(fontSize: 18.0)),
                            onPressed: () {
                              myProvider.ancho = myProvider.listaAnchos[index];
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    Widget _buildButtonAlto(String title) {
      return Container(
        width: anchoButton,
        height: altoButton,
        child: RaisedButton(
          child: Text(title, style: TextStyle(color: Colors.white)),
          color: primary,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35.0),
              borderSide: BorderSide(color: Colors.white)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("SELECCIONAR $title:"),
                content: Container(
                  height: 300.0,
                  width: 300.0,
                  child: ListView.builder(
                    itemCount: myProvider.listaAltos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          FlatButton(
                            child: Text(myProvider.listaAltos[index].descr,
                                style: TextStyle(fontSize: 18.0)),
                            onPressed: () {
                              myProvider.alto = myProvider.listaAltos[index];
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    Widget _armarTextFormFieldCliente() {
      return Container(
        margin: EdgeInsets.all(5.0),
        width: widthMax,
        child: TextField(
          controller: _searchQuery,
          decoration: InputDecoration(
              labelText: 'Cliente Descripcion',
              filled: true,
              fillColor: Colors.white),
          keyboardType: TextInputType.text,
        ),
      );
    }

    Widget _buildButtonCliente(String title) {
      return Container(
        width: anchoButton,
        height: altoButton,
        child: RaisedButton(
          child: Text(title, style: TextStyle(color: Colors.white)),
          color: primary,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35.0),
              borderSide: BorderSide(color: Colors.white)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("SELECCIONAR $title:"),
                      content: Container(
                        height: MediaQuery.of(context).size.height * 1,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: myProvider.listaClientes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    title: Text(
                                        myProvider.listaClientes[index].nombre),
                                    onTap: () {
                                      myProvider.cliente =
                                          myProvider.listaClientes[index];
                                      Navigator.pop(context);
                                    });
                              },
                            ),
                          ),
                        ]),
                      ),
                    ));
          },
        ),
      );
    }

    Widget _buildButtonRodado(String title) {
      return Container(
        width: anchoButton,
        height: altoButton,
        child: RaisedButton(
          child: Text(title, style: TextStyle(color: Colors.white)),
          color: primary,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35.0),
              borderSide: BorderSide(color: Colors.white)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("SELECCIONAR $title:"),
                content: Container(
                  height: 300.0,
                  width: 300.0,
                  child: ListView.builder(
                    itemCount: myProvider.listaRodados.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          FlatButton(
                            child: Text(myProvider.listaRodados[index].descr,
                                style: TextStyle(fontSize: 18.0)),
                            onPressed: () {
                              myProvider.rodado =
                                  myProvider.listaRodados[index];
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondary,
          child: Icon(            
            Icons.done,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
            print("aplico los cambios y voy a buscar articulos");

            myProvider.buscando = true;

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
                    : myProvider.rodado.codigo.toString(),
                pag: 0);

            myProvider.limpiarCarrito();

            // myProvider.traerPosiblesClientes();

            myProvider.buscarDireccionEntregas(
                clienteId: myProvider.cliente.clienteID == 0
                    ? ""
                    : myProvider.cliente.clienteID.toString());

            myProvider.currentIndex = 0;

            Navigator.of(context).pop();
          },
        ),
        body:
            // GestureDetector(
            //   onTap: () {
            //     FocusScope.of(context).requestFocus(FocusNode());
            //   },
            //   child:
            Container(
              color: Colors.white,
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          // margin:EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          alignment: Alignment.center,
          child: Form(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  _armarTextFormFieldCliente(),
                  SizedBox(
                    height: 15.0,
                  ),
                  myProvider.totalClientes == 0
                      ? Container(
                          height: 20.0,
                        )
                      : Container(
                          height: 20.0,
                          child: Text(
                            "${myProvider.totalClientes} Registros",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  //   ],
                  // ),

                  SizedBox(
                    height: 15.0,
                  ),

                  _buildButtonCliente("CLIENTE"),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(myProvider.cliente.nombre, style: filtroTextStyle),
                  SizedBox(
                    height: 15.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildButtonAncho('ANCHO'),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(myProvider.ancho.descr, style: filtroTextStyle),
                      SizedBox(
                        height: 15.0,
                      ),
                      _buildButtonAlto('ALTO'),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(myProvider.alto.descr, style: filtroTextStyle),
                      SizedBox(
                        height: 15.0,
                      ),
                      _buildButtonRodado('RODADO'),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(myProvider.rodado.descr.toString(),
                          style: filtroTextStyle),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ),
        ),
      ),
    );
  }
}
