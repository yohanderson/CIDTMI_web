import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/dates_state_bloc.dart';

class HomeTabletView extends StatefulWidget {
  final ScrollController scrollController;


  const HomeTabletView(
      {super.key, required this.scrollController});

  @override
  State<HomeTabletView> createState() => _HomeTabletViewState();
}

class _HomeTabletViewState extends State<HomeTabletView> with TickerProviderStateMixin {

  // hover animation scale

  bool _isHovering = false;
  bool _isHoveringone = false;
  bool _isHoveringtwo = false;
  bool _isHoveringButtonOne = false;
  bool _isHoveringButtonTwo = false;
  bool _isHoveringButtonThree = false;
  bool _isHoveringButtonFour = false;
  bool _isHoveringButtonFive = false;
  bool _isHoveringButtonSix = false;
  bool _isHoveringButtonSeven = false;
  bool _isHoveringButtonEight = false;


  //animacion

  final _imageKey = [
    [GlobalKey(), GlobalKey(), GlobalKey()],
    [GlobalKey()],
    [GlobalKey()],
    [GlobalKey(), GlobalKey(), GlobalKey()],
    [GlobalKey(), GlobalKey()],
    [GlobalKey(), GlobalKey()],
  ];

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  late final List<bool> _isAnimating;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _imageKey.length,
          (index) => AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      ),
    );

    _animations = _controllers
        .map(
          (controller) => Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      )),
    )
        .toList();

    _isAnimating = List.filled(_imageKey.length, false);
    _controllers.first.forward();

    widget.scrollController.addListener(_onScroll);

    phoneNumberController.addListener(() {
      final text = phoneNumberController.text;
      if (text.isNotEmpty && int.tryParse(text) == null) {
        phoneNumberController.clear();
      }
    });
  }


  void _onScroll() {
    for (var i = 1; i < _imageKey.length; i++) {
      for (var j = 0; j < _imageKey[i].length; j++) {
        if (!_isAnimating[i]) {
          final imagePosition =
          (_imageKey[i][j].currentContext?.findRenderObject() as RenderBox?)
              ?.localToGlobal(Offset.zero);
          if (imagePosition != null &&
              imagePosition.dy < MediaQuery.of(context).size.height) {
            setState(() => _isAnimating[i] = true);
            _controllers[i].forward();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    widget.scrollController.removeListener(_onScroll);
    phoneNumberController.dispose();
    super.dispose();
  }

  // calendar

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isDaySelected = false;

  // form

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final equipmentTypeController = TextEditingController();
  final fallaTypeController = TextEditingController();
  final timeController = TextEditingController();
  String countryCode = 'CL';
  String completePhoneNumber = '';

  final keyFormAppointments = GlobalKey<FormState>();

  // database

  String generateCode() {
    String name = nameController.text;
    String firstName = name.split(' ')[0];
    String firstChar = firstName;

    String phoneNumber = phoneNumberController.text;

    if (nameController.text.isEmpty || phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, llene todos los campos requeridos'),
        ),
      );
      return '';
    }

    String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);
    String codeClientCite = firstChar + lastFourDigits;
    return codeClientCite;
  }

  String codeClient = '';

  void showSuccessDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Éxito!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text('Tu cita fue agendada de manera exitosa.'),
              Text('Este es tu código de cita: $code'),
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

  void _sumbitCite() async {
    final name = nameController.text;
    final lastName = lastNameController.text;
    final emailUser = userEmailController.text;
    final phoneNumber = completePhoneNumber;
    final equipmentType = equipmentTypeController.text;
    final fallaType = fallaTypeController.text;
    final time = timeController.text;
    const state = 'Reserva agendada';
    codeClient = generateCode();

    final parsedTime = DateFormat('hh:mm a').parse(time);
    final formattedTime = DateFormat('HH:mm:ss').format(parsedTime);



    final dateTime =
        '${DateFormat('yyyy-MM-dd').format(_selectedDay!)} $formattedTime+00:00';

    final now = DateTime.now();
    final formattedNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now) + '+00:00';


    const String connection = 'http:$ipPort';

    String route = '/create_Reserves';

    var url = Uri.parse('$connection$route');

    var headers = {'Content-Type': 'application/json; charset=UTF-8'};

    var body = jsonEncode({
      'name': name,
      'lastName': lastName,
      'emailUser': emailUser,
      'phoneNumber': phoneNumber,
      'equipmentType': equipmentType,
      'dateTime': dateTime,
      'createdAt': formattedNow,
      'fallaType': fallaType,
      'state': state,
      'code': codeClient,
      'idNotifications': false,
    });

    bool isValid = keyFormAppointments.currentState!.validate();

    if (isValid) {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        nameController.clear();
        lastNameController.clear();
        userEmailController.clear();
        phoneNumberController.clear();
        equipmentTypeController.clear();
        fallaTypeController.clear();
        timeController.clear();
        showSuccessDialog(context, codeClient);

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

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Center(child: Text('Error')),
            content: const Text('Uno o más campos no son válidos.'),
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
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double fontSize;

                    if (constraints.maxWidth > 800) {
                      // Escritorio
                      fontSize = 50;
                    } else if (constraints.maxWidth > 600) {
                      // Tableta
                      fontSize = 40;
                    } else {
                      // Móvil
                      fontSize = 40;
                    }

                    return Text(
                      'UN LUGAR PARA TÚ SOLUCIÓN MÓVIL',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double fontSize;

                    if (constraints.maxWidth > 800) {
                      // Escritorio
                      fontSize = 30;
                    } else if (constraints.maxWidth > 600) {
                      // Tableta
                      fontSize = 25;
                    } else {
                      // Móvil
                      fontSize = 30;
                    }

                    return Text(
                      'LABORATORIO ESPECIALIZADO',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
                  },
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    // Escritorio
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 300,
                          width: 280,
                          child: ScaleTransition(
                            key: _imageKey[0][0],
                            scale: _animations[0],
                            child: AnimatedBuilder(
                                animation: Listenable.merge([ _controllers[0]]),
                              builder: (context, child) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SERVICIO TÉCNICO',
                                        style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: 250,
                                          child: Text(
                                            'Nuestro objetivo es forjar una relación de confianza con todos nuestros clientes. Cualquier problema que tengas con tu dispositivo móvil, cuenta con nosotros.',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      MouseRegion(
                                        onEnter: (event) => setState(
                                            () => _isHoveringButtonOne = true),
                                        onExit: (event) => setState(
                                            () => _isHoveringButtonOne = false),
                                        child: Transform.scale(
                                          scale: _isHoveringButtonOne ? 1.15 : 1.0,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 40,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                              child: const Center(
                                                child: Text(
                                                  'Contactar',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: MouseRegion(
                            onEnter: (event) =>
                                setState(() => _isHovering = true),
                            onExit: (event) =>
                                setState(() => _isHovering = false),
                            child: ScaleTransition(
                              key: _imageKey[0][1],
                              scale: _animations[0],
                              child: AnimatedBuilder(
                                  animation: Listenable.merge([_controllers[0]]),
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _isHovering ? 1.10 : 1.0,
                                    child: Image.asset('assets/img/admin-ajax.png'),
                                  );
                                }
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: ScaleTransition(
                            key: _imageKey[0][2],
                            scale: _animations[0],
                            child: AnimatedBuilder(
                                animation: Listenable.merge([ _controllers[0]]),
                              builder: (context, child) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'ACCESORIOS MÓVILES',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '¡Los mejores accesorios para tu dispositivo móvil están aquí!',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ),
                                        MouseRegion(
                                          onEnter: (event) => setState(
                                              () => _isHoveringButtonTwo = true),
                                          onExit: (event) => setState(
                                              () => _isHoveringButtonTwo = false),
                                          child: Transform.scale(
                                            scale:
                                                _isHoveringButtonTwo ? 1.15 : 1.0,
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 40,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(20)),
                                                child: const Center(
                                                  child: Text(
                                                    'Ver tienda',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'DISPOSITIVOS',
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '¡Amplia gama de celulares en stock IPhone, Xiaomi, Samsung, LG y muchos más!',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MouseRegion(
                                              onEnter: (event) => setState(() =>
                                                  _isHoveringButtonThree = true),
                                              onExit: (event) => setState(() =>
                                                  _isHoveringButtonThree = false),
                                              child: Transform.scale(
                                                scale: _isHoveringButtonThree
                                                    ? 1.15
                                                    : 1.0,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 40,
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20)),
                                                    child: const Center(
                                                      child: Text(
                                                        'Ver tienda',
                                                        style: TextStyle(
                                                            color: Colors.white),
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
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  else if (constraints.maxWidth > 600) {
                    // Tableta
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 400,
                          width: 150,
                          child: ScaleTransition(
                            key: _imageKey[0][0],
                            scale: _animations[0],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SERVICIO TÉCNICO',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Nuestro objetivo es forjar una relación de confianza con todos nuestros clientes. Cualquier problema que tengas con tu dispositivo móvil, cuenta con nosotros.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Text(
                                        'Contactar',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: MouseRegion(
                            onEnter: (event) =>
                                setState(() => _isHovering = true),
                            onExit: (event) =>
                                setState(() => _isHovering = false),
                            child: ScaleTransition(
                              key: _imageKey[0][1],
                              scale: _animations[0],
                              child: Transform.scale(
                                scale: _isHovering ? 1.10 : 1.0,
                                child: Image.asset('assets/img/admin-ajax.png'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: ScaleTransition(
                            key: _imageKey[0][2],
                            scale: _animations[0],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'ACCESORIOS MÓVILES',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        '¡Los mejores accesorios para tu dispositivo móvil están aquí!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 35,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Center(
                                          child: Text(
                                            'Ver tienda',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'DISPOSITIVOS',
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '¡Amplia gama de celulares en stock IPhone, Xiaomi, Samsung, LG y muchos más!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 35,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Center(
                                              child: Text(
                                                'Ver tienda',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
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
                        ),
                      ],
                    );
                  }
                  else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 10),
                            child: SizedBox(
                              width: 350,
                              child: ScaleTransition(
                                key: _imageKey[0][0],
                                scale: _animations[0],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SERVICIO TÉCNICO',
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: SizedBox(
                                        width: 250,
                                        child: Text(
                                          'Nuestro objetivo es forjar una relación de confianza con todos nuestros clientes. Cualquier problema que tengas con tu dispositivo móvil, cuenta con nosotros.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Center(
                                          child: Text(
                                            'Contactar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (event) =>
                                setState(() => _isHovering = true),
                            onExit: (event) =>
                                setState(() => _isHovering = false),
                            child: ScaleTransition(
                              key: _imageKey[0][1],
                              scale: _animations[0],
                              child: Transform.scale(
                                scale: _isHovering ? 1.10 : 1.0,
                                child: Image.asset('assets/img/admin-ajax.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: ScaleTransition(
                              key: _imageKey[0][2],
                              scale: _animations[0],
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'ACCESORIOS MÓVILES',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '¡Los mejores accesorios para tu dispositivo móvil están aquí!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Center(
                                            child: Text(
                                              'Ver tienda',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'DISPOSITIVOS',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            '¡Amplia gama de celulares en stock IPhone, Xiaomi, Samsung, LG y muchos más!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 30),
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Center(
                                                child: Text(
                                                  'Ver tienda',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: ScaleTransition(
                          key: _imageKey[1][0],
                          scale: _animations[1],
                          child: MouseRegion(
                            onEnter: (event) =>
                                setState(() => _isHoveringone = true),
                            onExit: (event) =>
                                setState(() => _isHoveringone = false),
                            child: AnimatedBuilder(
                              animation: Listenable.merge(
                                  [_animations[1], _controllers[1]]),
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isHoveringone ? 1.15 : 1.0,
                                  child: child,
                                );
                              },
                              child: SizedBox(
                                  height: 400,
                                  child: Image.asset(
                                      'assets/img/admin-ajax1.png')),
                            ),
                          )),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                'Conoce nuestra sección de auriculares',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: SizedBox(
                                  width: 500,
                                  child: Center(
                                    child: Text(
                                      'Los mejores auriculares están aquí, con garantía incluida en tu compra, pincha debajo para conocer más.',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              MouseRegion(
                                onEnter: (event) => setState(
                                    () => _isHoveringButtonFour = true),
                                onExit: (event) => setState(
                                    () => _isHoveringButtonFour = false),
                                child: Transform.scale(
                                  scale: _isHoveringButtonFour ? 1.15 : 1.0,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 40,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text(
                                          'Haz click aquí',
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.white),
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
                    )
                  ],
                ),
              );
            } else {
              return Container(
                width: screenWidth,
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: ScaleTransition(
                          key: _imageKey[1][0],
                          scale: _animations[1],
                          child: MouseRegion(
                            onEnter: (event) =>
                                setState(() => _isHoveringone = true),
                            onExit: (event) =>
                                setState(() => _isHoveringone = false),
                            child: AnimatedBuilder(
                              animation: Listenable.merge(
                                  [_animations[1], _controllers[1]]),
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isHoveringone ? 1.15 : 1.0,
                                  child: child,
                                );
                              },
                              child: SizedBox(
                                  height: 300,
                                  child: Image.asset(
                                      'assets/img/admin-ajax1.png')),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenWidth,
                            child: Text(
                              'Conoce nuestra sección de auriculares',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: SizedBox(
                              width: 400,
                              child: Center(
                                child: Text(
                                  'Los mejores auriculares están aquí, con garantía incluida en tu compra, pincha debajo para conocer más.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Center(
                                  child: Text(
                                    'Haz click aquí',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Accesorios y Gaming',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Center(
                              child: SizedBox(
                                width: 400,
                                child: Text(
                                  'Amplia gama de accesorios y equipo de Gaming para ti',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (event) =>
                                setState(() => _isHoveringButtonFive = true),
                            onExit: (event) =>
                                setState(() => _isHoveringButtonFive = false),
                            child: Transform.scale(
                              scale: _isHoveringButtonFive ? 1.15 : 1.0,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                    child: Text(
                                      'Haz click aquí',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ScaleTransition(
                      key: _imageKey[2][0],
                      scale: _animations[2],
                      child: SizedBox(
                          child: MouseRegion(
                        onEnter: (event) =>
                            setState(() => _isHoveringtwo = true),
                        onExit: (event) =>
                            setState(() => _isHoveringtwo = false),
                        child: AnimatedBuilder(
                          animation: Listenable.merge(
                              [_animations[2], _controllers[2]]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isHoveringtwo ? 1.15 : 1.0,
                              child: child,
                            );
                          },
                          child: SizedBox(
                              height: 400,
                              child: Image.asset('assets/img/admin-ajax2.png')),
                        ),
                      )),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                width: screenWidth,
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  children: [
                    SizedBox(
                      child: ScaleTransition(
                        key: _imageKey[2][0],
                        scale: _animations[2],
                        child: SizedBox(
                            child: MouseRegion(
                          onEnter: (event) =>
                              setState(() => _isHoveringtwo = true),
                          onExit: (event) =>
                              setState(() => _isHoveringtwo = false),
                          child: AnimatedBuilder(
                            animation: Listenable.merge(
                                [_animations[2], _controllers[2]]),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _isHoveringtwo ? 1.15 : 1.0,
                                child: child,
                              );
                            },
                            child: SizedBox(
                                height: 300,
                                child:
                                    Image.asset('assets/img/admin-ajax2.png')),
                          ),
                        )),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Text(
                            'Accesorios y Gaming',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Center(
                              child: SizedBox(
                                width: 200,
                                child: Text(
                                  'Amplia gama de accesorios y equipo de Gaming para ti',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Center(
                                  child: Text(
                                    'Haz click aquí',
                                    style: TextStyle(color: Colors.white),
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
              );
            }
          },
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Align(
                  alignment: MediaQuery.of(context).size.width <= 800
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Sobre nosotros',
                      textAlign: MediaQuery.of(context).size.width <= 800
                          ? TextAlign.center
                          : TextAlign.start,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Somos un empresa especialista en reparaciones a nivel avanzado de placas, cambios de piezas, mantenimientos preventivos y correctivos de equipos electrónicos Apple y multimarca',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize:
                          MediaQuery.of(context).size.width <= 800 ? 18 : 25,
                    ),
                  ),
                  textAlign: MediaQuery.of(context).size.width <= 800
                      ? TextAlign.center
                      : TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Ofrecemos reparaciones de alta calidad con las mejores herramientas tecnológicas que abarcan las reparaciones mas avanzadas, garantizamos trabajos de calidad, brindamos confianza al cliente contamos con excelente calidad y precio así mismo dando satisfacción recomendación y exclusividad a nuestros clientes.',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize:
                          MediaQuery.of(context).size.width <= 800 ? 18 : 25,
                    ),
                  ),
                  textAlign: MediaQuery.of(context).size.width <= 800
                      ? TextAlign.center
                      : TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15),
                child: Align(
                  alignment: MediaQuery.of(context).size.width <= 800
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Text(
                    'Nuestros servicios',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return SizedBox(
                    width: screenWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.android,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sistema operativo',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MouseRegion(
                                    onEnter: (event) => setState(
                                        () => _isHoveringButtonSix = true),
                                    onExit: (event) => setState(
                                        () => _isHoveringButtonSix = false),
                                    child: Transform.scale(
                                      scale: _isHoveringButtonSix ? 1.15 : 1.0,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.yellow),
                                          child: const Center(
                                            child: Text(
                                              'ver más',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
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
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.apple,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Desbloqueos',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MouseRegion(
                                    onEnter: (event) => setState(
                                        () => _isHoveringButtonSeven = true),
                                    onExit: (event) => setState(
                                        () => _isHoveringButtonSeven = false),
                                    child: Transform.scale(
                                      scale:
                                          _isHoveringButtonSeven ? 1.15 : 1.0,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.yellow),
                                          child: const Center(
                                            child: Text(
                                              'ver más',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
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
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.build,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Servicio técnico',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MouseRegion(
                                    onEnter: (event) => setState(
                                        () => _isHoveringButtonEight = true),
                                    onExit: (event) => setState(
                                        () => _isHoveringButtonEight = false),
                                    child: Transform.scale(
                                      scale:
                                          _isHoveringButtonEight ? 1.15 : 1.0,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.yellow),
                                          child: const Center(
                                            child: Text(
                                              'ver más',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
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
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    width: screenWidth,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.android,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sistema operativo',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.yellow),
                                      child: const Center(
                                        child: Text(
                                          'ver más',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.apple,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Desbloqueos',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.yellow),
                                      child: const Center(
                                        child: Text(
                                          'ver más',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                          child: SizedBox(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.build,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Servicio técnico',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.yellow),
                                      child: const Center(
                                        child: Text(
                                          'ver más',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
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
                  );
                }
              }),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  children: [
                    ScaleTransition(
                      key: _imageKey[3][0],
                      scale: _animations[3],
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: 80,
                        ),
                        child: Text(
                          '¿Qué dicen nuestros clientes?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 150,
                            width: 400,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: ScaleTransition(
                              key: _imageKey[3][1],
                              scale: _animations[3],
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Text(
                                      '"Exelente Servicio, Atienden super Rapido y todo lo que venden es de Calidad y reparan desde Telefonos hasta Tablets, Incluso Hacen Revisión a consolas, Etc Exelente Servicio 10/10"',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'TooniF',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 150,
                            width: 400,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: ScaleTransition(
                              key: _imageKey[3][2],
                              scale: _animations[3],
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Text(
                                      '"La mente te resuelven el problema y te ofrecen diversas opciones para lograr la mejor reparación todo de calidad muy rápido. Y muy eficiente."',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Carlos Fernando Porras',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container(
                width: screenWidth,
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 80,
                      ),
                      child: Text(
                        '¿Qué dicen nuestros clientes?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40, bottom: 100, left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 160,
                            width: 400,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Text(
                                    '"Exelente Servicio, Atienden super Rapido y todo lo que venden es de Calidad y reparan desde Telefonos hasta Tablets, Incluso Hacen Revisión a consolas, Etc Exelente Servicio 10/10"',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                Text(
                                  'TooniF',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Container(
                              height: 160,
                              width: 400,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Text(
                                      '"La mente te resuelven el problema y te ofrecen diversas opciones para lograr la mejor reparación todo de calidad muy rápido. Y muy eficiente."',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    'Carlos Fernando Porras',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
        if (_isDaySelected == false) ...[
          SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: Text(
                    '¡Agenda una cita con nosotros en cualquier momento del día!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 800 ? 35 : 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 0.75))
                ],
              ),
              child: Builder(builder: (context) {
                return TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    final currentTime = DateTime.now();
                    final isToday = selectedDay.year == currentTime.year &&
                        selectedDay.month == currentTime.month &&
                        selectedDay.day == currentTime.day;
                    final isWithinAllowedTime =
                        currentTime.hour >= 00 && currentTime.hour < 17;

                    if (selectedDay.isBefore(DateTime.now()) &&
                        !(isToday && isWithinAllowedTime)) {
                      const snackBar = SnackBar(
                        content: Text(
                            'No puedes agendar una cita en una fecha anterior al día actual'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      _isDaySelected = true;
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: const CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                    todayDecoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                  ),
                );
              }),
            ),
          ),
        ],
        if (_isDaySelected == true) ...[
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Builder(builder: (context) {
                return SizedBox(
                  height: 900,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                            stops: [
                              0.8,
                              0.2,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Colors.transparent,
                              Colors.lightBlue,
                            ],
                            stops: [
                              0.8,
                              0.2,
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 35,
                            left: 25,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isDaySelected = false;
                                  _selectedDay = null;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: SizedBox(
                                width: 800,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Estás reservando: ¡Agenda una cita con nosotros en cualquier momento del día!',
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'Fecha seleccionada: ${DateFormat.yMMMd().format(_selectedDay!)}',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 600,
                                      child: Form(
                                        key: keyFormAppointments,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              inputFormatters: [
                                                CapitalizeFirstLetterTextNames()
                                              ],
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                labelText: 'Nombre',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Radio del borde redondeado
                                                  borderSide: const BorderSide(
                                                    color: Colors
                                                        .lightBlue, // Color del borde
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Por favor ingrese su nombre';
                                                }
                                                return null;
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextFormField(
                                                inputFormatters: [
                                                  CapitalizeFirstLetterTextNames()
                                                ],
                                                controller: lastNameController,
                                                decoration: InputDecoration(
                                                  labelText: 'Apellido',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors
                                                          .lightBlue,
                                                    ),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Por favor ingrese su apellido';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: TextFormField(
                                                controller: userEmailController,
                                                decoration: InputDecoration(
                                                  labelText: 'Email',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    borderSide:
                                                    const BorderSide(
                                                      color: Colors
                                                          .lightBlue,
                                                    ),
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                ],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Por favor ingrese su correo electrónico';
                                                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                    return 'Por favor ingrese un correo electrónico válido';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: IntlPhoneField(
                                                controller:
                                                    phoneNumberController,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Número de teléfono',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // Radio del borde redondeado
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors
                                                          .lightBlue, // Color del borde
                                                    ),
                                                  ),
                                                ),
                                                initialCountryCode: 'CL',
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onChanged: (phone) {
                                                  setState(() {
                                                    countryCode =
                                                        phone.countryCode;
                                                    completePhoneNumber =
                                                        phone.completeNumber;
                                                  });
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextFormField(
                                                inputFormatters: [
                                                  CapitalizeFirstLetterTextFormatter()
                                                ],
                                                controller:
                                                    equipmentTypeController,
                                                decoration: InputDecoration(
                                                  labelText: 'Tipo de equipo',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // Radio del borde redondeado
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors
                                                          .lightBlue, // Color del borde
                                                    ),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Por favor ingrese el tipo de equipo';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextFormField(
                                                inputFormatters: [
                                                  CapitalizeFirstLetterTextFormatter()
                                                ],
                                                controller: fallaTypeController,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Falla que presenta el equipo',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // Radio del borde redondeado
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors
                                                          .lightBlue, // Color del borde
                                                    ),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Debes de ingrtesar la falla que pesentas';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextFormField(
                                                controller: timeController,
                                                decoration: InputDecoration(
                                                  labelText: 'Hora de la cita',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                readOnly: true,
                                                onTap: () async {
                                                  final TimeOfDay? selectedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return MediaQuery(
                                                        data: MediaQuery.of(context).copyWith(
                                                          alwaysUse24HourFormat: false,
                                                          accessibleNavigation: true,
                                                        ),
                                                        child: Builder(
                                                          builder: (context) {
                                                            return child!;
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );

                                                  if (selectedTime != null) {
                                                    if (selectedTime.hour >= 7 && selectedTime.hour <= 19) {
                                                      timeController.text = selectedTime.format(context);
                                                    } else {
                                                      // Si la hora seleccionada está fuera del horario permitido,
                                                      // muestra un mensaje de error en el validador.
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('La hora seleccionada está fuera del horario permitido'),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                validator: (value) {
                                                  return null;
                                                },

                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: ElevatedButton(
                                                onPressed: _sumbitCite,
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.black,
                                                  minimumSize: Size(150, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                ),
                                                child:
                                                    const Text('Agendar cita'),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
            } else {
              return Builder(builder: (context) {
                return SizedBox(
                  height: 880,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.transparent,
                              Colors.lightBlue,
                            ],
                            stops: [
                              0.8,
                              0.2,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Colors.transparent,
                              Colors.lightBlue,
                            ],
                            stops: [
                              0.8,
                              0.2,
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 25,
                            left: 25,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isDaySelected = false;
                                  _selectedDay = null;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: SizedBox(
                                width: 330,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Estás reservando: ¡Agenda una cita con nosotros en cualquier momento del día!',
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'Fecha seleccionada: ${DateFormat.yMMMd().format(_selectedDay!)}',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 450,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            inputFormatters: [
                                              CapitalizeFirstLetterTextNames()
                                            ],
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              labelText: 'Nombre',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                // Radio del borde redondeado
                                                borderSide: const BorderSide(
                                                  color: Colors
                                                      .black, // Color del borde
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                              inputFormatters: [
                                                CapitalizeFirstLetterTextNames()
                                              ],
                                              controller: lastNameController,
                                              decoration: InputDecoration(
                                                labelText: 'Apellido',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Radio del borde redondeado
                                                  borderSide: const BorderSide(
                                                    color: Colors
                                                        .black, // Color del borde
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: IntlPhoneField(
                                              controller: phoneNumberController,
                                              decoration: InputDecoration(
                                                labelText: 'Número de teléfono',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Radio del borde redondeado
                                                  borderSide: const BorderSide(
                                                    color: Colors
                                                        .black, // Color del borde
                                                  ),
                                                ),
                                              ),
                                              initialCountryCode: 'CL',
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (phone) {
                                                setState(() {
                                                  countryCode =
                                                      phone.countryCode;
                                                  completePhoneNumber =
                                                      phone.completeNumber;
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                              inputFormatters: [
                                                CapitalizeFirstLetterTextFormatter()
                                              ],
                                              controller:
                                                  equipmentTypeController,
                                              decoration: InputDecoration(
                                                labelText: 'Tipo de equipo',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Radio del borde redondeado
                                                  borderSide: const BorderSide(
                                                    color: Colors
                                                        .black, // Color del borde
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                              inputFormatters: [
                                                CapitalizeFirstLetterTextFormatter()
                                              ],
                                              controller: fallaTypeController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Falla que presenta el equipo',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Radio del borde redondeado
                                                  borderSide: const BorderSide(
                                                    color: Colors
                                                        .black, // Color del borde
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                              controller: timeController,
                                              decoration: InputDecoration(
                                                labelText: 'Hora de la cita',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              readOnly: true,
                                              onTap: () async {
                                                final TimeOfDay? selectedTime = await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                  builder: (BuildContext context, Widget? child) {
                                                    return MediaQuery(
                                                      data: MediaQuery.of(context).copyWith(
                                                        alwaysUse24HourFormat: false,
                                                        accessibleNavigation: true,
                                                      ),
                                                      child: Builder(
                                                        builder: (context) {
                                                          return child!;
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );

                                                if (selectedTime != null) {
                                                  if (selectedTime.hour >= 7 && selectedTime.hour <= 19) {
                                                    timeController.text = selectedTime.format(context);
                                                  } else {
                                                    // Si la hora seleccionada está fuera del horario permitido,
                                                    // muestra un mensaje de error en el validador.
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('La hora seleccionada está fuera del horario permitido'),
                                                        backgroundColor: Colors.red,
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              validator: (value) {
                                                return null;
                                              },

                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: ElevatedButton(
                                              onPressed: _sumbitCite,
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.black,
                                                minimumSize: Size(150, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text('Agendar cita'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
            }
          }),
        ],
        Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ScaleTransition(
                      key: _imageKey[4][0],
                      scale: _animations[4],
                      child: SizedBox(
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
                    ),
                    SizedBox(
                      height: 700,
                      width: 470,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ScaleTransition(
                              key: _imageKey[4][1],
                              scale: _animations[4],
                              child: const Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: Text(
                                  '¿Tienes una duda específica? Contacta con nosotros',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ScaleTransition(
                                  key: _imageKey[5][0],
                                  scale: _animations[5],
                                  child: Row(
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
                                              padding: const EdgeInsets.only(
                                                  top: 10),
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
                                              padding: const EdgeInsets.only(
                                                  top: 10),
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
                                ),
                                ScaleTransition(
                                  key: _imageKey[5][1],
                                  scale: _animations[5],
                                  child: Padding(
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
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  'HORARIO DE ATENCIÓN',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
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
                                                padding: const EdgeInsets.only(
                                                    top: 5),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(Icons.camera_alt,
                                                            color:
                                                                Colors.white),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Text(
                                                            'mundocel.cl',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle:
                                                                  TextStyle(
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
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ]);
            } else {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Center(
                      child: ScaleTransition(
                    key: _imageKey[4][0],
                    scale: _animations[4],
                    child: SizedBox(
                      height: 280,
                      width: 280,
                      child: GoogleMap(
                        markers: _markers,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 15.0,
                        ),
                      ),
                    ),
                  )),
                ),
                SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScaleTransition(
                          key: _imageKey[4][1],
                          scale: _animations[4],
                          child: const Padding(
                            padding: EdgeInsets.all(50),
                            child: Text(
                              '¿Tienes una duda específica? Contacta con nosotros',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ScaleTransition(
                          key: _imageKey[5][0],
                          scale: _animations[5],
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'UBICACIÓN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Calle salinas 1385 Local 5',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        'San Felipe, Valparaíso, 2170000, Chile',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CONTACTO',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Móvil :  +56 967048828',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        'Email : Contact@mundocellcl.com',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ScaleTransition(
                          key: _imageKey[5][1],
                          scale: _animations[5],
                          child: const Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'HORARIO DE ATENCIÓN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          'Lun – Vier  09:00 – 19:00',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          'Sab – Dom 10:00 – 14:00',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Column(
                                    children: [
                                      Text(
                                        '¡SIGUENOS EN INSTAGRAM!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          'instagram ',
                                          style: TextStyle(color: Colors.white),
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
                    ),
                  ),
                )
              ]);
            }
          }),
        ),
      ],
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
