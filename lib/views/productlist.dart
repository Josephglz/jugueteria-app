import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jugueteria/models/Producto.dart';
import 'package:jugueteria/views/apartarview.dart';

List<DataProduct> productos = [];

class ProductoList extends StatefulWidget {
  ProductoList({Key? key}) : super(key: key);

  @override
  State<ProductoList> createState() => _ProductoListState();
}

class _ProductoListState extends State<ProductoList> {
  Future<List<Producto>> loadProductos() async {
    const str = 'assets/productos.json';
    final data = await DefaultAssetBundle.of(context).loadString(str);
    final jsonData = json.decode(data);
    return List<Producto>.from(jsonData.map((x) => Producto.fromJson(x)));
  }

  @override
  void initState() {
    productos.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController cantidad = TextEditingController();
    int qty = 0;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jugueteria García'),
        ),
        body: FutureBuilder<List<Producto>>(
          future: loadProductos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Cantidad'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              controller: cantidad,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.shopping_cart),
                                labelText: 'Cantidad',
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                color: Colors.green.shade300,
                                child: const Text(
                                  'Aceptar',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    qty = int.parse(cantidad.text);
                                    if (qty > 0) {
                                      productos.add(
                                        DataProduct(
                                          qty,
                                          snapshot.data![index],
                                        ),
                                      );
                                    }
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 10, bottom: 5),
                                child: Text(
                                  snapshot.data![index].nombre,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5, left: 10, bottom: 5),
                                child: Text(
                                  snapshot.data![index].codigo,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5, left: 10, bottom: 10),
                                child: Text(
                                  "\$" +
                                      snapshot.data![index].precio.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Image.network(
                                  snapshot.data![index].imagen,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: productos.isNotEmpty
            ? Container(
                height: 90,
                margin: const EdgeInsets.only(left: 32),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child: const Text('Continuar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApartarView(
                          productos: productos,
                        ),
                      ),
                    );
                  },
                ),
              )
            : null,
      ),
    );
  }
}
