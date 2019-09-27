import 'dart:convert';
import '../models/Producto.dart';

Pedido productoFromJson(String str) {
  final jsonData = json.decode(str);
  return Pedido.fromMap(jsonData);
}

String productoToJson(Pedido data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Pedido {
  final int clienteId;
  final int direccionEntregaId;
  final String observaciones;
  final double subtotal;
  final double impuestos;
  final double total;
  final List<Producto> articulos;
  // final String articulos;

  Pedido(
      {this.clienteId,
      this.direccionEntregaId,
      this.observaciones,
      this.subtotal,
      this.impuestos,
      this.total,
      this.articulos});

  factory Pedido.fromMap(Map<String, dynamic> json) => Pedido(
        clienteId: json["clienteId"],
        direccionEntregaId: json["direccionEntregaId"],
        observaciones: json["observaciones"],
        subtotal: json["subtotal"],
        impuestos: json["impuestos"],
        total: json["total"],
        articulos: json["articulos"],
      );

  obtenerMapArticulos(List<Producto> arts) {
    List<Map<String, dynamic>> lista = new List<Map<String, dynamic>>();
    
    lista = arts.map((elements) => elements.toMap());

    print(lista);
    // return lista;
  }

  Map<String, dynamic> toMap() => {
        "ClienteId": clienteId,
        "DireccionEntregaId": direccionEntregaId,
        "Observaciones": observaciones,
        "SubTotal": subtotal,
        "Impuestos": impuestos,
        "Total": total,
        "Articulos": obtenerMapArticulos(articulos),
        "ListaID": 0
      };
}
