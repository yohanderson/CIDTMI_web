import 'package:cidtmi/screens/desktop/Account_desktop.dart';
import 'package:cidtmi/screens/desktop/login/change_password.dart';
import 'package:cidtmi/screens/desktop/login/login.dart';
import 'package:cidtmi/screens/desktop/login/register.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'bloc/auth/provider_auth.dart';

// mobile
import 'package:cidtmi/screens/mobile/cart_mobile.dart';
import 'package:cidtmi/screens/mobile/home_mobile.dart';
import 'package:cidtmi/screens/mobile/shop/shop_mobile.dart';

// tablet

import 'package:cidtmi/screens/tablet/cart_tablet.dart';
import 'package:cidtmi/screens/tablet/home_tablet.dart';
import 'package:cidtmi/screens/tablet/shop/shop_tablet.dart';

// desktop

import 'package:cidtmi/screens/desktop/cart_desktop.dart';
import 'package:cidtmi/screens/desktop/home_desktop.dart';
import 'package:cidtmi/screens/desktop/services/treatments_struc/Treatments_desktop.dart';
import 'package:cidtmi/screens/desktop/shop/shop_desktop.dart';

class Trips extends StatefulWidget {
  final ValueNotifier<bool> darkMode;
  const Trips({super.key, required this.darkMode});

  @override
  State<Trips> createState() => TripsState();
}

class TripsState extends State<Trips> {
  final ScrollController scrollController = ScrollController();

  final ValueNotifier<String> selectedAuth = ValueNotifier('login');


  bool navigatorBar = false;
  bool _isMenuOpen = false;
  int _selectedIndex = 0;

