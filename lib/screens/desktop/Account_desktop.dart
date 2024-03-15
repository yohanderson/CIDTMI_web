import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/dates_state_bloc.dart';

class AccountDesktop extends StatefulWidget {
  const AccountDesktop({super.key});

  @override
  State<AccountDesktop> createState() => _AccountDesktopState();
}

class _AccountDesktopState extends State<AccountDesktop> {


  List<Map<String, dynamic>> content = [
    {'user_id': 34, 'name': 'Yohanderson', 'surname': 'Marquez', 'verify_email': null, 'email': 'yohandersonmaruqez@outlook.es'}
  ];


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: Provider.of<ConnectionDatesBlocs>(context).account,
      builder: (context, value, child) {
          
          final account = value;
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              children: [
                Container(
                  width: constraints.maxWidth / 3,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                    ),
                    color: Theme.of(context).colorScheme.onSurface
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.grey),
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.background,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(-5, -5),
                                    blurRadius: 5,
                                    color: const Color(0xFF211d44).withOpacity(0.5),
                                    inset: true,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text('${account[0]['name'][0]}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('${account[0]['name']} ${account[0]['surname']}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w900,
                              fontSize: 30
                            ),),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Correo electronico: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                    color: Theme.of(context).textTheme.bodyLarge?.color
                                )
                              ),
                              TextSpan(
                                text: '${account[0]['email']}', // La variable email que deseas resaltar
                                style: const TextStyle(
                                  color: Colors.blue,
                                    fontSize: 18
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      account[0]['verify_email'] == false ?  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Correo Verificado',
                  style: TextStyle(
                    fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color
                  ),),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(Icons.verified_user, color: Colors.green,),
                  )
                ],
              ) :
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: Container(
                    width: constraints.maxWidth / 3 - 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(-5, -5),
                          blurRadius: 40,
                          color: const Color(0xFF211d44).withOpacity(0.4),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: const Offset(3, 3),
                          blurRadius: 10,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text('Este correo aun no a sido verificado',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                fontSize: 25
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15, top: 5),
                            child: Text('Por favor verifica tu correo electronico'),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Text('Si no ves el correo de verificacion o el tiempo ya expido puedes volver a enviar el correo de verificación',
                            textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(onPressed: () async {
                              final Uri params = Uri(
                                scheme: 'mailto',
                                path: '',
                              );

                              String url = params.toString();
                              if (await canLaunch(url)) {
                              await launch(url);
                              } else {
                              throw 'No se pudo abrir el correo electrónico';
                              }
                            },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green.shade700,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                                child: Text(
                                  'verificar correo',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),),
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
                SizedBox(
                  width: constraints.maxWidth / 1.5,
                  height: MediaQuery.of(context).size.height,
                  child: Row(
                    children: [
                      Expanded(child:
                      Padding(
                        padding: const EdgeInsets.all(35),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(-5, -5),
                                blurRadius: 5,
                                color: const Color(0xFF211d44).withOpacity(0.4),
                                inset: true,
                              ),
                              BoxShadow(
                                offset: const Offset(5, 5),
                                blurRadius: 10,
                                color: const Color(0xFF211d44).withOpacity(0.4),
                              ),
                            ],
                          ),
                          child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                              valueListenable: Provider.of<ConnectionDatesBlocs>(context).reserves,
                              builder: (context, value, child) {

                                final orders = value;
                             if( value.isEmpty) {
                               return  const Center(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Padding(
                                       padding: EdgeInsets.only(top: 20),
                                       child: Text('Reservas',
                                         style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 30,
                                         ),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.only(bottom: 50),
                                       child: Text('Aun no tines reservas',
                                         style: TextStyle(
                                             fontSize: 25,
                                             fontWeight: FontWeight.w500
                                         ),),
                                     ),
                                     SizedBox(),
                                   ],
                                 ),
                               );
                             } else {
                               return  ListView.builder(
                                   itemCount: orders.length,
                                   itemBuilder: (context, index) {
                                     final order = orders[index];
                                   return Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                     child: Container(
                                       decoration: BoxDecoration(
                                         color: Theme.of(context).colorScheme.background,
                                         borderRadius: BorderRadius.circular(10),
                                         boxShadow: [
                                           BoxShadow(
                                             offset: const Offset(-2, -2),
                                             blurRadius: 5,
                                             color: const Color(0xFF211d44).withOpacity(0.4),
                                             inset: true,
                                           ),
                                           BoxShadow(
                                             offset: const Offset(3, 3),
                                             blurRadius: 10,
                                             color: const Color(0xFF211d44).withOpacity(0.4),
                                           ),
                                         ],
                                       ),
                                       child: Padding(
                                         padding: const EdgeInsets.all(10),
                                         child: Column(
                                           children: [
                                             const Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 Padding(
                                                   padding: EdgeInsets.only(left: 8),
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                       Text(''),
                                                       Text(''),
                                                       Text(''),
                                                     ],
                                                   ),
                                                 ),
                                                 Padding(
                                                   padding: EdgeInsets.only(right: 8),
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.end,
                                                     children: [
                                                       Text(''),
                                                       Text(''),
                                                       Text(''),
                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),
                                             Align(
                                               alignment: Alignment.centerRight,
                                               child: Padding(
                                                 padding: const EdgeInsets.only(right: 10),
                                                 child: InkWell(
                                                   onTap: () {},
                                                   child: Container(
                                                     decoration: BoxDecoration(
                                                       border: Border.all(
                                                         width: 1, color: Colors.red,
                                                       ),
                                                       borderRadius: BorderRadius.circular(5),
                                                     ),
                                                     child: const Center(child: Text('Cancelar')),
                                                   ),
                                                 ),
                                               ),
                                             )
                                           ],
                                         ),
                                       ),
                                     ),
                                   );
                                 }
                               );
                             }
                            }
                          ),
                        ),
                      )), //reserves
                      Expanded(child:
                      Padding(
                        padding: const EdgeInsets.all(35),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(-5, -5),
                                blurRadius: 5,
                                color: const Color(0xFF211d44).withOpacity(0.4),
                                inset: true,
                              ),
                              BoxShadow(
                                offset: const Offset(5, 5),
                                blurRadius: 10,
                                color: const Color(0xFF211d44).withOpacity(0.4),
                              ),
                            ],
                          ),
                          child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                              valueListenable: Provider.of<ConnectionDatesBlocs>(context).orders,
                              builder: (context, value, child) {

                                final orders = value;
                             if( value.isEmpty) {
                               return const Center(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Padding(
                                       padding: EdgeInsets.only(top: 20),
                                       child: Text('Ordenes',
                                       style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         fontSize: 30,
                                       ),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.only(bottom: 50),
                                       child: Text('Aun no tines ordenes',
                                       style: TextStyle(
                                         fontSize: 25,
                                         fontWeight: FontWeight.w500
                                       ),),
                                     ),
                                     SizedBox(),
                                   ],
                                 ),
                               );
                             } else {
                               return  ListView.builder(
                                   itemCount: orders.length,
                                   itemBuilder: (context, index) {
                                     final order = orders[index];
                                   return Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                     child: Container(
                                       decoration: BoxDecoration(
                                         color: Theme.of(context).colorScheme.background,
                                         borderRadius: BorderRadius.circular(10),
                                         boxShadow: [
                                           BoxShadow(
                                             offset: const Offset(-2, -2),
                                             blurRadius: 5,
                                             color: const Color(0xFF211d44).withOpacity(0.4),
                                             inset: true,
                                           ),
                                           BoxShadow(
                                             offset: const Offset(3, 3),
                                             blurRadius: 10,
                                             color: const Color(0xFF211d44).withOpacity(0.4),
                                           ),
                                         ],
                                       ),
                                       child: const Padding(
                                         padding: EdgeInsets.all(10),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Padding(
                                               padding: EdgeInsets.only(left: 8),
                                               child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Text(''),
                                                   Text(''),
                                                   Text(''),
                                                 ],
                                               ),
                                             ),
                                             Padding(
                                               padding: EdgeInsets.only(right: 8),
                                               child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.end,
                                                 children: [
                                                   Text(''),
                                                   Text(''),
                                                   Text(''),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ),
                                   );
                                 }
                               );
                             }
                            }
                          ),
                        ),
                      )), //orders
                    ],
                  ),
                ),
              ],
            );
          }
        );
      }
    );
  }
}