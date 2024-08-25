import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewDriverPage extends StatefulWidget {
  const ViewDriverPage({super.key});

  @override
  State<ViewDriverPage> createState() => _ViewDriverPageState();
}

class _ViewDriverPageState extends State<ViewDriverPage> {
  SharedPreferences? _prefs;
  List drivers = [];
  String userId = "";
  String driverId = "";
  String selectedDriverId = ""; // Track the selected driver's ID
  bool status = false;
  int? selectedTileIndex;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _getalldriver();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List> getalldriver() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    drivers = await Services.getAllDrivers();
    return drivers;
  }

  Future<void> _showConfirmationDialog(int index) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
          'Do you want to ${drivers[index]['status'] == '1' ? 'deactivate' : 'activate'} this Driver?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                status = !status;
                selectedDriverId = drivers[index]['driver_id'].toString();
              });
              Navigator.of(context).pop(true);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      _activedriver();
    }
  }

  Future<void> _activedriver() async {
    await Services.activedriver(selectedDriverId, status);
    _getalldriver();
  }

  Future<void> _getalldriver() async {
    List driver = await getalldriver();
    setState(() {
      drivers = driver;
    });
  }

  @override
  Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(148, 150, 195, 178),
        elevation: 1,
        title: const Text(
          'View Drivers',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 59, 59, 59),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          0,
        ), // Add padding between AppBar and ListView
        child: SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: drivers.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 16.0), // Add space between items
            itemBuilder: (context, index) {
              Map<String, dynamic> vdrivers = drivers[index];
              driverId = vdrivers['driver_id'].toString();

              String imageUrl =
                  'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${vdrivers['image']}';

              EdgeInsets itemPadding =
                  const EdgeInsets.all(8.0); // Adjust padding values
              BorderRadius borderRadius =
                  BorderRadius.circular(12.0); // Adjust border radius value

              return ListTile(
                onTap: () {
                  setState(() {
                    selectedTileIndex = index;
                  });
                  _showConfirmationDialog(index);
                },
                title: Container(
                  padding: itemPadding,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(186, 234, 210, 210),
                    borderRadius: borderRadius,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                          width:
                              8.0), // Add spacing between the picture and the name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Driver Name:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${vdrivers['name']}',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            const Text(
                              'Email:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${vdrivers['email']}',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RatingBar.builder(
                              initialRating: double.parse(vdrivers['rating']),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20.0,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          width:
                              8.0), // Add spacing between the name and the active icon
                      Icon(
                        Icons.check_circle,
                        color: vdrivers['status'] == '1'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
}
