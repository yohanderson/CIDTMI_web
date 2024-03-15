import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../bloc/cart_model.dart';
import '../../bloc/dates_state_bloc.dart';


class CartTabletView extends StatefulWidget {
  const CartTabletView({
    super.key,
    required this.goToIndex,
  });
  final void Function(int) goToIndex;

  @override
  State<CartTabletView> createState() => _CartTabletViewState();
}

class _CartTabletViewState extends State<CartTabletView> {
  bool formOrder = false;
  bool _isChecked = false;



  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nameEnterpriseController = TextEditingController();
  final countryController = TextEditingController();
  final addressOneController = TextEditingController();
  final addressTwoController = TextEditingController();
  final populationController = TextEditingController();
  final regionController = TextEditingController();
  final postalCodeController = TextEditingController();
  final numberPhoneController = TextEditingController();
  final correoController = TextEditingController();
  final notesController = TextEditingController(text: '');
  String countryCode = 'CL';
  String completePhoneNumber = '';

  @override
  void initState() {
    super.initState();
  }

  Widget _buildHeaderRow() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: const Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 25, bottom: 25),
            child: Row(
              children: [
                SizedBox(width: 50),
                SizedBox(
                    width: 400,
                    child: Text(
                      'Producto',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Text(
                      'Precio',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Text(
                      'Cantidad',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Text(
                      'Subtotal',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: const Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 25, bottom: 25),
            child: Row(
              children: [
                SizedBox(width: 50),
                SizedBox(
                    width: 270,
                    child: Text(
                      'Producto',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Text(
                      'Precio',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Text(
                      'Cantidad',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Text(
                      'Subtotal',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        );
      }
    }
    );
  }

  Widget _buildProductRow(Map<String, dynamic> product) {
    final cartModel = Provider.of<CartModel>(context);
    final precio = product['promocion'] ?? product['precio'];
    final subtotal = precio * product['quantity'];
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        return Row(
          children: [
            SizedBox(
              width: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: InkWell(
                  onTap: () {
                    cartModel.removeProduct(product);
                  },
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: const Icon(Icons.close, size: 13, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 400,
                        child: Row(
                          children: [
                            Image.network(
                              product['coloresconfotos'][0]['fotos'][0],
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product['nombre'],
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        NumberFormat.simpleCurrency(
                            locale: 'en-CLP', decimalDigits: 0)
                            .format(precio),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                          product['quantity'].toString()),
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            cartModel.addProduct(
                                                product,
                                                product['quantity'] + 1);
                                          },
                                          child: const Icon(
                                            Icons.expand_less,
                                            size: 15,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (product['quantity'] > 1) {
                                              cartModel.addProduct(
                                                  product,
                                                  product['quantity'] - 1);
                                            }
                                          },
                                          child: const Icon(
                                            Icons.expand_more,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        )),
                    Expanded(
                      child: Text(
                        NumberFormat.simpleCurrency(
                            locale: 'en-CLP', decimalDigits: 0)
                            .format(subtotal),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
      else {
        return Row(
          children: [
            SizedBox(
              width: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: InkWell(
                  onTap: () {
                    cartModel.removeProduct(product);
                  },
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: const Icon(Icons.close, size: 13, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 270,
                        child: Row(
                          children: [
                            Image.network(
                              product['coloresConFotos'][0]['fotos'][0],
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product['nombre'],
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        NumberFormat.simpleCurrency(
                            locale: 'en-CLP', decimalDigits: 0)
                            .format(precio),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                          product['quantity'].toString()),
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            cartModel.addProduct(
                                                product,
                                                product['quantity'] + 1);
                                          },
                                          child: const Icon(
                                            Icons.expand_less,
                                            size: 15,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (product['quantity'] > 1) {
                                              cartModel.addProduct(
                                                  product,
                                                  product['quantity'] - 1);
                                            }
                                          },
                                          child: const Icon(
                                            Icons.expand_more,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        )),
                    Expanded(
                      child: Text(
                        NumberFormat.simpleCurrency(
                            locale: 'en-CLP', decimalDigits: 0)
                            .format(subtotal),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }
    );
  }

  Widget _buildProductColumn (Map<String, dynamic> product) {
    final cartModel = Provider.of<CartModel>(context);
    final precio = product['promocion'] ?? product['precio'];
    final subtotal = precio * product['quantity'];
    return Column(
      children: [
        Container(
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top:10, bottom: 10),
                child: SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: InkWell(
                      onTap: () {
                        cartModel.removeProduct(product);
                      },
                      child: Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black87, width: 1)),
                        child: const Icon(Icons.close, size: 13, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            height: 150,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Producto:',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(
                          product['coloresConFotos'][0]['fotos'][0],
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['nombre'],
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Precio:',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  NumberFormat.simpleCurrency(
                      locale: 'en-CLP', decimalDigits: 0)
                      .format(precio),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cantidad:',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      width: 50,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                  product['quantity'].toString()),
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    cartModel.addProduct(
                                        product,
                                        product['quantity'] + 1);
                                  },
                                  child: const Icon(
                                    Icons.expand_less,
                                    size: 15,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (product['quantity'] > 1) {
                                      cartModel.addProduct(
                                          product,
                                          product['quantity'] - 1);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.expand_more,
                                    size: 15,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal:',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  NumberFormat.simpleCurrency(
                      locale: 'en-CLP', decimalDigits: 0)
                      .format(subtotal),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProduct(Map<String, dynamic> product) {
    final precio = product['promocion'] ?? product['precio'];
    final subtotal = precio * product['quantity'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product['nombre'],
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 7, bottom: 5, left: 7, right: 7),
                child: Text(
                  product['quantity'].toString(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: 60,
                child: Text(
                  NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                      .format(subtotal),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Éxito!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
              SizedBox(height: 16),
              Text('Tu pedido se realizo de manera exitosa.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    return Consumer<CartModel>(
      builder: (context, cart, child) {

        void sumbitCite() async {
          final name = nameController.text;
          final lastName = lastNameController.text;
          final nameEnterprise = nameEnterpriseController.text;
          final country = countryController.text;
          final region = regionController.text;
          final address = addressOneController.text;
          final addressTwo = addressTwoController.text;
          final population = populationController.text;
          final codePostal = postalCodeController.text;
          final phoneNumber = completePhoneNumber;
          final notes = notesController.text;
          const state = 'Cita agendada';
          if (name.isEmpty ||
              lastName.isEmpty ||
              phoneNumber.isEmpty ||
              country.isEmpty ||
              region.isEmpty ||
              address.isEmpty ||
              population.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Por favor rellena los campos obligatorios obligatorios'),
              ),
            );
            return;
          }
          final products = cart.products.map((product) {
            final precio = product['promocion'] ?? product['precio'];
            final subtotal = precio * product['quantity'];
            return {
              'id': product['id'],
              'nombre': product['nombre'],
              'quantity': product['quantity'],
              'subtotal': subtotal,
            };
          }).toList();

          final productJson = jsonEncode(products);

          final now = DateTime.now();
          final timestamp =
              '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';

          const String connection = 'http:$ipPort';

          String route = '/create_Order';

          var url = Uri.parse('$connection$route');

          var headers = {'Content-Type': 'application/json; charset=UTF-8'};

          var body = jsonEncode({
            'name': name,
            'lastName': lastName,
            'nameEnterprise': nameEnterprise,
            'country': country,
            'region': region,
            'address': address,
            'addressTwo': addressTwo,
            'population': population,
            'postalCode': codePostal,
            'phoneNumber': phoneNumber,
            'notes': notes,
            'timestamp': timestamp,
            'products': productJson,
            'total': cart.total,
            'state': state,
          });

          var response = await http.post(url, headers: headers, body: body);

          if (response.statusCode == 200) {
            nameController.clear();
            lastNameController.clear();
            nameEnterpriseController.clear();
            countryController.clear();
            regionController.clear();
            addressOneController.clear();
            addressTwoController.clear();
            populationController.clear();
            postalCodeController.clear();
            numberPhoneController.clear();
            notesController.clear();

            setState(() {
              _isChecked = false;
            });
          }
          else if (response.statusCode == 500)
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Center(child: Column(
                    children: [
                      Text(response.body),
                    ],
                  )),
                  actions: [
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.blue[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }

        return Column(
          children: [
            if (formOrder == false) ...[
              if (cartModel.products.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Este carrito esta vacio',
                          style: TextStyle(fontSize: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.goToIndex(3);
                            },
                            child: Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(
                                child: Text(
                                  'Visitar tienda',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 50),
                  child: Row(
                    children: [
                      Text(
                        'Carrito',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 35,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 50, right: 50, bottom: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Column(
                          children: [
                            _buildHeaderRow(),
                            ...cart.products.map((product) {
                              return Column(
                                children: [
                                  _buildProductRow(product),
                                ],
                              );
                            }).toList(),
                          ],
                        );
                      } else{
                        return  Column(
                            children: [
                              ...cart.products.map((product) {
                                return Container(
                                  child: _buildProductColumn(product),
                                );
                              }).toList(),
                            ],
                          );
                      }
                      }
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(2)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Total de la compra',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Total: \$${cart.total}',
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    formOrder = true;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  width: 160,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.blue),
                                  child: const Center(
                                      child: Text(
                                    'finalizar compra',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ],
            if (formOrder == true) ...[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            formOrder = false;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 25,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Finalizar Compra',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
                  LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 500)
        {
          return  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Detalles de la Facturacion',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  CapitalizeFirstLetterTextNames()
                                ],
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  hintText: 'Nombre',
                                  suffixIcon: Container(
                                    alignment: Alignment.topRight,
                                    width: 20,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8),
                                      child: RichText(
                                        text: const TextSpan(
                                          text: '*',
                                          style:
                                          TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  CapitalizeFirstLetterTextNames()
                                ],
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Apellido',
                                  hintText: 'Apellido',
                                  suffixIcon: Container(
                                    alignment: Alignment.topRight,
                                    width: 20,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8),
                                      child: RichText(
                                        text: const TextSpan(
                                          text: '*',
                                          style:
                                          TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: [
                            CapitalizeFirstLetterTextNames()
                          ],
                          controller: nameEnterpriseController,
                          decoration: InputDecoration(
                            labelText: 'Nombre de la Empresa',
                            hintText: 'Nombre de la Empresa (opcional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue, // Color del borde
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: [
                            CapitalizeFirstLetterTextNames()
                          ],
                          controller: countryController,
                          decoration: InputDecoration(
                            labelText: 'Pais',
                            hintText: 'Pais',
                            suffixIcon: Container(
                              alignment: Alignment.topRight,
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: RichText(
                                  text: const TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: [
                            CapitalizeFirstLetterTextNames()
                          ],
                          controller: regionController,
                          decoration: InputDecoration(
                            labelText: 'Region/Provincia',
                            hintText: 'Region/Provincia',
                            suffixIcon: Container(
                              alignment: Alignment.topRight,
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: RichText(
                                  text: const TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Direccion de la Calle',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          controller: addressOneController,
                          decoration: InputDecoration(
                            hintText:
                            'Numero de la casa y nombre de la calle',
                            suffixIcon: Container(
                              alignment: Alignment.topRight,
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: RichText(
                                  text: const TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue, // Color del borde
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          controller: addressTwoController,
                          decoration: InputDecoration(
                            hintText:
                            'Apartamento, habitacion, etc. (opcional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          controller: populationController,
                          decoration: InputDecoration(
                            labelText: 'Poblacion',
                            hintText: 'Poblacion',
                            suffixIcon: Container(
                              alignment: Alignment.topRight,
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: RichText(
                                  text: const TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: postalCodeController,
                          decoration: InputDecoration(
                            labelText: 'Codigo Postal',
                            hintText: 'Codigo Postal (opcional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: IntlPhoneField(
                          controller: numberPhoneController,
                          decoration: InputDecoration(
                            labelText: 'Número de teléfono',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                          initialCountryCode: 'CL',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (phone) {
                            setState(() {
                              countryCode = phone.countryCode;
                              completePhoneNumber = phone.completeNumber;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Informacion Adicional',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          controller: notesController,
                          decoration: InputDecoration(
                            labelText: 'Notas',
                            hintText: 'Notas',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue, // Color del borde
                              ),
                            ),
                          ),
                          minLines: 5,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tu Pedido',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding:
                        EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5),                                  child: Text(
                              'Producto',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25),
                              child: Text(
                                'Subtotal',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 250,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...cart.products.map((product) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        _buildProduct(product),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                NumberFormat.simpleCurrency(
                                    locale: 'en-CLP',
                                    decimalDigits: 0)
                                    .format(cart.total),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Text('Transferencia bancaria directa',
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: SizedBox(
                          width: 28,
                          height: 20,
                          child: CustomPaint(
                            painter: TrianglePainter(),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Realiza tu pago directamente en nuestra cuenta bancaria. Por favor, usa el número del pedido como referencia de pago. Tu pedido no se procesará hasta que se haya recibido el importe en nuestra cuenta.',
                            textAlign: TextAlign.justify,
                            style: (
                                TextStyle(
                                  color: Colors.grey[850],
                                  height: 1.5,
                                )
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Checkbox(
                                value: _isChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isChecked = newValue ?? false;
                                  });
                                },
                              ),
                            ),
                            const Flexible(
                              child: Text(
                                'Me gustaría recibir correos electrónicos exclusivos con descuentos e información de productos',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    height: 1.5,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                'Tus datos personales se utilizarán para procesar tu pedido, mejorar tu experiencia en esta web y otros propósitos descritos en nuestra ',
                                style: TextStyle(
                                    color: Colors.grey[850],
                                    height: 1.5
                                ),
                              ),
                              TextSpan(
                                text: 'política de privacidad',
                                style: const TextStyle(
                                    height: 1.5,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              TextSpan(text: '.',
                                style: TextStyle(
                                    color: Colors.grey[850]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(onPressed: sumbitCite,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                              child: Text('Realizar pedido'),
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Detalles de la Facturacion',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                CapitalizeFirstLetterTextNames()
                              ],
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                hintText: 'Nombre',
                                suffixIcon: Container(
                                  alignment: Alignment.topRight,
                                  width: 20,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(right: 8),
                                    child: RichText(
                                      text: const TextSpan(
                                        text: '*',
                                        style:
                                        TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                CapitalizeFirstLetterTextNames()
                              ],
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Apellido',
                                hintText: 'Apellido',
                                suffixIcon: Container(
                                  alignment: Alignment.topRight,
                                  width: 20,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(right: 8),
                                    child: RichText(
                                      text: const TextSpan(
                                        text: '*',
                                        style:
                                        TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: const BorderSide(
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalizeFirstLetterTextNames()
                        ],
                        controller: nameEnterpriseController,
                        decoration: InputDecoration(
                          labelText: 'Nombre de la Empresa',
                          hintText: 'Nombre de la Empresa (opcional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue, // Color del borde
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalizeFirstLetterTextNames()
                        ],
                        controller: countryController,
                        decoration: InputDecoration(
                          labelText: 'Pais',
                          hintText: 'Pais',
                          suffixIcon: Container(
                            alignment: Alignment.topRight,
                            width: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: RichText(
                                text: const TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalizeFirstLetterTextNames()
                        ],
                        controller: regionController,
                        decoration: InputDecoration(
                          labelText: 'Region/Provincia',
                          hintText: 'Region/Provincia',
                          suffixIcon: Container(
                            alignment: Alignment.topRight,
                            width: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: RichText(
                                text: const TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Direccion de la Calle',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalizeFirstLetterTextFormatter()
                        ],
                        controller: addressOneController,
                        decoration: InputDecoration(
                          hintText:
                          'Numero de la casa y nombre de la calle',
                          suffixIcon: Container(
                            alignment: Alignment.topRight,
                            width: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: RichText(
                                text: const TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue, // Color del borde
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalizeFirstLetterTextFormatter()
                        ],
                        controller: addressTwoController,
                        decoration: InputDecoration(
                          hintText:
                          'Apartamento, habitacion, etc. (opcional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalizeFirstLetterTextFormatter()
                        ],
                        controller: populationController,
                        decoration: InputDecoration(
                          labelText: 'Poblacion',
                          hintText: 'Poblacion',
                          suffixIcon: Container(
                            alignment: Alignment.topRight,
                            width: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: RichText(
                                text: const TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: postalCodeController,
                        decoration: InputDecoration(
                          labelText: 'Codigo Postal',
                          hintText: 'Codigo Postal (opcional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: IntlPhoneField(
                        controller: numberPhoneController,
                        decoration: InputDecoration(
                          labelText: 'Número de teléfono',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                        initialCountryCode: 'CL',
                        keyboardType: TextInputType.number,
                        onChanged: (phone) {
                          setState(() {
                            countryCode = phone.countryCode;
                            completePhoneNumber = phone.completeNumber;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Informacion Adicional',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          CapitalizeFirstLetterTextFormatter()
                        ],
                        controller: notesController,
                        decoration: InputDecoration(
                          labelText: 'Notas',
                          hintText: 'Notas',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.lightBlue, // Color del borde
                            ),
                          ),
                        ),
                        minLines: 5,
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu Pedido',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding:
                      EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                            'Producto',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 25),
                            child: Text(
                              'Subtotal',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 250,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...cart.products.map((product) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      _buildProduct(product),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: Colors.grey[300],
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                NumberFormat.simpleCurrency(
                                    locale: 'en-CLP',
                                    decimalDigits: 0)
                                    .format(cart.total),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text('Transferencia bancaria directa',
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: SizedBox(
                        width: 28,
                        height: 20,
                        child: CustomPaint(
                          painter: TrianglePainter(),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Realiza tu pago directamente en nuestra cuenta bancaria. Por favor, usa el número del pedido como referencia de pago. Tu pedido no se procesará hasta que se haya recibido el importe en nuestra cuenta.',
                          textAlign: TextAlign.justify,
                          style: (
                              TextStyle(
                                color: Colors.grey[850],
                                height: 1.5,
                              )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isChecked = newValue ?? false;
                                });
                              },
                            ),
                          ),
                          const Flexible(
                            child: Text(
                              'Me gustaría recibir correos electrónicos exclusivos con descuentos e información de productos',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  height: 1.5,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                              'Tus datos personales se utilizarán para procesar tu pedido, mejorar tu experiencia en esta web y otros propósitos descritos en nuestra ',
                              style: TextStyle(
                                  color: Colors.grey[850],
                                  height: 1.5
                              ),
                            ),
                            TextSpan(
                              text: 'política de privacidad',
                              style: const TextStyle(
                                  height: 1.5,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {},
                            ),
                            TextSpan(text: '.',
                              style: TextStyle(
                                  color: Colors.grey[850]
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: sumbitCite,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                            child: Text('Realizar pedido'),
                          ),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        },
                  ),
            ],
          ],
        );
      },
    );
  }
}

class CapitalizeFirstLetterTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    return TextEditingValue(
      text: newValue.text[0].toUpperCase() + newValue.text.substring(1),
      selection: newValue.selection,
    );
  }
}

class CapitalizeFirstLetterTextNames extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final words = newValue.text.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    });
    final capitalizedText = capitalizedWords.join(' ');
    return TextEditingValue(
      text: capitalizedText,
      selection: newValue.selection,
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
