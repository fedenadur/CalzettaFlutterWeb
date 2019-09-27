import 'dart:convert';

import 'package:flutter/material.dart';

Producto productoFromJson(String str) {
  final jsonData = json.decode(str);
  return Producto.fromMap(jsonData);
}

String productoToJson(Producto data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Producto {
  final String descripcion;
  final dynamic imagen;
  final double itemprice;
  final double stockDisponible;
  final int articuloId;
  double cantidad;
  bool enCarrito;

  Producto(
      {this.descripcion,
      this.imagen,
      this.itemprice,
      this.stockDisponible,
      this.articuloId,
      this.cantidad,
      this.enCarrito});

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
      articuloId: json["ArticuloId"],
      cantidad: json["Cantidad"],
      descripcion: json["DescripAmplia"],
      imagen: json["Imagen"] == null
          ? null
          : Image.memory(base64.decode(json["Imagen"])).image,
      itemprice: json["Precio"] == null ? 0.0 : json["Precio"],
      stockDisponible: json["StockDisponible"]);

  Map<String, dynamic> toMap() => {
        "ArticuloId": articuloId,
        "Cantidad": cantidad,
        "DescripAmplia": descripcion,
        "Imagen": base64.encode(imagen),
        "PrecioConIVA": itemprice,
        "StockDisponible": stockDisponible
      };
}
