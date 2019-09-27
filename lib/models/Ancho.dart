import 'dart:convert';

Ancho anchoFromJson(String str) {
  final jsonData = json.decode(str);
  return Ancho.fromMap(jsonData);
}

String anchoToJson(Ancho data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Ancho {
  final int codigo;
  final String descr;

  Ancho({
    this.codigo,
    this.descr, 
    });

factory Ancho.fromMap(Map<String, dynamic> json) => Ancho(
        codigo: json["Codigo"],
        descr: json["Descr"],
      );

  Map<String, dynamic> toMap() => {
        "Codigo": codigo,
        "Descr": descr,
      };
}