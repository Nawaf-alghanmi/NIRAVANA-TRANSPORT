import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nta_final/pages/model/server.dart';

class ViewOrderPage extends StatefulWidget {
  const ViewOrderPage({super.key});

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  SharedPreferences? _prefs;
  List orders = [];
  String userId = "";
  String orderId = "";
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

  Future<List> getcustomerOrders(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    orders = await Services.getcustomerOrders(userId,context);

    return orders;
  }

  Future<void> _showConfirmationDialog(int index) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Do you want to ${orders[index]['status']=='1' ? 'deactivate' : 'activate'} this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      setState(() {
        orders[index]['status'] = !orders[index]['status'];
      });
      _acceptOrder();
    }
  }

  _acceptOrder() async {
    Services.acceptOrder(orderId, status);
  }

  Future<void> _getOrder() async {
    List customerOrder = await getcustomerOrders(context);
    setState(() {
      orders = customerOrder;
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
            'View Orders',
            style: TextStyle(
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

              String imageUrl =
                  'https://ntafproject.000webhostapp.com/fnta_api/upload/furniture/${customerorder['picture']}';

              EdgeInsets itemPadding =
                  const EdgeInsets.all(8.0); // Adjust padding values
              BorderRadius borderRadius =
                  BorderRadius.circular(12.0); // Adjust border radius value

              return InkWell(
                onTap: () {
                  _showConfirmationDialog(index);
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
                              ),
                            ),
                            Text(
                              '${customerorder['fname']}',
                              style: const TextStyle(
                                color: Colors.blueAccent,
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
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0), // Add spacing between the name and the active icon
                      Icon(
                        Icons.check_circle,
                        color: status ? Colors.green : Colors.red,
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