import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/CuentaCorrienteAgrupamiento.dart';

class CuentaCorriente extends StatefulWidget {
  CuentaCorriente();

  @override
  State<StatefulWidget> createState() {
    return _CuentaCorriente();
  }
}

class _CuentaCorriente extends State<CuentaCorriente> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _CuentaCorriente();

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context);
    final ThemeData theme = Theme.of(context);
    final double espacioRow = 4.0;
    TextStyle txBold = TextStyle(fontWeight: FontWeight.bold);

    TextStyle txTotal =
        TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0);

    Widget _buildGrillaLista(
        List<CuentaCorrienteAgrupamiento> lista, String titulo) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              titulo,
              // "CUENTA CORRIENTE DE CALZETTA",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5.0,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "Comprobante",
                              style: txBold,
                            ),
                            Text(lista.elementAt(index).codComprob),
                            SizedBox(
                              height: espacioRow,
                            ),
                            lista
                                        .elementAt(index)
                                        .comprobantesRelacionados
                                        .length >
                                    1
                                ? Text("")
                                : Container(),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Fecha",
                              style: txBold,
                            ),
                            Text(lista
                                .elementAt(index)
                                .comprobantesRelacionados[0]
                                .fechaemi),
                            SizedBox(
                              height: espacioRow,
                            ),
                            lista
                                        .elementAt(index)
                                        .comprobantesRelacionados
                                        .length >
                                    1
                                ? Text("")
                                : Container(),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Fecha Vto",
                              style: txBold,
                            ),
                            Text(lista
                                .elementAt(index)
                                .comprobantesRelacionados[0]
                                .fechaVen),
                            SizedBox(
                              height: espacioRow,
                            ),
                            lista
                                        .elementAt(index)
                                        .comprobantesRelacionados
                                        .length >
                                    1
                                ? Text(
                                    "Pendiente",
                                    style: txBold,
                                  )
                                : Container(),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Importe",
                              style: txBold,
                            ),
                            Text(lista
                                .elementAt(index)
                                .comprobantesRelacionados[0]
                                .lImporte
                                .toString()),
                            SizedBox(
                              height: espacioRow,
                            ),
                            lista
                                        .elementAt(index)
                                        .comprobantesRelacionados
                                        .length >
                                    1
                                ? Text(
                                    lista
                                        .elementAt(index)
                                        .saldoPendiente
                                        .toString(),
                                    style: txBold,
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      );
    }

    Widget _buildGrillaListaCCG() {
      return
          //  myProvider.isLoadingCC
          //     ? Container(
          //         height: 50.0,
          //         width: 50.0,
          //         child: SpinKitFadingCircle(
          //           color: Colors.blue,
          //           size: 50.0,
          //         ),
          //       )
          //     : myProvider.listaCCG.length == 0
          //         ? Container()
          //         :
          SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              "CUENTA CORRIENTE DE GLOBAL",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5.0,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: myProvider.listaCCG.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "Comprobante",
                              style: txBold,
                            ),
                            Text(myProvider.listaCCG
                                .elementAt(index)
                                .codComprob),
                            SizedBox(
                              height: espacioRow,
                            ),
                            Text(""),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Fecha",
                              style: txBold,
                            ),
                            Text(myProvider.listaCCG
                                .elementAt(index)
                                .comprobantesRelacionados[0]
                                .fechaemi),
                            SizedBox(
                              height: espacioRow,
                            ),
                            Text(""),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Fecha Vto",
                              style: txBold,
                            ),
                            Text(myProvider.listaCCG
                                .elementAt(index)
                                .comprobantesRelacionados[0]
                                .fechaVen),
                            SizedBox(
                              height: espacioRow,
                            ),
                            Text(
                              "Pendiente",
                              style: txBold,
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Importe",
                              style: txBold,
                            ),
                            Text(myProvider.listaCCG
                                .elementAt(index)
                                .comprobantesRelacionados[0]
                                .lImporte
                                .toString()),
                            SizedBox(
                              height: espacioRow,
                            ),
                            Text(
                              myProvider.listaCCG
                                  .elementAt(index)
                                  .saldoPendiente
                                  .toString(),
                              style: txBold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      );
    }

    Widget _buildTotalesCC() {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Calzetta:",
              style: txTotal,
            ),
            Text(
              "\$ ${myProvider.totalCalzetta}",
              style: txTotal,
            ),
            Text(
              "Global:",
              style: txTotal,
            ),
            Text(
              "\$ ${myProvider.totalGlobal}",
              style: txTotal,
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: myProvider.isLoadingCC
            ? Center(
                child: Container(
                  height: 80.0,
                  width: 80.0,
                  child: SpinKitRipple(
                    color: Theme.of(context).primaryColor,
                    size: 80.0,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    _buildGrillaLista(
                        myProvider.listaCCC, "CUENTA CORRIENTE DE CALZETTA"),
                    _buildGrillaLista(
                        myProvider.listaCCG, "CUENTA CORRIENTE DE GLOBAL"),
                    // _buildGrillaListaCCG(),

                    _buildTotalesCC(),
                    // SizedBox(
                    //   height: 5.0,
                    // )
                  ],
                ),
              ),
      ),
    );
  }
}
