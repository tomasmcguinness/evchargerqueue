import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'charger.dart';

class ChargerListPage extends StatelessWidget {
  const ChargerListPage({Key? key}) : super(key: key);

  Future<List<Charger>> getAssignedJobs(BuildContext context) async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);

    // Using the position, fetch nearby chargers.
    //

    return [
      new Charger(id: "10", network: "Tesla"),
      new Charger(id: "11", network: "Gridserve"),
      new Charger(id: "12", network: "BpPulse")
    ];
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
              return const Center(
                child: Text('An error has occurred!'),
              );
            } else if (snapshot.hasData) {
              return RefreshIndicator(
                  onRefresh: () => getAssignedJobs(context),
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].network),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                        );
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
