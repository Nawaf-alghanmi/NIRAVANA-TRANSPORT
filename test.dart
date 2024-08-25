import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nta_final/pages/model/server.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  SharedPreferences? _prefs;
  List _nearestDrivers = [];

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _getNearestDrivers();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List> getDriversByNearestLocation(
  double sourceLatitude,
  double sourceLongitude,
) async {
  // Calculate the distance between source location and driver locations using the Haversine formula
  List drivers = await Services.getDrivers(); // Replace with your method to get drivers from the database

  for (var driver in drivers) {
    double driverLatitude = double.parse(driver['latitude']);
    double driverLongitude = double.parse(driver['longitude']);

    double distanceToSource = Geolocator.distanceBetween(
      sourceLatitude,
      sourceLongitude,
      driverLatitude,
      driverLongitude,
    );

    driver['distanceToSource'] = distanceToSource;
  }

  // Sort drivers by distance to source in ascending order
  drivers.sort((a, b) => a['distanceToSource'].compareTo(b['distanceToSource']));

  return drivers;
}

  Future<void> _getNearestDrivers() async {
    double sourceLatitude = _prefs!.getDouble('sourceLatitude') ?? 0;
    double sourceLongitude = _prefs!.getDouble('sourceLongitude') ?? 0;

    List nearestDrivers = await getDriversByNearestLocation(
      sourceLatitude,
      sourceLongitude,
    );

    setState(() {
      _nearestDrivers = nearestDrivers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearest Drivers'),
      ),
      body: ListView.builder(
        itemCount: _nearestDrivers.length,
        itemBuilder: (context, index) {
         List driver = _nearestDrivers[index];
          return ListTile(
            title: Text("${driver[index]['name']}"),
            subtitle: Text('Rating: ${driver[index]['rating']}'),
          );
        },
      ),
    );
  }
}