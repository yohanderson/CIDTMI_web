import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../bloc/cart_model.dart';
import '../cart_mobile.dart';

class ProductMobile extends StatefulWidget {
  final Map<String, dynamic> producto;
  final String categoria;
  final List<Map<String, dynamic>> productos;
  const ProductMobile({
    Key? key,
    required this.producto,
    required this.categoria,
    required this.productos,
  }) : super(key: key);

  @override
  State<ProductMobile> createState() => _ProductMobileState();
}

class _ProductMobileState extends State<ProductMobile> {
  int _selectedColorIndex = 0;
  int _selectedImageIndex = 0;
  int _counterProduct = 1;
  List<Map<String, dynamic>> _productosAleatorios = [];
  late final Map<String, dynamic> product;
  final maxItems = 3;


  @override
  void initState() {
    super.initState();
    _productosAleatorios = _obtenerProductosAleatorios(widget.productos);
  }

  List<Map<String, dynamic>> _obtenerProductosAleatorios(
      List<Map<String, dynamic>> productos) {
    final productosFiltrados = productos
        .where((producto) => producto['id_categoria'] == widget.categoria)
        .toList();
    productosFiltrados.shuffle();
    return productosFiltrados.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sreenheight = MediaQuery.of(context).size.height;
    final producto = widget.producto;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return SizedBox(
            height: sreenheight,
            child: Row(
              children: [
                SizedBox(
                  width: 500,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 20,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                              size: 35,
                            )),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 130,
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              height: 300,
                              child: Image.network(
                                producto['coloresconfotos'][_selectedColorIndex]['fotos'][_selectedImageIndex],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < producto['coloresconfotos'][_selectedColorIndex]['fotos'].length; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedImageIndex = i;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                            i == _selectedImageIndex ? Colors.white : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 15, right: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                producto['descripcion'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          if (producto['promocion'] == null) ...[
                            // Muestra solo el precio normal
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                      .format(producto['precio']),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]
                          else ...[

                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                      .format(producto['precio']),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 25,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Text(NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits:
                                0).format(producto['promocion']),
                                  style:
                                  const TextStyle(color: Colors.white, fontSize: 50, fontWeight:
                                  FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 25),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Elegir color',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 150,
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: producto['coloresconfotos']?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedColorIndex = index;
                                            _selectedImageIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Color(producto['coloresconfotos'][index]['color']),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 50, right: 40),
                            child: SizedBox(
                              height: 200,
                              child: Image.asset('assets/img/dashback.png'),
                            ),
                          ),
                        ),
                        Text(
                          producto['nombre'],
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (_counterProduct > 1) {
                                      setState(() {
                                        _counterProduct--;
                                      });
                                    }
                                    final cart = Provider.of<CartModel>(context, listen: false);
                                    cart.addProduct(producto, _counterProduct);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1, color: Colors.black)),
                                  child: Center(
                                    child: Text('$_counterProduct'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _counterProduct++;
                                    });
                                    final cart = Provider.of<CartModel>(context, listen: false);
                                    cart.addProduct(producto, _counterProduct);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )

                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                                    ),
                                    onPressed: () {
                                      final cart = Provider.of<CartModel>(context, listen: false);
                                      final wasAdded = cart.addProduct(producto, _counterProduct);
                                      if (!wasAdded) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text('producto agregado')),
                                        );
                                      }
                                    },
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 3),
                                              child: Text(
                                                'Agregar al carrito',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context, 2);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 7, bottom: 7),
                                      child: Icon(Icons.shopping_cart),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10),
                          child: SizedBox(
                            height: 150,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                            for (final producto in _productosAleatorios.take(maxItems))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: InkWell(
                                      onTap: () async {
                                      },
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                  producto['coloresconfotos'][0]['fotos'][0],
                                                ),
                                              ),
                                              Text(
                                                producto['nombre'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                              size: 35,
                            )),
                      ),
                      Text(producto['nombre'],
                        style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 50,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 130,
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              height: 200,
                              child: Image.network(
                                producto['coloresconfotos'][_selectedColorIndex]['fotos'][_selectedImageIndex],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < producto['coloresconfotos'][_selectedColorIndex]['fotos'].length; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedImageIndex = i;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                            i == _selectedImageIndex ? Colors.white : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 15),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(producto['descripcion'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (producto['promocion'] == null) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                      .format(producto['precio']),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]
                          else ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                      .format(producto['precio']),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 20,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Text(NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits:
                                0).format(producto['promocion']),
                                  style:
                                  const TextStyle(color: Colors.white, fontSize: 30, fontWeight:
                                  FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Elegir color',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 30,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: producto['coloresconfotos']?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedColorIndex = index;
                                              _selectedImageIndex = 0;
                                            });
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Color(producto['coloresconfotos'][index]['color']),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                ),
                                SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (_counterProduct > 1) {
                                              setState(() {
                                                _counterProduct--;
                                              });
                                            }
                                            final cart = Provider.of<CartModel>(context, listen: false);
                                            cart.addProduct(producto, _counterProduct);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(width: 1, color: Colors.black)),
                                          child: Center(
                                            child: Text('$_counterProduct'),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _counterProduct++;
                                            });
                                            final cart = Provider.of<CartModel>(context, listen: false);
                                            cart.addProduct(producto, _counterProduct);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )

                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 10),
                            child: SizedBox(
                              width: 240,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                                    ),
                                    onPressed: () {
                                      final cart = Provider.of<CartModel>(context, listen: false);
                                      final wasAdded = cart.addProduct(producto, _counterProduct);
                                      if (!wasAdded) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text('producto agregado')),
                                        );
                                      }
                                    },
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                'Agregar al carrito',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: Colors.blue),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context, 2);
                                        },
                                        icon: const Icon(Icons.shopping_cart, color: Colors.white,),
                                      ),
                                    ),
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
              ],
            ),
          );
        }
      }),
    );
  }
}
