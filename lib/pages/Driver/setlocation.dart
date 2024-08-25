
import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({super.key});

  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {

  String userId = "";
  String latitude ="";
  String longitude="";

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  //Set<Polyline> _polylines = {};

 // LatLng? _destinationLocation;
  SharedPreferences? _prefs;
  LatLng _markerPosition = const LatLng(21.4858, 39.1925); // Initial marker position

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

   _updateProfile() async {
   if (_prefs == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFb2a676),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                Text(
                  ' Mark on Desire Location',
                  style: TextStyle(color: Color(0xFFE71F1F)),
                ),
              ],
            ),
          ),
        );
      return;
    } else if (_prefs != null) { 
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
      latitude= _markerPosition.latitude.toString() ;
      longitude= _markerPosition.longitude.toString();
      Services.updatedriverlocation(
        userId,
        latitude,
        longitude
      ).then((result) {
        if ('Success' == result) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 229, 220, 187),
              content: Row(
                children: [
                  Icon(Icons.save_alt_outlined, color: Color.fromARGB(255, 11, 156, 33)),
                  Text(
                    ' Success Save the Location on Mark',
                    style: TextStyle(color: Color.fromARGB(255, 11, 156, 33)),
                  ),
                ],
              ),
            ),
          );
        } else if ('Error' == result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFb2a676),
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                  Text(
                    ' Error Update Location try Again',
                    style: TextStyle(color: Color(0xFFE71F1F)),
                  ),
                ],
              ),
            ),
          );
        }
      });
  }
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
            initialCameraPosition: CameraPosition(
              target: _markerPosition,
              zoom: 12.0, // Set the initial zoom level
            ),
            markers: _markers,
         //   polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
              });
            },
            onTap: (LatLng position) {
              _addMarker( position) ;
             //_updateMarkerPosition(position);
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
                  saveLocations;
                  _updateProfile();
                //  Navigator.pushNamed(context, "/orderpage");
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
                label: const Text('Finish'),
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

    void _addMarker(LatLng Position) {
    setState(() {
      _markerPosition=Position;
      _markers.add(
        Marker(
          markerId: const MarkerId('Source'),
          position: _markerPosition,
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            _updateMarkerPosition(newPosition);
          },
          infoWindow: const InfoWindow(
                        title: 'Source',
                      ),
        ),
      );
    });
  }

  void _updateMarkerPosition(LatLng newPosition) {
    setState(() {
      _markerPosition = newPosition;
    });
  }


  void saveLocations() {
    if (_prefs != null) {
     _prefs!.setDouble('sourceLatitude', _markerPosition.latitude ?? 0) ;
     _prefs!.setDouble('sourceLongitude', _markerPosition.longitude ?? 0);

    }
  }
}