import 'dart:async';
import 'dart:convert';
import 'dart:core';

import '../models/DireccionEntregas.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/Producto.dart';
import '../models/Rodado.dart';
import '../models/Ancho.dart';
import '../models/Alto.dart';
import '../models/Cliente.dart';
import '../models/Pedido.dart';
import '../models/ComprobanteInfo.dart';
import '../models/CuentaCorrienteAgrupamiento.dart';
import 'package:intl/intl.dart';

import '../shared/global_configs.dart';

class MyProvider extends ChangeNotifier {
  String _usuario = "";
  String _pass = "";
  String token;
  bool _isLoading = false;
  bool _isLoadingCC = false;
  bool _recordarDatos = false;
  bool _estaLogeado = false;
  bool _buscando = false;
  List<Producto> lista = [];
  List<DireccionEntregas> dirEntregas = [];
  String _filtro;
  // List<int> _checkoutIds = [];
  double _subTotal = 0.00;
  double _total = 0.00;
  double _impuestosTotal = 0.00;
  Ancho _ancho = Ancho(codigo: 0, descr: "TODOS");
  Alto _alto = Alto(codigo: 0, descr: "TODOS");
  Rodado _rodado = Rodado(codigo: 0, descr: "TODOS");
  Cliente _cliente = Cliente(clienteID: 0, nombre: "TODOS");
  List<Rodado> listaRodados = [];
  List<Ancho> listaAnchos = [];
  List<Alto> listaAltos = [];
  List<Cliente> listaClientes = [];
  List<Producto> _listaCarrito = [];
  int _paginaGrilla = 0;
  bool _botonDisponible = true;
  Timer timer;
  int _currentIndex = 0;
  String clienteDesc = "";
  int totalClientes = 0;
  bool _endDraweando = false;

  double totalGlobal = 0.0;
  double totalCalzetta = 0.0;
  List<CuentaCorrienteAgrupamiento> listaCCG = [];
  List<CuentaCorrienteAgrupamiento> listaCCC = [];

  get buscando => _buscando;

  set buscando(bool valor) {
    _buscando = valor;
    notifyListeners();
  }

  get botonDisponible => _botonDisponible;

  set botonDisponible(bool valor) {
    _botonDisponible = valor;
    notifyListeners();
  }

  get estaLogeado => _estaLogeado;

  set estaLogeado(bool valor) {
    _estaLogeado = valor;
    notifyListeners();
  }

  get currentIndex => _currentIndex;

  set currentIndex(int valor) {
    _currentIndex = valor;
    notifyListeners();
  }

  get recordarDatos => _recordarDatos;

  set recordarDatos(bool valor) {
    _recordarDatos = valor;
    notifyListeners();
  }

  get cliente => _cliente;

  set cliente(Cliente cli) {
    _cliente = cli;
    notifyListeners();
  }

  set rodado(Rodado roda) {
    _rodado = roda;
    notifyListeners();
  }

  get rodado => _rodado;

  set alto(Alto al) {
    _alto = al;
    notifyListeners();
  }

  get alto => _alto;

  set ancho(Ancho anc) {
    _ancho = anc;
    notifyListeners();
  }

  get ancho => _ancho;

  List<Producto> get obtenerListaCarrito => _listaCarrito;

  set agregarItemACarrito(Producto prod) {
    //reseteo la cantidad

    prod.cantidad = 1;

    _listaCarrito.add(prod);
    notifyListeners();
  }

  // List<int> get checkoutIds => _checkoutIds;

