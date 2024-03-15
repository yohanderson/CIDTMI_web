import 'package:cidtmi/screens/mobile/shop/product_mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../bloc/cart_model.dart';
import '../../../bloc/dates_state_bloc.dart';
import '../cart_mobile.dart';


class StoreMobileView extends StatefulWidget {
  final void Function(int) goToIndex;
  const StoreMobileView({super.key, required this.goToIndex,});

  @override
  State<StoreMobileView> createState() => _StoreMobileViewState();
}

class _StoreMobileViewState extends State<StoreMobileView> {
  int? categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    categoriaSeleccionada = null;
  }

  bool menuCategoriesBool = false;

  final int _counterProduct = 1;


  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable:
        Provider.of<ConnectionDatesBlocs>(context).categories,
        builder: (context, value, child) {

          final categorias = value;

          Widget menuCategories() {
            return Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        categoriaSeleccionada = null;
                        menuCategoriesBool = false;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text('Todo'),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (final categoria in categorias)
                          if (categoria['id_padre'] == null)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  categoriaSeleccionada = categoria['id'];
                                  menuCategoriesBool = false;
                                });
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        categoria['nombre'],
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ]),
                ],
              ),
            );
          }

          if (value.isEmpty) {
            return const Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 10, bottom: 30, top: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (menuCategoriesBool == false) {
                                  menuCategoriesBool = true;
                                } else {
                                  menuCategoriesBool = false;
                                }
                              });
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Categorias',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50, left: 30),
                        child:
                        ValueListenableBuilder<List<Map<String, dynamic>>>(
                          valueListenable:
                          Provider.of<ConnectionDatesBlocs>(context)
                              .products,
                          builder: (context, value, child) {
                            final productos = value;
                            if (value.isEmpty) {
                              return const Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                  ),
                                  Center(
                                    child: Text(
                                      'No hay productos disponibles',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Wrap(
                                spacing: 25,
                                runSpacing: 25,
                                children: [
                                  for (final producto in productos) ...[
                                    if (categoriaSeleccionada == null ||
                                        producto['id_categoria'] ==
                                            categoriaSeleccionada)
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15)),
                                        height: 200,
                                        width: 150,
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductMobile(
                                                        producto: producto,
                                                        categoria: producto[
                                                        'id_categoria']
                                                            .toString(),
                                                        productos: productos,
                                                      )),
                                            );
                                            if (result != null) {
                                              widget.goToIndex(result);
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[400],
                                                      borderRadius:
                                                      const BorderRadius
                                                          .only(
                                                        topLeft:
                                                        Radius.circular(5),
                                                        topRight:
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 70,
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: Colors.black87,
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                        Radius.circular(5),
                                                        bottomRight:
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  /*Padding(
                                                padding: const EdgeInsets.only(top: 10 , left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 25,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                      ),
                                                      child: const Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text('4.5',
                                                          style: TextStyle(
                                                            color: Colors.white
                                                          ),),
                                                          Icon(Icons.star,
                                                            color: Colors.yellow,
                                                            size: 15,)
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(Icons.favorite_border,
                                                      color: Colors.black87
                                                      ,)
                                                  ],
                                                ),
                                              ),*/
                                                  const SizedBox(
                                                    height: 40,
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      height: 90,
                                                      width: 120,
                                                      child: Image.network(
                                                        producto[
                                                        'coloresconfotos']
                                                        [0]['fotos'][0],
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 10,
                                                            right: 40),
                                                        child: Text(
                                                          producto['nombre'],
                                                          style: const TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                          top: 5,
                                                        ),
                                                        child: Text(
                                                          NumberFormat.simpleCurrency(
                                                              locale:
                                                              'en-CLP',
                                                              decimalDigits:
                                                              0)
                                                              .format(producto[
                                                          'precio']),
                                                          style: const TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                right: 5,
                                                bottom: 55,
                                                child: InkWell(
                                                  onTap: () {
                                                    final cart =
                                                    Provider.of<CartModel>(
                                                        context,
                                                        listen: false);
                                                    final success =
                                                    cart.addProduct(
                                                        producto,
                                                        _counterProduct);
                                                    if (success) {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Producto agregado al carrito')),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Este producto ya está en el carrito')),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .shopping_cart_outlined,
                                                      color: Colors.black87,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
                Positioned(
                  top: 115,
                  left: 10,
                  child: menuCategoriesBool == true
                      ? Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 1.5,
                              offset: Offset(0.2, 0.2))
                        ],
                      ),
                      child: menuCategories())
                      : const SizedBox(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

