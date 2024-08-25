import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'userdata.dart';

class Services {
  static var url =
      Uri.parse('https://ntafproject.000webhostapp.com/fnta_api/api.php');

  static const _Login = 'Login';
  static const _Register = 'Register';
  static const _Update_Profile = 'Update_Profile';
  static const _Update_Driver_Location = 'Update_Driver_Location';
  static const _Add_Furniture = 'Add_Furniture';
  static const _Add_Order = 'Add_Order';
  static const _GET_Driver = 'GET_Driver';
  static const _DriverGET_CustomerOrder = 'DriverGET_CustomerOrder';
  static const _Accept_Order = 'Accept_Order';
  static const _Active_Driver = 'Active_Driver';
  static const _GET_AllDriver = 'GET_AllDriver';
  static const _GET_CustomerOrder = 'GET_CustomerOrder';
  static const _View_Date_Profile = 'View_Date_Profile';
  static const _Update_Payment_Order = 'Update_Payment_Order';
  static const _Update_Rating = 'Update_Rating';
  static const _View_Total_Price='View_Total_Price';
  

  static void logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear the stored user data
    await prefs.remove('userId');
    await prefs.remove('userType');
    await prefs.remove('userEmail');
  }

  //Method to
  static Future<String> register(
      String Email, String Password, String Type) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _Register;
      map['email'] = Email;
      map['password'] = Password;
      map['type'] = Type;

      final response = await http.post(url, body: map);
      //var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('Register Response: ${response.body}');
      }
      if (200 == response.statusCode) {
        return jsonDecode(response.body);
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  //Method to login
  static Future<Map<String, dynamic>> login(
      String Email, String Password) async {
    var map = <String, dynamic>{};
    map['action'] = _Login;
    map['email'] = Email;
    map['password'] = Password;
    try {
      final response = await http.post(url, body: map);
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('Login Response: ${response.body}');
      }
      if (200 == response.statusCode) {
        if (data['status'] == 'success') {
          return jsonDecode(response.body);
          //    return {'userId': data['userId'], 'userType': data['userType']};
        } else {
          if (kDebugMode) {
            print("Login failed: ${data["message"]}");
          }
          return jsonDecode(response.body);
        }
      } else {
        throw "No Internet Connection";
      }
    } catch (e) {
      throw "No Internet Connection";
      // handle no internet error
    }
  }

  static List<Userdata> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Userdata>((json) => Userdata.fromJson(json)).toList();
  }

  //Method to update Profile
  static Future<String> updateProfile(
    String userId,
    String name,
    String password,
    String phone,
    File image,
    String type,
  ) async {
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['action'] = _Update_Profile;
      request.fields['id'] = userId;
      request.fields['name'] = name;
      request.fields['password'] = password;
      request.fields['phone'] = phone;
      request.fields['type'] = type;
      var pic = await http.MultipartFile.fromPath("image", image.path);
      request.files.add(pic);
      var response = await request.send();

      // if (kDebugMode) {
      //    print("Update Profile Response: Error");
      //   }
      if (200 == response.statusCode) {
        return 'Success';
      } else {
        return 'Error';
      }
    } catch (e) {
      return "Error";
    }
  }

  //Method to update Driver Location Profile
  static Future<String> updatedriverlocation(
    String userId,
    String latitude,
    String longitude,
  ) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _Update_Driver_Location;
      map['id'] = userId;
      map['latitude'] = latitude;
      map['longitude'] = longitude;

      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print("Update Driver Location Response: ${response.body}");
      }
      if (200 == response.statusCode) {
        return jsonDecode(response.body);
      } else {
        return 'error';
      }
    } catch (e) {
      return "error";
    }
  }

//======================
//Method to Get deivers

  static Future<List> getDrivers() async {
    var map = <String, dynamic>{};
    map['action'] = _GET_Driver;

    try {
      final response = await http.post(url, body: map);
      var data = jsonDecode(response.body);
      List list = [];
      if (kDebugMode) {
        print('GET_Driver Response: ${response.body}');
      }

      if (200 == response.statusCode) {
        list.addAll(data);
        return list;
        //    return {'userId': data['userId'], 'userType': data['userType']};
      } else {
        return throw "No Internet Connection";
      }
    } catch (e) {
      throw "No Internet Connection";
      // handle no internet error
    }
  }

