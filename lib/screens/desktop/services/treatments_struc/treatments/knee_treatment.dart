import 'package:flutter/material.dart';

import '../treatments_form_desktop.dart';

class KneeTreatments extends StatefulWidget {
  const KneeTreatments({super.key, required this.logInSelect});
  final Function() logInSelect;

  @override
  State<KneeTreatments> createState() => _KneeTreatmentsState();
}

class _KneeTreatmentsState extends State<KneeTreatments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: 800,
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
            TreatmentsFormDesktop(logInSelect: widget.logInSelect,),
          ],
        ),
      ),
    );
  }
}