  set removerItemCarrito(Producto prodsel) {
    _listaCarrito.removeWhere((i) => i.articuloId == prodsel.articuloId);
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  bool get isLoadingCC => _isLoadingCC;

  bool get endDraweando => _endDraweando;

  set endDraweando(bool valor)
  {
    _endDraweando = valor;
    notifyListeners();
  }

  String get filtro => _filtro;

  set filtro(String newFiltro) {
    _filtro = newFiltro;
    notifyListeners();
  }

  String get usuario => _usuario;

  set usuario(String usu) {
    _usuario = usu;
    notifyListeners();
  }

  String get password => _pass;

  set password(String pass) {
    _pass = pass;
    notifyListeners();
  }

  set aumentarCantidad(int articuloId) {
    Producto selectedP =
        _listaCarrito.firstWhere((i) => i.articuloId == articuloId);
    if (selectedP.cantidad < selectedP.stockDisponible) selectedP.cantidad += 1;

    notifyListeners();
  }

  void limpiarCarrito() {
    _listaCarrito.clear();
    notifyListeners();
  }

  void cancelarTimer() {
    print("cancelo el timer");

    timer.cancel();
    notifyListeners();
  }

  void modificarBoton(bool hacer) {
    print("arranco el timer");

    timer = Timer(const Duration(seconds: 3), () {
      botonDisponible = hacer;
      print("botonDisponible ahora es true");
    });

    if (botonDisponible) {
      timer.cancel();
      print("cancele el timer");
    }

    notifyListeners();
  }

  set bajarCantidad(int articuloId) {
    Producto selectedP = lista.firstWhere((i) => i.articuloId == articuloId);
    if (selectedP.cantidad > 1) {
      selectedP.cantidad -= 1;
    }
    notifyListeners();
  }

  set quitarCheckout(Producto prodASacar) {
    _listaCarrito.removeWhere((i) => i.articuloId == prodASacar.articuloId);
    notifyListeners();
  }

  double get obtenerTotal => _total;

  set calcularTotal(bool hacer) {
    // _total = _subTotal + (_subTotal * 0.21);
    _total = _subTotal;
    notifyListeners();
  }

  double get obtnerSubtotal => _subTotal;

  double get obtenerImpuestos => _impuestosTotal;

  set calcularSubtotal(List<Producto> articulos) {
    double subT = 0;
    double impuestos = 0;

    for (int a = 0; a < articulos.length; a++) {
      var multiimp = (articulos[a].cantidad * articulos[a].itemprice) * 0.21;
      impuestos += multiimp;

      var multi = articulos[a].cantidad * articulos[a].itemprice;
      subT += multi;
    }

    _subTotal = subT;
    _impuestosTotal = impuestos;
    notifyListeners();
  }

  Future<Null> verificarEstaLogeado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hayToken = prefs.getString('token');
    print(hayToken != "" ? "hay token " : "no hay token");
    _estaLogeado = hayToken == "" ? false : true;
  }

  Future<Null> obtenerDatosLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _usuario = prefs.getString("usuario");
    _pass = prefs.getString("password");

