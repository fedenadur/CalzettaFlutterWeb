import 'dart:convert';

Alto altoFromJson(String str) {
  final jsonData = json.decode(str);
  return Alto.fromMap(jsonData);
}

String altoToJson(Alto data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Alto {
  final int codigo;
  final String descr;

  Alto({
    this.codigo,
    this.descr,
  });

  factory Alto.fromMap(Map<String, dynamic> json) => Alto(
        codigo: json["Codigo"],
        descr: json["Descr"],
      );

  Map<String, dynamic> toMap() => {
        "Codigo": codigo,
        "Descr": descr,
      };
}
