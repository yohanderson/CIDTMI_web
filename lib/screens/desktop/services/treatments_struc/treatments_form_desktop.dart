import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../bloc/auth/provider_auth.dart';
import '../../../../bloc/dates_state_bloc.dart';

class TreatmentsFormDesktop extends StatefulWidget {
  const TreatmentsFormDesktop({super.key, required this.logInSelect});

  final Function() logInSelect;

  @override
  State<TreatmentsFormDesktop> createState() => _TreatmentsFormDesktopState();
}

class _TreatmentsFormDesktopState extends State<TreatmentsFormDesktop> {
  @override
  void initState() {
    super.initState();
    phoneNumberController.addListener(() {
      final text = phoneNumberController.text;
      if (text.isNotEmpty && int.tryParse(text) == null) {
        phoneNumberController.clear();
      }
    });
  }

  // calendar

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isDaySelected = false;

  // form

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final equipmentTypeController = TextEditingController();
  final fallaTypeController = TextEditingController();
  final timeController = TextEditingController();
  String countryCode = 'CL';
  String completePhoneNumber = '';

  final keyFormAppointments = GlobalKey<FormState>();

  // database

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

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  bool _isLoadingReserves = false;

  @override
  Widget build(BuildContext context) {
    ConnectionDatesBlocs connectionDatesBlocs =
        Provider.of<ConnectionDatesBlocs>(context);

    return Column(
      children: [
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
                        backgroundColor: Colors.red,
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
          SizedBox(
            height: 1000,
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
                                child: Form(
                                  key: keyFormAppointments,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color),
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
                                        padding: const EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
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
                                        padding: const EdgeInsets.only(top: 10),
                                        child: IntlPhoneField(
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
                                          controller: phoneNumberController,
                                          decoration: InputDecoration(
                                            labelText: 'Número de teléfono',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme.onSurface, // Color del borde
                                              ),
                                            ),
                                          ),
                                          initialCountryCode: 'CL',
                                          keyboardType: TextInputType.number,
                                          onChanged: (phone) {
                                            setState(() {
                                              countryCode = phone.countryCode;
                                              completePhoneNumber =
                                                  phone.completeNumber;
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
                                          inputFormatters: [
                                            CapitalizeFirstLetterTextFormatter()
                                          ],
                                          controller: equipmentTypeController,
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
                                        padding: const EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
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
                                        padding: const EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
                                          controller: timeController,
                                          decoration: InputDecoration(
                                            labelText: 'Hora de la cita',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                          readOnly: true,
                                          onTap: () async {
                                            final TimeOfDay? selectedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light().copyWith(
                                                    colorScheme: ColorScheme(
                                                      background: Colors.white,
                                                      brightness: Brightness.dark,
                                                      primary: Colors.white,
                                                      onPrimary: Colors.black,
                                                      secondary: Colors.grey,
                                                      onSecondary: Colors.white,
                                                      onError: Colors.blue,
                                                      onBackground: Colors.white,
                                                      onSurface: Colors.white,
                                                      surface: Colors.black.withOpacity(0.8),
                                                      error: Colors.red,
                                                    ),
                                                  ),
                                                  child: MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                      alwaysUse24HourFormat:
                                                          false,
                                                      accessibleNavigation: true,
                                                    ),
                                                    child: child!,
                                                  ),
                                                );
                                              },
                                            );

                                            if (selectedTime != null) {
                                              if (selectedTime.hour >= 7 &&
                                                  selectedTime.hour <= 19) {
                                                timeController.text =
                                                    selectedTime
                                                        .format(context);
                                              } else {
                                                // Si la hora seleccionada está fuera del horario permitido,
                                                // muestra un mensaje de error en el validador.
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'La hora seleccionada está fuera del horario permitido'),
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
                                          onPressed: _isLoadingReserves
                                              ? null
                                              : () async {
                                                  if (_isLoadingReserves ==
                                                      false) {
                                                    setState(() {
                                                      _isLoadingReserves = true;
                                                    });

                                                    if (Provider.of<AuthTokenProvider>(
                                                                context,
                                                                listen: false)
                                                            .isAuthenticated ==
                                                        true) {
                                                      if (connectionDatesBlocs
                                                                  .account
                                                                  .value[0][
                                                              'verify_email'] ==
                                                          true) {
                                                        final name =
                                                            nameController.text;
                                                        final lastName =
                                                            lastNameController
                                                                .text;
                                                        final phoneNumber =
                                                            completePhoneNumber;
                                                        final equipmentType =
                                                            equipmentTypeController
                                                                .text;
                                                        final fallaType =
                                                            fallaTypeController
                                                                .text;
                                                        final time =
                                                            timeController.text;
                                                        const state =
                                                            'Reserva agendada';

                                                        final parsedTime =
                                                            DateFormat(
                                                                    'hh:mm a')
                                                                .parse(time);
                                                        final formattedTime =
                                                            DateFormat(
                                                                    'HH:mm:ss')
                                                                .format(
                                                                    parsedTime);

                                                        final dateTime =
                                                            '${DateFormat('yyyy-MM-dd').format(_selectedDay!)} $formattedTime+00:00';

                                                        final now =
                                                            DateTime.now();
                                                        final formattedNow =
                                                            '${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}+00:00';

                                                        const String
                                                            connection =
                                                            'http:$ipPort';

                                                        String route =
                                                            '/created_reserves';

                                                        var url = Uri.parse(
                                                            '$connection$route');

                                                        // Obtener el token de las cookies del navegador
                                                        String? token = html
                                                            .document.cookie
                                                            ?.split('; ')
                                                            .firstWhere(
                                                                (cookie) => cookie
                                                                    .startsWith(
                                                                        'auth_token='),
                                                                orElse: () =>
                                                                    '')
                                                            .split('=')
                                                            .last;

                                                        var headers = {
                                                          'Content-Type':
                                                              'application/json; charset=UTF-8',
                                                          'Authorization':
                                                              'Bearer $token',
                                                        };

                                                        var body = jsonEncode({
                                                          'user_id':
                                                              connectionDatesBlocs
                                                                      .account
                                                                      .value[0]
                                                                  ['user_id'],
                                                          'name': name,
                                                          'last_name': lastName,
                                                          'phone_number':
                                                              phoneNumber,
                                                          'equipment_type':
                                                              equipmentType,
                                                          'date_time': dateTime,
                                                          'created_at':
                                                              formattedNow,
                                                          'falla_type':
                                                              fallaType,
                                                          'state': state,
                                                        });

                                                        bool isValid =
                                                            keyFormAppointments
                                                                .currentState!
                                                                .validate();

                                                        if (isValid) {
                                                          var response =
                                                              await http.post(
                                                                  url,
                                                                  headers:
                                                                      headers,
                                                                  body: body);

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            nameController
                                                                .clear();
                                                            lastNameController
                                                                .clear();
                                                            phoneNumberController
                                                                .clear();
                                                            equipmentTypeController
                                                                .clear();
                                                            fallaTypeController
                                                                .clear();
                                                            timeController
                                                                .clear();

                                                            setState(() {
                                                              _isLoadingReserves =
                                                                  false;
                                                            });

                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  title:
                                                                      const Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            300,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text('Reserva creada con exito'),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 5),
                                                                              child: Icon(
                                                                                Icons.verified,
                                                                                color: Colors.green,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Cerrar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyLarge?.color),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          } else if (response
                                                                  .statusCode ==
                                                              500) {
                                                            setState(() {
                                                              _isLoadingReserves =
                                                                  false;
                                                            });

                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  title: Center(
                                                                      child:
                                                                          Column(
                                                                    children: [
                                                                      Text(response
                                                                          .body),
                                                                    ],
                                                                  )),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        foregroundColor:
                                                                            Colors.blue,
                                                                        backgroundColor:
                                                                            Colors.blue[100],
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Cerrar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _isLoadingReserves =
                                                                false;
                                                          });

                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                title: const Center(
                                                                    child: Text(
                                                                        'Error')),
                                                                content: const Text(
                                                                    'Uno o más campos no son válidos.'),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .blue,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blue[100],
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: const Text(
                                                                        'Cerrar'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      } else {
                                                        setState(() {
                                                          _isLoadingReserves =
                                                              false;
                                                        });
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              title:
                                                                  const Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                300,
                                                                            child:
                                                                                Text('Debes de verificar tu correo para realizar reservas')),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 5),
                                                                          child:
                                                                              Icon(
                                                                            Icons.verified,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                ElevatedButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    'Cerrar',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge
                                                                            ?.color),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      setState(() {
                                                        _isLoadingReserves =
                                                            false;
                                                      });

                                                      widget.logInSelect();
                                                    }
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.black,
                                            minimumSize: Size(150, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: _isLoadingReserves
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 35,
                                                      vertical: 8),
                                                  child: SizedBox(
                                                      height: 23,
                                                      width: 23,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      )),
                                                )
                                              : const Text('Agendar cita'),
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
          ),
        ],
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
