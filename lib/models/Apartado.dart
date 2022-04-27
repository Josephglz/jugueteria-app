
import 'dart:convert';

import 'package:jugueteria/models/Producto.dart';

List<Apartado> apartadoFromJson(String str) => List<Apartado>.from(json.decode(str).map((x) => Apartado.fromJson(x)));

String apartadoToJson(List<Apartado> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Apartado {
    List<DataProduct> juguetes;
    double pagoInicial;
    String fechaApartado;
    String fechaVencimiento;
    int estado;
    String entrega;
    String cliente;
    double montoTotal;

    Apartado({
      required this.juguetes,
      required this.pagoInicial,
      required this.fechaApartado,
      required this.fechaVencimiento,
      required this.estado,
      required this.entrega,
      required this.cliente,
      required this.montoTotal,
    });

    factory Apartado.fromJson(Map<String, dynamic> json) => Apartado(
        juguetes: List<DataProduct>.from(json["juguetes"].map((x) => Producto.fromJson(x))),
        pagoInicial: json["pagoInicial"].toDouble(),
        fechaApartado: json["fechaApartado"],
        fechaVencimiento: json["fechaVencimiento"],
        estado: json["estado"].toInt(),
        entrega: json["entrega"],
        cliente: json["cliente"],
        montoTotal: json["montoTotal"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "juguetes": List<dynamic>.from(juguetes.map((x) => x.toJson())),
        "pagoInicial": pagoInicial,
        "fechaApartado": fechaApartado,
        "fechaVencimiento": fechaVencimiento,
        "estado": estado,
        "entrega": entrega,
        "cliente": cliente,
        "montoTotal": montoTotal,
    };
}
