import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../bloc/auth/provider_auth.dart';
import '../../bloc/cart_model.dart';
import '../../bloc/dates_state_bloc.dart';


class CartDesktopView extends StatefulWidget {
  const CartDesktopView({
    super.key,
    required this.goToIndex, required this.logInSelect,
  });
  final void Function(int) goToIndex;
  final Function() logInSelect;

  @override
  State<CartDesktopView> createState() => _CartDesktopState();
}

class _CartDesktopState extends State<CartDesktopView> {
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
  }

  Widget _buildProductRow(Map<String, dynamic> product) {
    final cartModel = Provider.of<CartModel>(context);
    final price = product['promotion'] ?? product['price_unit'];
    final subtotal = price * product['quantity_cart'];
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
                          product['mdcp'][0]['colors'][0]['photos'][0]['url'],
                          height: 50,
                            width: 50,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product['name'],
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
                        .format(price),
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
                                      product['quantity_cart'].toString()),
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        cartModel.addProduct(
                                            product,
                                            product['quantity_cart'] + 1);
                                      },
                                      child: const Icon(
                                        Icons.expand_less,
                                        size: 15,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (product['quantity_cart'] > 1) {
                                          cartModel.addProduct(
                                              product,
                                              product['quantity_cart'] - 1);
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

  Widget _buildProduct(Map<String, dynamic> product) {
    final price = product['promotion'] ?? product['price_unit'];
    final subtotal = price * product['quantity_cart'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product['name'],
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
                  product['quantity_cart'].toString(),
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

  final ValueNotifier<String> selectedAuth = ValueNotifier('login');

  bool _isLoadingCart = false;

  @override
  Widget build(BuildContext context) {
    ConnectionDatesBlocs connectionDatesBlocs = Provider.of<
        ConnectionDatesBlocs>(context);
    final cartModel = Provider.of<CartModel>(context);
    return Consumer<CartModel>(
      builder: (context, cart, child) {

        void sumbitCite() async {


         if(_isLoadingCart == false) {

           setState(() {
            _isLoadingCart = true;
          });

           if(Provider.of<AuthTokenProvider>(context, listen: false).isAuthenticated == true) {
             if(connectionDatesBlocs.account.value[0]['verify_email'] == true) {
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
                     backgroundColor: Colors.red,
                     content: Text(
                         'Por favor rellena los campos obligatorios obligatorios',
                     ),
                   ),
                 );
                 return;
               }
               final products = cart.products.map((product) {
                 final price = product['promotion'] ?? product['price_unit'];
                 final subtotal = price * product['quantity_cart'];
                 return {
                   'product_id': product['product_id'],
                   'name': product['name'],
                   'quantity_cart': product['quantity_cart'],
                   'subtotal': subtotal,
                 };
               }).toList();

               final productJson = jsonEncode(products);

               final now = DateTime.now();
               final formattedNow =
                   '${DateFormat(
                   'yyyy-MM-dd HH:mm:ss').format(
                   now)}+00:00';

               const String connection = 'http:$ipPort';

               String route = '/create_Order';

               var url = Uri.parse('$connection$route');

               var headers = {'Content-Type': 'application/json; charset=UTF-8'};

               var body = jsonEncode({
                 'name': name,
                 'last_name': lastName,
                 'name_enterprise': nameEnterprise,
                 'country': country,
                 'region': region,
                 'address': address,
                 'address_two': addressTwo,
                 'population': population,
                 'postal_code': codePostal,
                 'phone_number': phoneNumber,
                 'notes': notes,
                 'created_at': formattedNow,
                 'products': productJson,
                 'total': cart.total,
                 'state': state,
                 'user_id': connectionDatesBlocs.account.value[0]['user_id'],
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

                 setState(() {
                   _isLoadingCart = false;
                 });

                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       title: const Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('Producto comprado con exito'),
                               Padding(
                                 padding: EdgeInsets.only(left: 5),
                                 child: Icon(Icons.verified, color: Colors.green,),
                               ),
                             ],
                           ),
                         ],
                       ),
                       actions: [
                         ElevatedButton(
                           style: TextButton.styleFrom(
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(15),
                             ),
                           ),
                           onPressed: () {
                             Navigator.of(context).pop();
                           },
                           child: Text('Cerrar',
                             style: TextStyle(
                                 color: Theme.of(context).textTheme.bodyLarge?.color
                             ),
                           ),
                         ),
                       ],
                     );
                   },
                 );

               }
               else if (response.statusCode == 500)
               {

                 setState(() {
                   _isLoadingCart = false;
                 });

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
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(15),
                             ),
                           ),
                           onPressed: () {
                             Navigator.of(context).pop();
                           },
                           child: Text('Cerrar',
                             style: TextStyle(
                                 color: Theme.of(context).textTheme.bodyLarge?.color
                             ),
                           ),
                         ),
                       ],
                     );
                   },
                 );
               }
             }
             else {

               setState(() {
                 _isLoadingCart = false;
               });

               showDialog(
                 context: context,
                 builder: (BuildContext context) {
                   return AlertDialog(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                     title: const Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Padding(
                           padding: EdgeInsets.symmetric(horizontal: 10),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('Debes de verificar tu correo para realizar compras'),
                               Padding(
                                 padding: EdgeInsets.only(left: 5),
                                 child: Icon(Icons.verified, color: Colors.green,),
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                     actions: [
                       ElevatedButton(
                         style: TextButton.styleFrom(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(15),
                           ),
                         ),
                         onPressed: () {
                           Navigator.of(context).pop();
                         },
                         child: Text('Cerrar',
                           style: TextStyle(
                               color: Theme.of(context).textTheme.bodyLarge?.color
                           ),
                         ),
                       ),
                     ],
                   );
                 },
               );
             }
           } else {

             setState(() {
               _isLoadingCart = false;
             });

             widget.logInSelect();
           }
         }
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              if (formOrder == false) ...[
                if (cartModel.products.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 300,
                            child: Text(
                              'Este carrito esta vacio',
                              style: TextStyle(fontSize: 25),
                            ),
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
                      child: Column(
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
                Row(
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
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color
                                      ),
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
                                      style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyMedium?.color
                                      ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
                                controller: numberPhoneController,
                                decoration: InputDecoration(
                                  labelText: 'Número de teléfono',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).textTheme.bodyMedium?.color
                                  ),
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
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                ),
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
                                child: ElevatedButton(onPressed:  _isLoadingCart
                                    ? null
                                    :  sumbitCite,
                                  child: _isLoadingCart
                                      ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 8),
                                    child: SizedBox(
                                        height: 23,
                                        width: 23,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        )),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                                    child: Text('Realizar pedido',
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color
                                    ),),
                                  ),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
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
