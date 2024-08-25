import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    List drivers = await Services
        .getDrivers(); // Replace with your method to get drivers from the database

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
    drivers
        .sort((a, b) => a['distanceToSource'].compareTo(b['distanceToSource']));

    return drivers;
  }

  Future<void> _getNearestDrivers() async {
    _prefs = await SharedPreferences.getInstance();
    double sourceLatitude = 0.0;
    double sourceLongitude = 0.0;
    setState(() {
      sourceLatitude = _prefs!.getDouble('sourceLatitude') ?? 0;
      sourceLongitude = _prefs!.getDouble('sourceLongitude') ?? 0;
    });

    List nearestDrivers = await getDriversByNearestLocation(
      sourceLatitude,
      sourceLongitude,
    );

    setState(() {
      _nearestDrivers = nearestDrivers;
    });
  }

  Future<void> _saveDriverId(String driverId) async {
    await _prefs!.setString('selectedDriverId', driverId);
  }

  void _navigateToOrderPage() {
    Navigator.pushNamed(context, "/furniturepage");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color(0xFFb2a676),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Nearest Drivers',
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 59, 59, 59)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB( 16.0, 8.0, 16.0, 0), // Add padding between AppBar and ListView
          child: ListView.separated(
            itemCount: _nearestDrivers.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 16.0), // Add space between items
            itemBuilder: (context, index) {
              Map<String, dynamic> driver = _nearestDrivers[index];
              String driverId = driver['driver_id'].toString();
    
              String imageUrl =
                  'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${driver['image']}';
    
              EdgeInsets itemPadding =
                  const EdgeInsets.all(8.0); // Adjust padding values
              BorderRadius borderRadius =
                  BorderRadius.circular(12.0); // Adjust border radius value
    
              return InkWell(
                onTap: () {
                  _saveDriverId(driverId);
                  _navigateToOrderPage();
                },
                child: Container(
                  padding: itemPadding,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(186, 234, 210, 210),
                    borderRadius: borderRadius,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text(driver['name']),
                    subtitle: RatingBarIndicator(
                    rating: double.parse(driver['rating']),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,

                  ),
                    
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
