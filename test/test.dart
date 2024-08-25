import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;
  SharedPreferences? _prefs;
  final PolylinePoints _polylinePoints = PolylinePoints();
  final List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    _drawRoute();
    _updateMarkers();
  }

  Future<void> initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Retrieve saved source and destination locations
    double? sourceLat = _prefs!.getDouble('sourceLat');
    double? sourceLng = _prefs!.getDouble('sourceLng');
    double? destLat = _prefs!.getDouble('destLat');
    double? destLng = _prefs!.getDouble('destLng');

    if (sourceLat != null && sourceLng != null) {
      _sourceLocation = LatLng(sourceLat, sourceLng);
    }

    if (destLat != null && destLng != null) {
      _destinationLocation = LatLng(destLat, destLng);
    }
  }

  Future<void> _drawRoute() async {
    if (_sourceLocation != null && _destinationLocation != null) {
      String apiKey = 'AIzaSyBiXMvYK0d_1jFfA9nEmqJLT96b1-WUwuo';

      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_sourceLocation!.latitude},${_sourceLocation!.longitude}&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}&key=$apiKey';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<PointLatLng> polylinePoints =
            _polylinePoints.decodePolyline(data['routes'][0]['overview_polyline']['points']);
        _polylineCoordinates.clear();
        for (var point in polylinePoints) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        setState(() {
          PolylineId polylineId = const PolylineId('route');
          Polyline polyline = Polyline(
            polylineId: polylineId,
            color: Colors.blue,
            width: 5,
            points: _polylineCoordinates,
          );
          _polylines[polylineId] = polyline;
        });
      }
    }
  }

  Future<void> _getAddress(LatLng location, Function(String) callback) async {
    String apiKey = 'AIzaSyBiXMvYK0d_1jFfA9nEmqJLT96b1-WUwuo';

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].length > 0) {
        String address = data['results'][0]['formatted_address'];
        callback(address);
      }
    }
  }

  void _updateMarkers() async {
    _markers.clear();

    if (_sourceLocation != null) {
      await _getAddress(_sourceLocation!, (address) {
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('source'),
              position: _sourceLocation!,
              infoWindow: InfoWindow(
                title: 'Source',
                snippet: address,
              ),
            ),
          );
        });
      });

      // Save the source location using SharedPreferences
      await _prefs!.setDouble('sourceLat', _sourceLocation!.latitude);
      await _prefs!.setDouble('sourceLng', _sourceLocation!.longitude);
    }

    if (_destinationLocation != null) {
      await _getAddress(_destinationLocation!, (address) {
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: _destinationLocation!,
              infoWindow: InfoWindow(
                title: 'Destination',
                snippet: address,
              ),
            ),
          );
        });
      });

      // Save the destination location using SharedPreferences
      await _prefs!.setDouble('destLat', _destinationLocation!.latitude);
      await _prefs!.setDouble('destLng', _destinationLocation!.longitude);
    }
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
        backgroundColor: const Color(0xFFb2a676),
        elevation: 0,
        title: const Text('Google Map Page'),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.person,
                color: Color.fromARGB(255, 176, 162, 39),
              ),
            ),
            onPressed: () {
              // Add your desired functionality here
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _sourceLocation != null
            ? CameraPosition(
                target: _sourceLocation!,
                zoom: 14.0,
              )
            : const CameraPosition(
                target: LatLng(21.4858, 39.1925),
              ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: _markers,
        polylines: Set<Polyline>.of(_polylines.values),
      ),
    );
  }
}