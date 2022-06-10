import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class ChargerDetailsView extends StatelessWidget {
  const ChargerDetailsView({Key? key}) : super(key: key);

  static const routeName = '/chargingpoints/details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Charger"), automaticallyImplyLeading: false),
        body: const Text('Hello'));
  }
}
