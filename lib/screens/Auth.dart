import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Auth extends StatefulWidget {
  Auth({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'usuario': null, 'pass': null};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color secondary = Theme.of(context).primaryColorDark;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth =
        deviceWidth * 0.8 > 530.0 ? 500.0 : deviceWidth * 0.95;

    var myProvider = Provider.of<MyProvider>(context);

    myProvider.obtenerDatosLogin();

    DecorationImage _buildBackgroundImage() {
      return DecorationImage(
        fit: BoxFit.fill,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.dstATop),
        image: AssetImage('assets/bkg-common-02.jpg'),
      );
    }

    Widget _armarTextFormFieldContrasena() {
      return TextFormField(
          initialValue: myProvider.password,
          // initialValue: passwordInit == null ? "" : passwordInit,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              labelText: 'Contraseña',
              filled: true,
              fillColor: Colors.white),
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Campo CONTRASEÑA no puede estar vacio';
            }
          },
          onSaved: (String value) {
            _formData['pass'] = value;
          });
    }

    Widget _buildSwitchAcceptTerms() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SwitchListTile(
          activeTrackColor: Theme.of(context).accentColor,
          inactiveThumbColor: Theme.of(context).primaryColor,
          title: Text(
            'Recordar usuario?',
          ),
          value: myProvider.recordarDatos,
          onChanged: (bool value) {
            myProvider.recordarDatos = value;
          },
          activeColor: Theme.of(context).primaryColor,
        ),
      );
    }

    Widget _armarBotonLogin() {
      return RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        textColor: Colors.white,
        color: secondary,
        child: Text('Acceder'),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());

          if (!_formKey.currentState.validate()) {
            return;
          }

          _formKey.currentState.save();

          Future<bool> isLogeado =
              myProvider.logear(_formData['usuario'], _formData['pass']);
          isLogeado.then((value) {
            print(value);
            if (value) {
              myProvider.traerDatosIniciales();

              myProvider.buscarInfoCuentaCorriente();

              _formKey.currentState.reset();

              myProvider.buscarArticulosTest();

              Navigator.pushNamed(context, '/PaginaCards');
            } else {
              throw Exception(
                  "Se produjo un error, por favor reintente nuevamente");
            }
          }).catchError((value) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(value.toString()),
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
          });
        },
      );
    }

    Widget _armarTextFormFieldUsuario() {
      return TextFormField(
        decoration: InputDecoration(
            labelText: 'Usuario', filled: true, fillColor: Colors.white),
        initialValue: myProvider.usuario,
        // initialValue: usuarioInit == null ? "" : usuarioInit,
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Campo USUARIO no puede estar vacio';
          }
        },
        onSaved: (String value) {
          _formData['usuario'] = value;
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: new Image.asset('assets/calzetta_logo_white.png',
              fit: BoxFit.scaleDown)),
      body: ModalProgressHUD(
        inAsyncCall: myProvider.isLoading,
        progressIndicator: SpinKitFadingCircle(
          color: secondary,
          size: 70.0,
        ),
        opacity: 0.6,
        color: primary,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              image: _buildBackgroundImage(),
            ),
            padding: EdgeInsets.all(35.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: targetWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _armarTextFormFieldUsuario(),
                        SizedBox(
                          height: 10.0,
                        ),
                        _armarTextFormFieldContrasena(),
                        SizedBox(
                          height: 10.0,
                        ),
                        _buildSwitchAcceptTerms(),
                        SizedBox(
                          height: 10.0,
                        ),
                        _armarBotonLogin(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
