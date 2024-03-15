import 'package:cidtmi/trips.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc/auth/provider_auth.dart';
import 'bloc/cart_model.dart';
import 'bloc/dates_state_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDBWA7Z4zhEPiUtIuYEI9A-7bBbOsUEiM8",
        authDomain: "citdmi.firebaseapp.com",
        projectId: "citdmi",
        storageBucket: "citdmi.appspot.com",
        messagingSenderId: "344573584875",
        appId: "1:344573584875:web:1f2f73ca3bbf045c5a25ae",
        measurementId: "G-KPG92HTDT9",
  ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectionDatesBlocs(),
        ),
        ChangeNotifierProvider<AuthTokenProvider>(
          create: (context) => AuthTokenProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {

  final ValueNotifier<bool> darkMode = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: ValueListenableBuilder<bool>(
          valueListenable: darkMode,
          builder: (context, value, child) {
            var darkModeTheme = value;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: darkModeTheme == false ?
            ThemeData(
              primaryColor:  const Color(0xFF463d90),
              hintColor:  Colors.cyan,
              secondaryHeaderColor: const Color(0xFF031542),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.black,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey;
                      }
                      return Colors.black;
                    },
                  ),
                ),
              ),
              sliderTheme: const SliderThemeData(
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              colorScheme: const ColorScheme(
                background: Colors.white,
                brightness: Brightness.dark,
                primary: Color(0xFF211d44),
                onPrimary: Color(0xFF463d90),
                secondary: Color(0xFFca4cfd),
                onSecondary: Colors.purple,
                onError: Colors.blue,
                onBackground: Color(0xFF8e5cff),
                onSurface: Colors.black,
                surface: Colors.black,
                error: Colors.red,
              ),
              iconTheme: const IconThemeData(
                  color: Colors.black
              ),
              inputDecorationTheme: const InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              checkboxTheme: CheckboxThemeData(
                checkColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return null;            }),

                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.black;
                  }
                  return null;
                }),
              ),
              textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
              foregroundColor: Colors.black,
                backgroundColor: Colors.transparent,
              ),),
            ) : ThemeData(
              primaryColor:  const Color(0xFF463d90),
              hintColor:  Colors.white,
              secondaryHeaderColor: const Color(0xFF031542),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFF031542)),
                bodyMedium: TextStyle(color: Color(0xFF8e5cff),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return const Color(0xFF8e5cff);
                      }
                      return const Color(0xFF031542);
                    },
                  ),
                ),
              ),
              sliderTheme: const SliderThemeData(
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              colorScheme: const ColorScheme(
                background: Colors.white,
                brightness: Brightness.dark,
                primary: Colors.blue,
                onPrimary: Color(0xFF463d90),
                secondary: Color(0xFFca4cfd),
                onSecondary: Colors.purple,
                onError: Colors.blue,
                onBackground: Color(0xFF8e5cff),
                onSurface: Colors.black,
                surface: Color(0xFF031542),
                error: Colors.red,
              ),
              iconTheme: const IconThemeData(
                  color: Color(0xFF8e5cff)
              ),
            ),
            home: Trips(darkMode: darkMode,),
          );
        }
      ),
    );
  }

}
