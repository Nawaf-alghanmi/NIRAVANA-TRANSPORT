import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/server.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
    TextEditingController dateInput = TextEditingController();
    String userId='';
    String furnitureId='';
    String selectedDriverId='';
    String sourceLatitude='';
    String sourceLongitude='';
    String destinationLatitude='';
    String destinationLongitude='';
    
 @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

   _clearTextInput() {
    dateInput.text = '';
  }

  _addorder() async {
    if (dateInput.text.isEmpty ) {
      if (kDebugMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFb2a676),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                Text(
                  ' Empty Field  ',
                  style: TextStyle(color: Color(0xFFE71F1F)),
                ),
              ],
            ),
          ),
        );
      }
      return;
    } else {

//==========

//============
try{

      final prefs = await SharedPreferences.getInstance();
       setState(() {
      sourceLatitude = (prefs.getDouble('sourceLatitude') ?? 0).toString();
      sourceLongitude = (prefs.getDouble('sourceLongitude') ?? 0).toString();
      destinationLatitude = (prefs.getDouble('destinationLatitude') ?? 0).toString();
      destinationLongitude = (prefs.getDouble('destinationLongitude') ?? 0).toString();
      selectedDriverId = (prefs.getString('selectedDriverId') ?? '').toString();
      furnitureId = prefs.getString('furnitureId') ?? ''; 
      userId = prefs.getString('userId') ?? '';
    });
      
     Services.addorder(
        userId,
        furnitureId,
        selectedDriverId,
        dateInput.text,
        sourceLatitude,
        sourceLongitude,
        destinationLatitude,
        destinationLongitude,
      ).then((result) {
        if ('Success' == result) {
          _clearTextInput();
          Navigator.pushNamed(context, "/userpage");
        } else if ('Error' == result) {
          _clearTextInput();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFb2a676),
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                  Text(
                    ' Error inserting try Again',
                    style: TextStyle(color: Color(0xFFE71F1F)),
                  ),
                ],
              ),
            ),
          );
        }
      });
      } on SocketException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFb2a676),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                Text(
                  ' no internet ',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }
    }
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
        title: const Text('Order Page ',
        style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 59, 59, 59)), 
        ),
      ),
      body: SizedBox(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 27,
                      ),
                      const Text(
                        "Enter the Delivery Date ",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "myfont",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(
                        height: 37,
                      ),
                      Container(
                         padding: const EdgeInsets.all(15),
                       //  height: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 231, 227, 190),
                          borderRadius: BorderRadius.circular(66),
                        ),
                        width: double.infinity,
                        child: TextField(
                          controller: dateInput,
                          decoration: const InputDecoration(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Color.fromARGB(255, 195, 171, 35),
                              ),
                              hintText: "Enter The Date",
                              border: InputBorder.none),
                              readOnly: true,
                              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    //DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    dateInput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
                        ),
                      ),
                      
                     
                      const SizedBox(
                        height: 27,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                           _addorder();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 176, 162, 39)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 103, vertical: 12)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(27))),
                            ),
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}