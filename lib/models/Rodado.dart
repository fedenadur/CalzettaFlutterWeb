import 'dart:convert';

Rodado rodadoFromJson(String str) {
  final jsonData = json.decode(str);
  return Rodado.fromMap(jsonData);
}

String rodadoToJson(Rodado data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Rodado {
  final int codigo;
  final String descr;

  Rodado({
    this.codigo,
    this.descr, 
    });

    factory Rodado.fromMap(Map<String, dynamic> json) => Rodado(
        codigo: json["Codigo"],
        descr: json["Descr"],
      );

  Map<String, dynamic> toMap() => {
        "Codigo": codigo,
        "Descr": descr,
      };
}