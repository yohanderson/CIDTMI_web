import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/cart_model.dart';
import '../../bloc/dates_state_bloc.dart';

class HomeDesktopView extends StatefulWidget {
  final ScrollController scrollController;
  final void Function(Map<String, dynamic> product) navigateToShop;

  const HomeDesktopView(
      {super.key,
      required this.scrollController,
      required this.navigateToShop});

  @override
  State<HomeDesktopView> createState() => _HomeDesktopViewState();
}

class _HomeDesktopViewState extends State<HomeDesktopView>
    with TickerProviderStateMixin {
  // mapa

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-32.75184727774852, -70.72612684891035);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('myMarker'),
      position: LatLng(-32.75184727774852, -70.72612684891035),
      infoWindow: InfoWindow(
        title: 'Mundo Cell',
        snippet:
            'Calle salinas 1385 edificio el e comendador local 5 San Felipe, 2170000 Valparaíso, Chile',
      ),
    ),
  };

  // galery photos

  int _currentIndex = 0;

  void _nextPage() {
    setState(() {
      _currentIndex += 2;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeIn,
      );
    });
  }

  void _previousPage() {
    setState(() {
      _currentIndex -= 2;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeIn,
      );
    });
  }

  final _pageController = PageController(viewportFraction: 0.5, initialPage: 0);

  // listview content

  int _currentContentIndex = 0;
  final int _counterProduct = 1;

  List<Map<String, dynamic>> contentList = [
    {
      'title': 'Analisis',
      'subTitle': 'Bioanalizador Cuantico',
      'content':
          'Escaner de resonancia magnética, realiza un diagnóstico de todo tu organismo. diagnóstica más de 45 parámetros de tu cuerpo. Cerebro, corazón, Pulmones, hígado, páncreas, vesícula biliar, bazo, etc..',
      'url': 'assets/img/web3.png',
      'botonText': 'Tratamietos',
      'botonFunction': 'Tratamietos',
    },
    {
      'title': 'Intravenoso',
      'subTitle': 'Oligo Elementos',
      'content':
          'Escaner de resonancia magnética, realiza un diagnóstico de todo tu organismo. diagnóstica más de 45 parámetros de tu cuerpo. Cerebro, corazón, Pulmones, hígado, páncreas, vesícula biliar, bazo, etc..',
      'url': 'assets/img/web3.png',
      'botonText': 'Tratamietos',
      'botonFunction': 'Tratamietos',
    },
    {
      'title': 'Acunpuntura',
      'subTitle': 'Bioanalizador Cuantico',
      'content':
          'Escaner de resonancia magnética, realiza un diagnóstico de todo tu organismo. diagnóstica más de 45 parámetros de tu cuerpo. Cerebro, corazón, Pulmones, hígado, páncreas, vesícula biliar, bazo, etc..',
      'url': 'assets/img/web4.png',
      'botonText': 'Tratamietos',
      'botonFunction': 'Tratamietos',
    },
  ];

  final listContentController =
      PageController(viewportFraction: 1, initialPage: 0);

  void _changeContent(int newIndex) {
    setState(() {
      _currentContentIndex = newIndex;
    });
  }

  // inicializacion

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: constraints.maxWidth / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 80),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  contentList[_currentContentIndex]['title'],
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  contentList[_currentContentIndex]['subTitle'],
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  contentList[_currentContentIndex]['content'],
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    height: 45,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(35),
                                          bottomLeft: Radius.circular(35),
                                        ),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        contentList[_currentContentIndex]
                                            ['botonText'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 19),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ValueListenableBuilder<List<Map<String, dynamic>>>(
                              valueListenable:
                                  Provider.of<ConnectionDatesBlocs>(context)
                                      .products,
                              builder: (context, value, child) {
                                final products = value;
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (_currentIndex > 0) ...[
                                              InkWell(
                                                onTap: _previousPage,
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    35),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    35),
                                                            topLeft:
                                                                Radius.circular(
                                                                    35),
                                                          )),
                                                  child: const Icon(
                                                    Icons.chevron_left_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ] else ...[
                                              const SizedBox(
                                                width: 50,
                                                height: 50,
                                              ),
                                            ],
                                            const Text(
                                              'Productos tienda',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                            if (_currentIndex <
                                                products.length - 2) ...[
                                              InkWell(
                                                onTap: _nextPage,
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    35),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    35),
                                                            topLeft:
                                                                Radius.circular(
                                                                    35),
                                                          )),
                                                  child: const Icon(
                                                    Icons.chevron_right_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ] else ...[
                                              const SizedBox(
                                                width: 50,
                                                height: 50,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: SizedBox(
                                        height: 190,
                                        width: 530,
                                        child: Center(
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            controller: _pageController,
                                            itemCount: products.length,
                                            itemBuilder: (context, index) {
                                              final product = products[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 13,
                                                    left: 13,
                                                    bottom: 20),
                                                child: SizedBox(
                                                  height: 190,
                                                  width: 240,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 130,
                                                          width: 240,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        1, 1),
                                                                blurRadius: 10,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.2),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 15,
                                                                      bottom:
                                                                          15,
                                                                      right:
                                                                          10),
                                                              child: SizedBox(
                                                                width: 100,
                                                                child: Image
                                                                    .network(
                                                                  product['mdcp'][0]['colors']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'photos']
                                                                      [
                                                                      0]['url'],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 100,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            60,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          final cart = Provider.of<CartModel>(
                                                                              context,
                                                                              listen: false);
                                                                          final success = cart.addProduct(
                                                                              product,
                                                                              _counterProduct);
                                                                          if (success) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(backgroundColor: Colors.green, content: Text('Producto agregado al carrito')),
                                                                            );
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(backgroundColor: Colors.red, content: Text('Este producto ya está en el carrito')),
                                                                            );
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              35,
                                                                          width:
                                                                              35,
                                                                          decoration: const BoxDecoration(
                                                                              color: Colors.black,
                                                                              borderRadius: BorderRadius.only(
                                                                                topRight: Radius.circular(35),
                                                                                bottomRight: Radius.circular(35),
                                                                                topLeft: Radius.circular(35),
                                                                              )),
                                                                          child:
                                                                              const Icon(
                                                                            Icons.shopping_cart_outlined,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    product[
                                                                        'name'],
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        fontSize:
                                                                            14),
                                                                    maxLines: 2,
                                                                    // Limita a una línea de altura
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                    child: Text(
                                                                      NumberFormat.simpleCurrency(
                                                                              locale: 'en_US',
                                                                              decimalDigits: 0)
                                                                          .format(product['price_unit']),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      widget.navigateToShop(
                                                                          product);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          25,
                                                                      width:
                                                                          110,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .black87,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.remove_red_eye,
                                                                              color: Colors.white,
                                                                              size: 12,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(
                                                                              'Ver producto',
                                                                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 10),
                                                                            ),
                                                                          ],
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
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      )),
                  SizedBox(
                      width: constraints.maxWidth / 2,
                      height: MediaQuery.of(context).size.height,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: constraints.maxWidth / 2,
                                  child: Stack(
                                    children: [
                                      Center(
                                          child: Image.network(
                                              contentList[_currentContentIndex]
                                                  ['url'])),
                                      Positioned(
                                        right: 20,
                                        top: 20,
                                        child: InkWell(
                                          onTap: () {
                                            // Cambiar al siguiente índice (circularmente)
                                            _changeContent(
                                                (_currentContentIndex + 1) %
                                                    contentList.length);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(35),
                                                  bottomRight:
                                                      Radius.circular(35),
                                                  topLeft: Radius.circular(35),
                                                )),
                                            child: const Icon(
                                              Icons.chevron_right_sharp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ))
                ],
              );
            }),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 450,
                    width: 450,
                    child: GoogleMap(
                      markers: _markers,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 15.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 700,
                    width: 470,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Text(
                              '¿Tienes una duda específica? Contacta con nosotros',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 210,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'UBICACIÓN',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Calle salinas 1385 Local 5',
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            'San Felipe, Valparaíso, 2170000, Chile',
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 230,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'CONTACTO',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Móvil :  +56 967048828',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            'Email : Contact@mundocellcl.com',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 210,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              'HORARIO DE ATENCIÓN',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              'Lun – Vier  09:00 – 19:00',
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              'Sab – Dom 10:00 – 14:00',
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            '¡SIGUENOS EN INSTAGRAM!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: InkWell(
                                              onTap: () async {
                                                const url =
                                                    'https://www.instagram.com/mundocel.cl/';
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'No se pudo abrir la URL $url';
                                                }
                                              },
                                              child: SizedBox(
                                                height: 25,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.camera_alt,
                                                        color: Colors.white),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Text(
                                                        'mundocel.cl',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