  void logInSelect () {
    showDialog(context: context, builder:
        (BuildContext context) {
      return ValueListenableBuilder<String>(
        valueListenable: selectedAuth,
        builder: (context, value, child) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: value == 'login'
                ? const Center(
              child: Text(
                'Iniciar sesión',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            )
                : value == 'register'
                ? const Center(
              child: Text(
                'Registrarse',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            )
                : const Center(
              child: Text(
                'Recupera tu cuenta',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            content: value == 'login' ? LogIn(selectedAuth: selectedAuth) : value == 'register'
                ? RegisterUser(selectedAuth: selectedAuth) : ChangePassword(selectedAuth: selectedAuth),
          );
        },
      );
    }
    );
  }

  ValueNotifier<bool> shopToTrue = ValueNotifier(false);
  ValueNotifier <Map<String, dynamic>> mapProduct = ValueNotifier({});


  void navigateToShop (Map<String, dynamic>  product ){

    setState(() {
      mapProduct.value = product;
      shopToTrue.value = true;
    _selectedIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();

    //mobile
    pagesIndex300 = [
      HomeMobileView(scrollController: scrollController),
      CartMobileView(goToIndex: goToIndex),
      StoreMobileView(goToIndex: goToIndex),
    ];

    //tablet
    pagesIndex600 = [
      HomeTabletView(scrollController: scrollController),
      CartTabletView(goToIndex: goToIndex),
      StoreTabletView(goToIndex: goToIndex),
    ];

    //desktop

    pagesIndex900 = [
      HomeDesktopView(scrollController: scrollController, navigateToShop: navigateToShop),
      StoreDesktopView(shopToTrue: shopToTrue, mapProduct: mapProduct, ),
      TreatmentsDesktop(logInSelect: logInSelect),
      CartDesktopView(goToIndex: goToIndex, logInSelect: logInSelect ),
      const AccountDesktop(),
    ];
  }

  //mobile
  late final List<Widget> pagesIndex300;

  Widget buildNavigationBar300() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        topLeft: Radius.circular(25),
      )),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          backgroundColor: Colors.black87,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: _selectedIndex == 0
                    ? Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications,
                            color: Colors.black87),
                      )
                    : const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      )),
            BottomNavigationBarItem(
                label: '',
                icon: _selectedIndex == 1
                    ? Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Icon(Icons.shopping_bag_rounded,
                                color: Colors.black87)),
                      )
                    : const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                      )),
            BottomNavigationBarItem(
                label: '',
                icon: _selectedIndex == 2
                    ? Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.build,
                          color: Colors.black87,
                        )),
                      )
                    : const Icon(
                        Icons.build,
                        color: Colors.white,
                      )),
          ],
        ),
      ),
    );
  }

  //tablet
  late final List<Widget> pagesIndex600;

  Widget buildNavigationBar600() {
    return SizedBox(
      width: navigatorBar == false ? 80 : 200,
      child: Expanded(
        child: Column(
          children: [
            if (navigatorBar == false) ...[
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  child: _selectedIndex == 0
                      ? Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF8e5cff),
                                Color(0xFFca4cfd),
                              ],
                            ),
                          ),
                          child:
                              const Icon(Icons.villa, color: Color(0xFF031542)))
                      : const SizedBox(
                          height: 35,
                          child: Icon(
                            Icons.villa,
                            color: Colors.white,
                          ),
                        ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  child: _selectedIndex == 1
                      ? Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFF8e5cff),
                                  Color(0xFFca4cfd),
                                ],
                              )),
                          child: const Icon(Icons.shopify_outlined,
                              color: Color(0xFF031542)))
                      : const SizedBox(
                          height: 35,
                          child: Icon(
                            Icons.shopify_outlined,
                            color: Colors.white,
                          ),
                        ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),
              InkWell(
                child: _selectedIndex == 2
                    ? Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF8e5cff),
                                Color(0xFFca4cfd),
                              ],
                            )),
                        child: const Icon(Icons.local_taxi,
                            color: Color(0xFF031542)))
                    : const SizedBox(
                        height: 35,
                        child: Icon(
                          Icons.local_taxi,
                          color: Colors.white,
                        ),
                      ),
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  ),
                  onPressed: () {
                    setState(() {
                      navigatorBar = true;
                    });
                  },
                ),
              ),
            ] else ...[
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: _selectedIndex == 0
                      ? Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF8e5cff),
                                Color(0xFFca4cfd),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 5),
                                child: Icon(
                                  Icons.villa,
                                  color: Color(0xFF031542),
                                ),
                              ),
                              Text(
                                'Alojamientos',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF031542),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 35,
                          width: 150,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 5),
                                child: Icon(Icons.villa, color: Colors.white),
                              ),
                              Text(
                                'Alojamientos',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: _selectedIndex == 1
                      ? Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF8e5cff),
                                Color(0xFFca4cfd),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 5),
                                child: Icon(
                                  Icons.shopify_outlined,
                                  color: Color(0xFF031542),
                                ),
                              ),
                              Text(
                                'Tienda',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF031542),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 35,
                          width: 150,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 5),
                                child: Icon(Icons.shopify_outlined,
                                    color: Colors.white),
                              ),
                              Text(
                                'Tienda',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: _selectedIndex == 2
                    ? Container(
                        height: 35,
                        width: 150,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0xFF8e5cff),
                              Color(0xFFca4cfd),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Icon(
                                Icons.local_taxi,
                                color: Color(0xFF031542),
                              ),
                            ),
                            Text(
                              'MotoCab',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF031542),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 35,
                        width: 150,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child:
                                  Icon(Icons.local_taxi, color: Colors.white),
                            ),
                            Text(
                              'MotoCab',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 15,
                  ),
                  onPressed: () {
                    setState(() {
                      navigatorBar = false;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  //desktop
  late final List<Widget> pagesIndex900;

  Widget buildNavigationBar900() {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 60,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                  height: 40,
                  child: Image.network('assets/img/citdmi.png')),
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Text(
                      'Inicio',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decorationThickness: 2,
                        height: 1.5,
                        decoration: _selectedIndex == 0 ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Text(
                          'Tienda',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decorationThickness: 2,
                        height: 1.5,
                        decoration: _selectedIndex ==1 ? TextDecoration.underline : TextDecoration.none,
                      ),
                        ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Text(
                      'Tratamientos',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decorationThickness: 2,
                        height: 1.5,
                        decoration: _selectedIndex == 2 ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                  Provider.of<AuthTokenProvider>(context).isAuthenticated == true ?
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    },
                    child: const Icon(Icons.person),
                  ) : InkWell(
                    onTap: logInSelect,
                    child: Container(
                      height: 30,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Iniciar sesion',
                          style: TextStyle(
                              color:
                              Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void goToIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return Scaffold(
          body: SafeArea(
            child: pagesIndex300[_selectedIndex],
          ),
          bottomNavigationBar: buildNavigationBar300(),
        );
      } else if (constraints.maxWidth < 600) {
        return Scaffold(
          body: Row(
            children: [
              buildNavigationBar600(),
              Expanded(
                child: pagesIndex600[_selectedIndex],
              )
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Stack(
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  width: width,
                  height: height + 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 0.9,
                      colors: [
                        const Color(0xFF211d44).withOpacity(0.2),
                        Colors.white
                      ],
                      stops: const [0.3, 0.8], // Define el porcentaje de cada color
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 40),
                        blurRadius: 40,
                        color: const Color(0xFF211d44).withOpacity(0.5),
                        inset: true,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  buildNavigationBar900(),
                  Expanded(
                    child: pagesIndex900[_selectedIndex],
                  ),
                ],
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: ValueListenableBuilder<bool>(
                  valueListenable: widget.darkMode,
                  builder: (context, value, child) {
                    var darkMode = value;
                    return darkMode == false ?
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.darkMode.value = true;
                        });
                      },
                      child: SizedBox(
                        width: 60,
                        height: 25,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(2,2),
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                    ),
                                    BoxShadow(
                                        offset: Offset(-2,-2),
                                        color: Color(0xFF031542).withOpacity(0.7),
                                        blurRadius: 4,
                                        inset: true
                                    ),
                                  ]
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Container(
                                  height: 17,
                                  width: 17,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF031542),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(2,2),
                                            color: Colors.white.withOpacity(0.7),
                                            blurRadius: 3,
                                            inset: true
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) : InkWell(
                      onTap: () {
                        setState(() {
                          widget.darkMode.value = false;
                        });
                      },
                      child: SizedBox(
                        width: 60,
                        height: 25,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFF031542),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(2,2),
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                    ),
                                    BoxShadow(
                                        offset: const Offset(1,1),
                                        color: Colors.white.withOpacity(0.7),
                                        blurRadius: 5,
                                        inset: true
                                    ),

                                  ]
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Container(
                                  height: 17,
                                  width: 17,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(-2,-2),
                                            color: Color(0xFF031542).withOpacity(0.7),
                                            blurRadius: 5,
                                            inset: true
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 150,
                  width: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                    ),
                    color: Colors.black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.network('assets/img/instagram.png'),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.network('assets/img/tiktok.png'),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.network('assets/img/whatsapp.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildMenu() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
            onPressed: () {
              _onItemTapped(0);
              setState(() {
                _isMenuOpen = false;
              });
            },
            child: const Text('Inicio', style: TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () {
              _onItemTapped(3);
              setState(() {
                _isMenuOpen = false;
              });
            },
            child: const Text('Tienda', style: TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () {
              _onItemTapped(2);
              setState(() {
                _isMenuOpen = false;
              });
            },
            child:
                const Text('Carrito', style: TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () {
              _onItemTapped(1);
              setState(() {
                _isMenuOpen = false;
              });
            },
            child: const Text('Portal de cliente',
                style: TextStyle(color: Colors.white))),
      ]),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, h * 0.75, 0, h);
    path.quadraticBezierTo(w * 0.25, h, w, h);
    path.lineTo(w, 0);
    path.quadraticBezierTo(w * 0.90, 0, w * 0.90, 0);
    path.cubicTo(w * 0.75, 0, w * 0.75, h * 0.95, w * 0.5, h * 0.9);
    path.cubicTo(w * 0.25, h * 0.95, w * 0.25, 0, w * 0.1, 0);
    path.quadraticBezierTo(w * 0.1, 0, 0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

