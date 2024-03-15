import 'package:cidtmi/screens/desktop/services/treatments_struc/treatments/knee_treatment.dart';
import 'package:flutter/material.dart';

class TreatmentsDesktop extends StatefulWidget {
  const TreatmentsDesktop({super.key, required this.logInSelect});
  final Function() logInSelect;

  @override
  State<TreatmentsDesktop> createState() => _TreatmentsDesktopState();
}

class _TreatmentsDesktopState extends State<TreatmentsDesktop> {

  String selectedTreatmentsType = 'todos';



  @override
  Widget build(BuildContext context) {


    List<Map<String, List<Padding>>> TreatmentsType = [
      {
        "rodilla": [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 120,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 120,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 120,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 120,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ]
      },
      {
        "espalda": [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => KneeTreatments(logInSelect: widget.logInSelect),
                ),
                );
              },
              child: Container(
                height: 120,
                width: 600,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 120,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 120,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ]
      },
    ];

    List<Widget> treatmentsContainersType() {
      if (selectedTreatmentsType == 'todos') {
        return TreatmentsType.expand((map) => map.values.expand((e) => e).toList()).toList();
      } else {
        return TreatmentsType.where((map) => map.keys.contains(selectedTreatmentsType)).expand((map) => map.values.expand((e) => e).toList()).toList();
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: Text('Tipos de tratamientos',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 25,
                      runSpacing: 25,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedTreatmentsType ='espalda';
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black
                                    )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.network('assets/img/espalda.png'),
                                  )),
                              const Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Text('Espalda',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                              )
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedTreatmentsType = 'rodilla';
                        });
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Column(
                            children: [
                              Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.black
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.network('assets/img/rodilla.png'),
                                  )),
                              const Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Text('Rodilla',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),),
                              )
                            ],
                          )),
                    ),
                  ],
                            ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 25, top: 10),
                child: Text('Tratamientos',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...treatmentsContainersType(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