    notifyListeners();
  }

  void limpiarDatos() {
    lista = [];
    dirEntregas = [];
    limpiarCarrito();

    _ancho = Ancho(codigo: 0, descr: "TODOS");
    _alto = Alto(codigo: 0, descr: "TODOS");
    _rodado = Rodado(codigo: 0, descr: "TODOS");
    _cliente = Cliente(clienteID: 0, nombre: "TODOS");

    print("Datos limpiados");
  }

  Future<bool> logear(_usu, _pass) => _logear(_usu, _pass);

  Future<bool> _logear(String usu, String pass) async {
    limpiarDatos();
    print("HOLA");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    print("CHAU");
    Map<String, dynamic> responseData;
    _isLoading = true;
    notifyListeners();

    final formBody = "grant_type=password&username=$usu&password=$pass";

    print(formBody);

    final http.Response response = await http.post(apiUrl + 'token',
        body: formBody,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});

    if (response.statusCode == 200 || response.statusCode == 201) {
      responseData = json.decode(response.body);

      int inpiresIn = responseData['expires_in'];
      DateTime date = DateTime.fromMillisecondsSinceEpoch(inpiresIn * 1000);
      print(date.hour.toString() + date.minute.toString());

      token = responseData['access_token'];
      // prefs.setString('token', responseData['access_token']);

      // if (_recordarDatos) {
      //   prefs.setString('usuario', usu);
      //   prefs.setString('password', pass);
      // }

      _isLoading = false;
      notifyListeners();

      return true;
      // } else if (response.statusCode == 400) {
      //   responseData = json.decode(response.body);
      //   var err = responseData['error_description'];
      //   print(err);
      //   _isLoading = false;
      //   notifyListeners();

      //   return err;
    } else {
      responseData = json.decode(response.body);
      print(responseData);
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future traerPosiblesClientes(String cliDes) async {
    bool buscar = cliDes != clienteDesc ? true : false;
    totalClientes = 0;

    if (buscar) {
      clienteDesc = cliDes;
      listaClientes = [];

      final http.Response response = await http.post(
          apiUrl + 'api/PedidosApi/BuscarClientes',
          body: "ClienteID=&RazonSocial_CUIT=$clienteDesc",
          headers: {
            'Authorization': 'bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> rd = json.decode(response.body);
        totalClientes = rd.length;

        listaClientes.add(Cliente(clienteID: 0, nombre: "TODOS"));

        for (int i = 0; i < rd.length; i++) {
          Cliente item = Cliente.fromMap(rd[i]);
          listaClientes.add(item);
        }
      }
    } else {}

    notifyListeners();
  }

  Future traerDatosIniciales() async {
    final http.Response response = await http.post(
        apiUrl + 'api/PedidosApi/TraerDatosIniciales',
        body: "",
        headers: {
          'Authorization': 'bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> rd = json.decode(response.body);

      listaAnchos.add(Ancho(codigo: 0, descr: "TODOS"));
      listaAltos.add(Alto(codigo: 0, descr: "TODOS"));
      listaRodados.add(Rodado(codigo: 0, descr: "TODOS"));

      for (int i = 0; i < rd['Anchos'].length; i++) {
        Ancho item = Ancho.fromMap(rd['Anchos'][i]);
        listaAnchos.add(item);
      }

      for (int i = 0; i < rd['Altos'].length; i++) {
        Alto item = Alto.fromMap(rd['Altos'][i]);
        listaAltos.add(item);
      }

      for (int i = 0; i < rd['Rodados'].length; i++) {
        Rodado item = Rodado.fromMap(rd['Rodados'][i]);
        listaRodados.add(item);
      }

      notifyListeners();
    }
  }

  Future buscarArticulosTest() async {
    _isLoading = true;
    notifyListeners();
    
    String fb = "Alto=&Ancho=&ClienteId=5258&Descripcion=&MarcaId=&Pagina=0&Rodado=&TipoArticulo=C&UsuarioId=0";
    final http.Response response1 = await http
        .post(apiUrl + 'api/ArticulosApi/BuscarArticulos', body: fb, headers: {
      'Authorization': 'bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    if (response1.statusCode == 200 || response1.statusCode == 201) {
      final Map<String, dynamic> rd = json.decode(response1.body);

      for (int i = 0; i < rd['Articulos'].length; i++) {
        Producto item = Producto.fromMap(rd['Articulos'][i]);
        lista.add(item);
      }

      _isLoading = false;
      _buscando = false;
      _paginaGrilla += 1;
      notifyListeners();
    }

  }

    

  Future buscarArticulos(
      {String clienteId,
      String marcaId,
      String alto,
      String ancho,
      String rodado,
      String descr,
      String tipo,
      int pag}) async {
    _isLoading = true;
    notifyListeners();

    print(_paginaGrilla);

    if (pag != null) {
      _paginaGrilla = pag;
      lista = [];
    }

    String fb =
        "Alto=$alto&Ancho=$ancho&ClienteId=$clienteId&Descripcion=$descr&MarcaId=$marcaId&Pagina=$_paginaGrilla&Rodado=$rodado&TipoArticulo=$tipo&UsuarioId=0";

        print(fb);

    final http.Response response1 = await http
        .post(apiUrl + 'api/ArticulosApi/BuscarArticulos', body: fb, headers: {
      'Authorization': 'bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    if (response1.statusCode == 200 || response1.statusCode == 201) {
      final Map<String, dynamic> rd = json.decode(response1.body);

      for (int i = 0; i < rd['Articulos'].length; i++) {
        Producto item = Producto.fromMap(rd['Articulos'][i]);
        lista.add(item);
      }

      _isLoading = false;
      _buscando = false;
      _paginaGrilla += 1;
      notifyListeners();
    }
  }

  Future buscarInfoCuentaCorriente() async {
    String body =
        "ClienteId=475&FechaDesde=01/01/1980&FechaHasta=08/30/2019&EstadoId=1&EmpresaID=0";

    _isLoadingCC = true;
    notifyListeners();

    final http.Response response1 = await http.post(
        apiUrl + 'api/CuentaCorrienteApi/BuscarInfoCuentaCorriente',
        body: body,
        headers: {
          'Authorization': 'bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        });

    if (response1.statusCode == 200 || response1.statusCode == 201) {
      final Map<String, dynamic> rd = json.decode(response1.body);

      totalGlobal = rd['TotalGlobal'];
      totalCalzetta = rd['TotalCalzetta'];

      //Mapeo la cuenta corriente global
      for (int i = 0; i < rd['CuentaCorrienteGlobal'].length; i++) {
        var compInfo =
            rd['CuentaCorrienteGlobal'][i]['ComprobantesRelacionados'];

        ComprobanteInfo comInfo = ComprobanteInfo(
            codCli: compInfo[0]['CodCli'],
            comprobante: compInfo[0]['Comprobante'],
            comprobanteID: compInfo[0]['ComprobantesID'],
            tipoComprob: compInfo[0]['TipoComprob'],
            fechaemi: DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(compInfo[0]['Fechaemi'].substring(6, 19)))),
            fechaVen: DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(compInfo[0]['FechaVen'].substring(6, 19)))),
            fechaRel: DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(compInfo[0]['FechaRel'].substring(6, 19)))),
            lImporte: compInfo[0]['LImporte'],
            comprobRel: compInfo[0]['ComprobRel'],
            codAsocID: compInfo[0]['CodAsocID'],
            sucAsoc: compInfo[0]['SucAsoc'],
            nroAsoc: compInfo[0]['NroAsoc'],
            pendiente: compInfo[0]['Pendiente']);

        List<ComprobanteInfo> listaComps = [];
        listaComps.add(comInfo);

        CuentaCorrienteAgrupamiento cuentacorrienteAgrupamiento =
            CuentaCorrienteAgrupamiento(
                comprobantesRelacionados: listaComps,
                saldoPendiente: rd['CuentaCorrienteGlobal'][i]
                    ['SaldoPendiente'],
                codComprob: rd['CuentaCorrienteGlobal'][i]['CodComprob']);

        listaCCG.add(cuentacorrienteAgrupamiento);
      }

      //Mapeo cuenta corriente calzetta
      for (int i = 0; i < rd['CuentaCorrienteCalzetta'].length; i++) {
        var compInfo =
            rd['CuentaCorrienteCalzetta'][i]['ComprobantesRelacionados'];

        ComprobanteInfo comInfo = ComprobanteInfo(
            codCli: compInfo[0]['CodCli'],
            comprobante: compInfo[0]['Comprobante'],
            comprobanteID: compInfo[0]['ComprobantesID'],
            tipoComprob: compInfo[0]['TipoComprob'],
            fechaemi: DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(compInfo[0]['Fechaemi'].substring(6, 19)))),
            fechaVen: DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(compInfo[0]['FechaVen'].substring(6, 19)))),
            fechaRel: DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(compInfo[0]['FechaRel'].substring(6, 19)))),
            lImporte: compInfo[0]['LImporte'],
            comprobRel: compInfo[0]['ComprobRel'],
            codAsocID: compInfo[0]['CodAsocID'],
            sucAsoc: compInfo[0]['SucAsoc'],
            nroAsoc: compInfo[0]['NroAsoc'],
            pendiente: compInfo[0]['Pendiente']);

        List<ComprobanteInfo> listaComps = [];
        listaComps.add(comInfo);

        CuentaCorrienteAgrupamiento cuentacorrienteAgrupamiento =
            CuentaCorrienteAgrupamiento(
                comprobantesRelacionados: listaComps,
                saldoPendiente: rd['CuentaCorrienteCalzetta'][i]
                    ['SaldoPendiente'],
                codComprob: rd['CuentaCorrienteCalzetta'][i]['CodComprob']);

        listaCCC.add(cuentacorrienteAgrupamiento);
      }
    }

    _isLoadingCC = false;
    notifyListeners();
  }

  Future buscarDireccionEntregas({
    String clienteId,
    // String razonsocial
  }) async {
    dirEntregas = [];

    String fb = "ClienteId=$clienteId";

    final http.Response response1 = await http.post(
        apiUrl + 'api/PedidosApi/TraerDireccionesEntrega',
        body: fb,
        headers: {
          'Authorization': 'bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        });

    if (response1.statusCode == 200 || response1.statusCode == 201) {
      final List<dynamic> rd = json.decode(response1.body);

      for (int i = 0; i < rd.length; i++) {
        DireccionEntregas item = DireccionEntregas(
          direccionID: rd[i]["DireccionID"],
          descripcion: rd[i]['Descripcion'],
        );

        dirEntregas.add(item);
      }
    }

    notifyListeners();
  }

  Future grabarPedido({Pedido pedidoNuevo}) async {
    Map<String, dynamic> responseData;
    var listaArticulos = [];

    for (int i = 0; i < pedidoNuevo.articulos.length; i++) {
      var resBody = {};
      resBody["ArticuloId"] = pedidoNuevo.articulos[i].articuloId;
      resBody["PrecioConIVA"] = pedidoNuevo.articulos[i].itemprice;
      resBody["Cantidad"] = pedidoNuevo.articulos[i].cantidad;

      listaArticulos.add(resBody);
    }

    var ped = {};
    ped["ClienteId"] = pedidoNuevo.clienteId;
    ped["DireccionEntregaId"] = pedidoNuevo.direccionEntregaId;
    ped["ListaID"] = 0;
    ped["Observaciones"] = pedidoNuevo.observaciones;
    ped["Impuestos"] = pedidoNuevo.impuestos;
    ped["SubTotal"] = pedidoNuevo.subtotal;
    ped["Total"] = pedidoNuevo.total;
    ped["Articulos"] = listaArticulos;
    String str = json.encode(ped);

    print(str);

    final http.Response response = await http
        .post(apiUrl + 'api/PedidosApi/GrabarPedido', body: str, headers: {
      'Authorization': 'bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      responseData = json.decode(response.body);
      print(responseData);
    } else {
      responseData = json.decode(response.body);
      print(responseData);
    }

    notifyListeners();
  }
}