//========================
  //Method to Add Furniture
  static Future<String> addfurniture(
    String name,
    String description,
    String quantity,
    String price,
    File image,
    String customerId,
  ) async {
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['action'] = _Add_Furniture;
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['quantity'] = quantity;
      request.fields['price'] = price;
      request.fields['customer_id'] = customerId;
      var pic = await http.MultipartFile.fromPath("image", image.path);
      request.files.add(pic);
     // var response = await request.send();
      // if (kDebugMode) {
      //    print("Update Profile Response: Error");
      //   }
     http.StreamedResponse response = await request.send(); 
      if (200 == response.statusCode) {
        var responseBytes = await response.stream.toBytes();
        var responseString = utf8.decode(responseBytes);
        var parsedResponse = jsonDecode(responseString);
        

        if (parsedResponse != '0') {
        //   String furnitureId =int.parse(parsedResponse).toString();
        var furnitureId = parsedResponse['furniture_id'];
          return furnitureId;
        } else {
          return 'error';
        }
      } else {
        return 'error';
      }
    } catch (e) {
      return "error";
    }
  }
//=================================
  //Method to Add Order
  static Future<String> addorder(
    String customerId,
    String furnitureId,
    String driverId,
    String deliveryDate,
    String sourceLatitude,
    String sourceLongitude,
    String destinationLatitude,
    String destinationLongitude,
  ) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _Add_Order;
      map['customer_id'] = customerId;
      map['furniture_id'] = furnitureId;
      map['driver_id'] = driverId;
      map['delivery_date'] = deliveryDate;
      map['source_latitude'] = sourceLatitude;
      map['source_longitude'] = sourceLongitude;
      map['destination_latitude'] = destinationLatitude;
      map['destination_longitude'] = destinationLongitude;

      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print("Add Order Response: ${response.body}");
      }
      if (200 == response.statusCode) {
        return jsonDecode(response.body);
      } else {
        return 'Error';
      }
    } catch (e) {
      return "Error";
    }
  }

//====================================
// Method to Get orders
static Future<List> getcustomerOrders(String driverId, BuildContext context) async {
  var map = <String, dynamic>{};
  map['id'] = driverId;
  map['action'] = _DriverGET_CustomerOrder;
  try {
    final response = await http.post(url, body: map);

    if (kDebugMode) {
      print('GET_Driver Response: ${response.body}');
    }

    if (response.statusCode == 200) {
      if (response.body == 'NoOrder') {
       // Display a SnackBar with "No Orders" message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No Orders"),
          ),
        );
        // Return an empty list to indicate no orders
        return [];
      } else {
        // Orders are available, decode the response body
        var data = jsonDecode(response.body);
        // Create a list and add the data to it
        List list = List.from(data);
        return list;
      }
    } else {
      // Throw an exception for non-200 status code (e.g., no internet connection)
      throw Exception("No Internet Connection");
    }
  } catch (e) {
    String errorMessage;
    if (e is Exception) {
      errorMessage = e.toString();
    } else {
      errorMessage = "Unknown error occurred.";
    }
    
    // Display a SnackBar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
    // Rethrow the exception to propagate it further if needed
    rethrow;
  }
}
//====================
//Method to Get user data

  static Future<List> viewdataprofile(
     String userId,
     String type,
  ) async {
    var map = <String, dynamic>{};
     map['id'] = userId;
     map['type'] = type;
     map['action'] = _View_Date_Profile;

    try {
      final response = await http.post(url, body: map);
      var data = jsonDecode(response.body);
      List list = [];
      if (kDebugMode) {
        print('GET_Profile Data Response: ${response.body}');
      }

      if (200 == response.statusCode) {
        list.addAll(data);
        return list;
        //    return {'userId': data['userId'], 'userType': data['userType']};
      } else {
        return throw "No Internet Connection";
      }
    } catch (e) {
      throw "No Internet Connection";
      // handle no internet error
    }
  }
  //=============================
  
  //Method to Driver View Total Price of Orders

  static Future<List> viewtotalprice(
     String userId,
  ) async {
    var map = <String, dynamic>{};
     map['id'] = userId;
     map['action'] = _View_Total_Price;

    try {
      final response = await http.post(url, body: map);
      var data = jsonDecode(response.body);
      List list = [];
      if (kDebugMode) {
        print('GET_Total Price of Orders Response: ${response.body}');
      }

      if (200 == response.statusCode) {
        list.addAll(data);
        return list;
        //    return {'userId': data['userId'], 'userType': data['userType']};
      } else {
        return throw "No Internet Connection";
      }
    } catch (e) {
      throw "No Internet Connection";
      // handle no internet error
    }
  }
