import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/model/payment_process.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nta_final/pages/model/server.dart';

class DisplayOrder extends StatefulWidget {
  const DisplayOrder({super.key});

  @override
  State<DisplayOrder> createState() => _DisplayOrderState();
}

class _DisplayOrderState extends State<DisplayOrder> {

   SharedPreferences? _prefs;
  List orders = [];
  String userId = "";
  String orderId = "";
  String driverId = "";
  String driverImage= "";
  String driverRate= "";
  String driverEmail = "";
  int price=0;
  bool status = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _getOrder();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List> displayOrders(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    orders = await Services.displayOrders(userId,context);

    return orders;
  }

  Future<void> _getOrder() async {
    List customerOrder = await displayOrders(context);
    setState(() {
      orders = customerOrder;
    });
  }

Future<void> _saveOrderId(String orderId) async {
    await _prefs!.setString('selectedOrderId', orderId);
  }

  void _navigateTopaymentPage() {
    Navigator.pushNamed(context, "/pay");
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
               ),
          title: const Text('Display Accepted Orders',  style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 59, 59, 59),
            ),
          ),
         ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0), // Add padding between AppBar and ListView
          child: ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16.0), // Add space between items
            itemBuilder: (context, index) {
              Map<String, dynamic> customerorder = orders[index];
              orderId = customerorder['order_id'].toString();
              driverId = customerorder['driver_id'].toString();
              driverImage= 'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${customerorder['image']?? ''}';
              driverRate= customerorder['rating'];
              driverEmail = customerorder['email'].toString();
              String imageUrl =
                  'https://ntafproject.000webhostapp.com/fnta_api/upload/furniture/${customerorder['picture']?? ''}';

              EdgeInsets itemPadding =
                  const EdgeInsets.all(8.0); // Adjust padding values
              BorderRadius borderRadius =
                  BorderRadius.circular(12.0); // Adjust border radius value

              return InkWell(
                onTap: () {
                 
                 price=int.parse(customerorder['price'].toString()) ;
                 PaymentManager.makePayment(orderId,driverId,driverImage,driverRate,driverEmail,price, "SAR",context);
                 _saveOrderId(orderId);
                //   _navigateTopaymentPage();
                },
                child: Container(
                  padding: itemPadding,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(186, 234, 210, 210),
                    borderRadius: borderRadius,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrl,
                          scale: 1.0,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8.0), // Add spacing between the picture and the name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Furniture Name:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                            Text(
                              '${customerorder['fname']}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0), 
                            const Text(
                              'Price:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),// Add spacing between the name and the subtitle
                            Text(
                              '${customerorder['price']} SAR',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0), // Add spacing between the name and the active icon
                      Icon(
                        Icons.check_circle,
                        color: status ? Colors.green : Colors.green,
                      ),
                    ],
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