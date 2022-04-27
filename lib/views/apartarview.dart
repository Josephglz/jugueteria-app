import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jugueteria/models/Apartado.dart';
import 'package:jugueteria/models/Producto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jugueteria/views/inicioview.dart';
import 'package:path_provider/path_provider.dart';

class ApartarView extends StatefulWidget {
  List<DataProduct> productos;
  ApartarView({
    Key? key,
    required this.productos,
  }) : super(key: key);

  @override
  State<ApartarView> createState() => _ApartarViewState();
}

class _ApartarViewState extends State<ApartarView> {
  final TextEditingController _pagoInicial = TextEditingController();
  final TextEditingController _entrega = TextEditingController();
  final TextEditingController _aparta = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jugueteria García',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jugueteria García'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container( //Lista productos
                margin: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.grey.shade50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.productos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.25,
                      color: Colors.blue[300],
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              widget.productos.elementAt(index).producto.nombre,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              'Cant: ' +
                                  widget.productos
                                      .elementAt(index)
                                      .qty
                                      .toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              '#' +
                                  widget.productos
                                      .elementAt(index)
                                      .producto
                                      .codigo,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Subtotal:\n \$' +
                                  (widget.productos
                                              .elementAt(index)
                                              .producto
                                              .precio *
                                          widget.productos.elementAt(index).qty)
                                      .toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container( //Total a pagar
                margin: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Total: \$' + _getTotal().toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding( //Pago inicial
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  controller: _pagoInicial,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Pago Inicial',
                    prefixIcon: const Icon(
                      Icons.attach_money_outlined,
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    labelText: 'Pago Inicial',
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Container( //Fecha vencimiento
                margin: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Column(
                  children: [
                    const Text(
                      'Fecha de vencimiento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedDate.day.toString() +
                              '/' +
                              selectedDate.month.toString() +
                              '/' +
                              selectedDate.year.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container( //Entrega
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: Padding(
                  //Entrega
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: TextField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    ),
                    autofocus: false,
                    controller: _entrega,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Entrega',
                      prefixIcon: const Icon(
                        Icons.delivery_dining,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                      labelText: 'Entrega',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container( //Aparta
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: Padding(
                  //Aparta
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: TextField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    ),
                    autofocus: false,
                    controller: _aparta,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Aparta',
                      prefixIcon: const Icon(
                        Icons.person_add,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                      labelText: 'Aparta',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container( //Botón
                width: MediaQuery.of(context).size.width,
                height: 90,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: ElevatedButton(
                  child: const Text(
                    'Apartar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  onPressed: () {
                    try
                    {
                      _guardarApartado();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InicioView(),
                        ),
                      );
                    }
                    catch(e)
                    {
                      print(e.toString());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _guardarApartado() async {
    String fecha = selectedDate.day.toString() +
        '/' +
        selectedDate.month.toString() +
        '/' +
        selectedDate.year.toString();
    Apartado apartado =  Apartado(
      juguetes: widget.productos,
      pagoInicial: double.parse(_pagoInicial.text),
      fechaApartado: fecha,
      fechaVencimiento: fecha,
      estado: 1,
      entrega: _entrega.text,
      cliente: _aparta.text,
      montoTotal: _getTotal(),
    );
    
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/apartados.json');
    await file.writeAsString(json.encode(apartado.toJson()));
  }

  double _getTotal() {
    double total = 0.0;

    for (int i = 0; i < widget.productos.length; i++) {
      total += widget.productos[i].producto.precio * widget.productos[i].qty;
    }

    return total;
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }
}
