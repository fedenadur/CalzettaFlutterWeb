import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Producto.dart';
import '../models/Pedido.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();  
    String path = join(documentsDirectory.path, "TestDB_v2.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // await db.execute("CREATE TABLE Producto (articuloId INTEGER PRIMARY KEY, cantidad DOUBLE, descripcion TEXT)");
      // await db.execute("DROP TABLE Pedido");
      await db.execute("CREATE TABLE Pedido (pedidoId INTEGER PRIMARY KEY, clienteId INTEGER, direccionEntregaId INTEGER, observaciones TEXT, subtotal DOUBLE, impuestos DOUBLE, total DOUBLE)");
    });
  }

  // final int clienteId;
  // final int direccionEntregaId;
  // final String observaciones;
  // final double subtotal;
  // final double impuestos;
  // final double total;
  // final List<Producto> articulos;

  newPedido(Pedido newPedido) async {
    final db = await database;

    var table = await db.rawQuery("SELECT MAX(pedidoId)+1 as pedidoId FROM Pedido");
    int id = table.first["pedidoId"];

    var raw = await db.rawInsert("INSERT INTO Pedido (pedidoId, clienteId, direccionEntregaId, observaciones, subtotal, impuestos, total) values (?,?,?,?,?,?,?)",
    [id, newPedido.clienteId, newPedido.direccionEntregaId, newPedido.observaciones, newPedido.subtotal, newPedido.impuestos, newPedido.total]);    

    return raw;
  }

  getPedido(int id) async {
    final db = await database;

    var res = await db.query("Pedido", where: "pedidoId = ?", whereArgs: [id]);

    return res.isNotEmpty ? Pedido.fromMap(res.first) : null;
  }

  getAllPedidos() async {
    final db = await database;

    var res = await db.query("Pedido");

    List<Pedido> list = res.isNotEmpty ? res.map((c) => Pedido.fromMap(c)).toList() : [];

    return list;
  }

  deleteAllPedidos() async {
    final db = await database;
    db.rawDelete("Delete  from  Pedido");
  }


  newProducto(Producto newProducto) async {
    final db = await database;

    var table = await db
        .rawQuery("SELECT MAX(articuloId)+1 as articuloId FROM Producto");
    int id = table.first["articuloId"];

    var raw = await db.rawInsert(
        "INSERT INTO Producto (articuloId, cantidad, descripcion)"
        " VALUES (?,?,?)",
        [id, newProducto.cantidad, newProducto.descripcion]);

    return raw;
  }

  updateProducto(Producto newProd) async {
    final db = await database;
    var res = await db.update("Producto", newProd.toMap(),
        where: "articuloId = ?", whereArgs: [newProd.articuloId]);
    return res;
  }

  getProducto(int id) async {
    final db = await database;
    var res =
        await db.query("Producto", where: "articuloId = ?", whereArgs: [id]);

    return res.isNotEmpty ? Producto.fromMap(res.first) : null;
  }

  Future<List<Producto>> getAllProductos() async {
    final db = await database;
    var res = await db.query("Producto");
    List<Producto> list =
        res.isNotEmpty ? res.map((c) => Producto.fromMap(c)).toList() : [];

    return list;
  }

  deleteProducto(int id) async {
    final db = await database;

    return db.delete("Producto", where: "id = ?", whereArgs: [id]);
  }

  deleteAllProductos() async {
    final db = await database;
    db.rawDelete("Delete  from  Producto");
  }
}