//=====================================
 //Method to  Driver to Accept order
  static Future<String> acceptOrder(
    String orderId,
    bool status
  ) async {
    try {
      int rstatus=0;
    if(status)
    {
      rstatus=1;
    }
      var map = <String, dynamic>{};
      map['action'] = _Accept_Order;
      map['id'] = orderId;
     map['status'] = rstatus.toString();

      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print("Update Driver Location Response: ${response.body}");
      }
      if (200 == response.statusCode) {
        return jsonDecode(response.body);
      } else {
        return 'error';
      }
    } catch (e) {
      return "error";
    }
  }

//======================
 static Future<String> updatePayment(
    String orderId,
    bool payment
  ) async {
    try {
      int rpayment=0;
    if(payment)
    {
      rpayment=1;
    }
      var map = <String, dynamic>{};
      map['action'] = _Update_Payment_Order;
      map['id'] = orderId;
     map['payment'] = rpayment.toString();

      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print("Update payment of the order Response: ${response.body}");
      }
      if (200 == response.statusCode) {
        return jsonDecode(response.body);
      } else {
        return 'error';
      }
    } catch (e) {
      return "error";
    }
  }
//=======================
 static Future<String> updateRating(
    String userId,
    double rate
  ) async {
    try {
   
      var map = <String, dynamic>{};
      map['action'] = _Update_Rating;
      map['id'] = userId;
     map['rating'] = rate.toString();

      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print("Update Rating of the Driver Response: ${response.body}");
      }
      if (200 == response.statusCode) {
        return jsonDecode(response.body);
      } else {
        return 'error';
      }
    } catch (e) {
      return "error";
    }
  }
//=======================


 //Method to  Driver to Accept order
  static Future<String> activedriver(
    String driverId,
    bool status
  ) async {
    try {
      int rstatus=0;
    if(status)
    {
      rstatus=1;
    }
      var map = <String, dynamic>{};
      map['action'] = _Active_Driver;
      map['id'] = driverId;
     map['status'] = rstatus.toString();

      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print("Active Driver Response: ${response.body}");
      }
      if (200 == response.statusCode) {
        return jsonDecode(response.body);
      } else {
        return 'error';
      }
    } catch (e) {
      return "error";
    }
  }

//======================
//Method to Get deivers
  static Future<List> getAllDrivers() async {
    var map = <String, dynamic>{};
    map['action'] = _GET_AllDriver;

    try {
      final response = await http.post(url, body: map);
      var data = jsonDecode(response.body);
      List list = [];
      if (kDebugMode) {
        print('GET_Driver Response: ${response.body}');
      }

      if (200 == response.statusCode) {
        list.addAll(data);
        return list;
        //    return {'userId': data['userId'], 'userType': data['userType']};
      } else {
        return throw "No Internet Connection";
      }
    } catch (e) {
      throw "No Internet Connection";
      // handle no internet error
    }
  }
//======================

// Method to Get orders
static Future<List> displayOrders(String userId, BuildContext context) async {
  var map = <String, dynamic>{};
  map['id'] = userId;
  map['action'] = _GET_CustomerOrder;
  try {
    final response = await http.post(url, body: map);

    List list = [];
    if (kDebugMode) {
      print('GET_Customer Order Response: ${response.body}');
    }

    if (response.statusCode == 200) {
      if (response.body == 'NoOrder') {
       // Display a SnackBar with "No Orders" message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No Orders"),
          ),
        );
        // Return an empty list to indicate no orders
        return [];
      } else {
        // Orders are available, decode the response body
        var data = jsonDecode(response.body);
        // Create a list and add the data to it
        List list = List.from(data);
        return list;
      }
    } else {
      throw Exception("No Internet Connection");
    }
  } catch (e) {
    String errorMessage;
    if (e is Exception) {
      errorMessage = e.toString();
    } else {
      errorMessage = "Unknown error occurred.";
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
    
    // Rethrow the exception to propagate it to the calling code
    rethrow;
  }
}






}
