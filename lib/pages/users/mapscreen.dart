import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(148, 150, 195, 178),
        elevation: 1,
        title: const Text('Add Location on Google Map ',
        style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 59, 59, 59)),
        
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(21.4858, 39.1925), // Set the initial map location
              zoom: 12.0, // Set the initial zoom level
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
              });
            },
            onTap: (LatLng latLng) {
              setState(() {
                if (_sourceLocation == null) {
                  _sourceLocation = latLng;
                  // Add marker for source location
                  _markers.add(
                    Marker(
                      markerId: const MarkerId('source'),
                      position: _sourceLocation!,
                      infoWindow: const InfoWindow(
                        title: 'Source',
                      ),
                    ),
                  );
                } else if (_destinationLocation == null) {
                  _destinationLocation = latLng;
                  // Add marker for destination location
                  _markers.add(
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: _destinationLocation!,
                      infoWindow: const InfoWindow(
                        title: 'Destination',
                      ),
                    ),
                  );
                  // Draw polyline between source and destination
                  _polylines.add(
                    Polyline(
                      polylineId: const PolylineId('route'),
                      color: Colors.blue,
                      width: 5,
                      points: [
                        _sourceLocation!,
                        _destinationLocation!,
                      ],
                    ),
                  );
                } else {
                  // Clear existing source and destination
                  _sourceLocation = null;
                  _destinationLocation = null;
                  // Clear markers and polylines
                  _markers.removeWhere((marker) =>
                      marker.markerId.value == 'source' ||
                      marker.markerId.value == 'destination');
                  _polylines.clear();
                }
              });
            },
          ),
           Positioned(
            bottom: 20,
            left: 5,
            right: 35,
            child: SizedBox(
                    width: 50, // Set the desired width
                    height: 50, 
            child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "/driverlistpage");
                },
                style: ButtonStyle(
                 
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 15, 32, 56),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                   
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ),
      ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveLocations,
        child: const Icon(Icons.save),
      ),
    
    );
  }

  void saveLocations() {
    if (_prefs != null) {
      _prefs!.setDouble('sourceLatitude', _sourceLocation?.latitude ?? 0);
      _prefs!.setDouble('sourceLongitude', _sourceLocation?.longitude ?? 0);
      _prefs!.setDouble(
          'destinationLatitude', _destinationLocation?.latitude ?? 0);
      _prefs!.setDouble(
          'destinationLongitude', _destinationLocation?.longitude ?? 0);
    }
  }
}