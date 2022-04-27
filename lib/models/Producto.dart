import 'dart:convert';

List<Producto> productoFromJson(String str) => List<Producto>.from(json.decode(str).map((x) => Producto.fromJson(x)));

String productoToJson(List<Producto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Producto {
    int id;
    String nombre;
    double precio;
    String codigo;
    String imagen;
    int cantidad;

    Producto({
      required this.id,
      required this.nombre,
      required this.precio,
      required this.codigo,
      required this.imagen,
      required this.cantidad,
    });

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"].toInt(),
        nombre: json["nombre"],
        precio: json["precio"].toDouble(),
        codigo: json["codigo"],
        imagen: json["imagen"],
        cantidad: json["cantidad"].toInt(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "codigo": codigo,
        "imagen": imagen,
        "cantidad": cantidad,
    };
}

class DataProduct
{
  int qty;
  Producto producto;

  DataProduct(
    this.qty,
    this.producto
  );

  
    Map<String, dynamic> toJson() => {
        "id": producto.id,
        "cantidad": qty,
    };
}