import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'charger_details.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'charger.dart';

class ChargerListPage extends StatelessWidget {
  const ChargerListPage({Key? key}) : super(key: key);

  Future<List<Charger>> getAssignedJobs(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    final logger = Logger();

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();

    // Using the position, fetch nearby chargers.
    //
    final client = HttpClient();

    var uri = Uri.parse(
        "https://evchargerqueue.eu.ngrok.io/api/v1/chargingpoints?latitude=0&longitude=0");

    var request = await client.postUrl(uri);
    request.headers.add('X-Requested-With', "XMLHttpRequest");
    request.headers.add(HttpHeaders.acceptHeader, "*/*");

    request.followRedirects = false;

    final List<Charger> jobList = [];

    try {
      var response = await request.close();

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        var json = jsonDecode(body);

        for (var i = 0; i < json.length; i++) {
          jobList.add(Charger.fromJson(json[i]));
        }
      }

      return jobList;
    } on HttpException catch (error) {
      logger.d(error.message);
      return jobList;
    } on SocketException catch (error) {
      logger.d(error.message);
      return jobList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Nearby Chargers"),
            automaticallyImplyLeading: false),
        body: FutureBuilder<List<Charger>>(
          future: getAssignedJobs(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator(
                  backgroundColor: Colors.blue);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return RefreshIndicator(
                  onRefresh: () => getAssignedJobs(context),
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(snapshot.data![index].id.toString()),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            onTap: () {
                              // Navigate to the details page. If the user leaves and returns to
                              // the app after it has been killed while running in the
                              // background, the navigation stack is restored.
                              Navigator.restorablePushNamed(
                                  context, ChargerDetailsView.routeName,
                                  arguments: {
                                    'chargerPointId': snapshot.data![index].id
                                  });
                            });
                      }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
