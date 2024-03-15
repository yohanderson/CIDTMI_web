import 'package:cidtmi/screens/desktop/shop/shop_desktop.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../bloc/cart_model.dart';

class ProductDesktop extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDesktop({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDesktop> createState() => _ProductDesktopState();
}

class _ProductDesktopState extends State<ProductDesktop> {
  int _selectedColorIndex = 0;
  int _selectedImageIndex = 0;
  int _modelSelect = 0;
  int _counterProduct = 1;
  late final Map<String, dynamic> product;




  @override
  Widget build(BuildContext context) {
    final sreenheight = MediaQuery.of(context).size.height;
    final product = widget.product;

    StoreDesktopViewState storeDesktopViewState = Provider.of<StoreDesktopViewState>(context);
    return SizedBox(
      height: sreenheight,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth / 3,
                child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          onPressed: () {
                            storeDesktopViewState.goBack();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: 35,
                          ),),
                      ),
                    ),
                    Container(
                      height: 280,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                            colors: [
                              Colors.black87.withOpacity(0.7),
                              Colors.black
                            ],
                          stops: [0.0, 0.6],
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              product['name'],
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow
                                  .ellipsis,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text('${product['quantity']}  piezas',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade400
                                        ),),
                                      ),
                                      if (product['promotion'] == null) ...[
                                        // Muestra solo el precio normal
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Text(
                                            NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                                .format(product['price_unit']),
                                            style: const TextStyle(
                                              color: Colors.cyanAccent,
                                                fontSize: 22),
                                          ),
                                        ),
                                      ]
                                      else ...[
                                        Text(
                                          NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                              .format(product['price_unit']),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Text(NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits:
                                        0).format(product['promotion']),
                                          style:
                                          const TextStyle( fontSize: 22, fontWeight:
                                          FontWeight.bold),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
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
                                              cart.addProduct(product, _counterProduct);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Theme.of(context).hintColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text('$_counterProduct',
                                                style: TextStyle(
                                                    color: Theme.of(context).textTheme.bodyMedium?.color
                                                ),),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _counterProduct++;
                                              });
                                              final cart = Provider.of<CartModel>(context, listen: false);
                                              cart.addProduct(product, _counterProduct);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                    Icons.add,
                                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )

                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    final cart = Provider.of<CartModel>(context, listen: false);
                                    final wasAdded = cart.addProduct(product, _counterProduct);
                                    if (!wasAdded) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text('producto agregado')),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        width: 1, color: Theme.of(context).colorScheme.background,
                                      )
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Agregar al carrito',
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: constraints.maxHeight / 1.2,
                        child: Image.network(
                          product['mdcp'][_modelSelect]['colors'][_selectedColorIndex]['photos'][_selectedImageIndex]['url'],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < product['mdcp'][_modelSelect]['colors'][_selectedColorIndex]['photos'].length; i++)
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
                                      border: Border.all(color: Colors.grey),
                                      color:
                                      i == _selectedImageIndex ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth / 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text( 'Medidas ',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 16,),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: product['mdcp'][_modelSelect]['dimensions']['height'],
                                      style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyMedium?.color,
                                          fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: 'cm x ',
                                      style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyMedium?.color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: product['mdcp'][_modelSelect]['dimensions']['width'],
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: 'cm x ',
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: product['mdcp'][_modelSelect]['dimensions']['depth'],
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: 'cm',
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Peso',
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 16),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: product['mdcp'][_modelSelect]['dimensions']['weight'],
                                        style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyMedium?.color,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: 'kg',
                                        style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyMedium?.color,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Marca',
                                  style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyMedium?.color,
                                      fontSize: 16),
                                ),
                              ),
                              Text(
                                product['brand'],
                                style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 16,
                                fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              height: constraints.maxHeight / 4.5,
                              width: constraints.maxWidth / 5,
                              child: SingleChildScrollView(
                                child: Text(
                                  product['description'],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Modelos:  ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(
                            width: constraints.maxWidth / 4.5,
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: product['mdcp']?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _modelSelect = index;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 6),
                                        child: Center(child: Text(product['mdcp'][index]['model'])),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            const Text('Colores:  ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(
                              height: 30,
                              width: constraints.maxWidth / 4.5,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: product['mdcp'][_modelSelect]['colors']?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return  Padding(
                                    padding: const EdgeInsets.only(right: 5),
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
                                          color: Color(product['mdcp'][_modelSelect]['colors'][index]['color']),
                                          border: Border.all(
                                            color: Colors.grey.shade500,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
