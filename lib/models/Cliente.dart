import 'dart:convert';

Cliente clienteFromJson(String str) {
  final jsonData = json.decode(str);
  return Cliente.fromMap(jsonData);
}

String clienteToJson(Cliente data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Cliente {
  final int clienteID;
  final String nombre;

  Cliente({
    this.clienteID,
    this.nombre, 
    });

factory Cliente.fromMap(Map<String, dynamic> json) => Cliente(
        clienteID: json["ClienteID"],
        nombre: json["Nombre"],
      );

  Map<String, dynamic> toMap() => {
        "ClienteID": clienteID,
        "Nombre": nombre,
      };
}