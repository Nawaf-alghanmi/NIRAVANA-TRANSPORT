import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:flutter_nta_final/pages/model/stripe_key.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

abstract class PaymentManager {
 static String driver_Id = "";
 static String driver_Image= "";
 static double driver_Rate= 0.0;
 static String driver_Email = "";                   
  static Future<void> makePayment(String orderId,String driverId,String driverImage,String driverRate,String driverEmail,int amount, String currency, BuildContext context) async {
    try {
          driver_Id = driverId;
          driver_Image= driverImage;
          driver_Rate= double.parse(driverRate);
          driver_Email = driverEmail;  
      String clientSecret = await _getClientSecret((amount * 100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
      // Display a dialog for successful payment
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Successful'),
            content: Text('Thank you for your payment.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  _updatePayment(orderId);
                  _showRatingDialog( context);
                 // Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } on StripeException catch (error) {
      if (error.toString().contains('The payment flow has been canceled')) {
        // Display a dialog for canceled payment
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Payment Canceled'),
              content: Text('The payment process has been canceled.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // Ignore the error and continue execution
        return;
      }
      // Rethrow the error for other StripeExceptions
      throw Exception(error.toString());
    } catch (error) {
      // Rethrow the error for other exceptions
      throw Exception(error.toString());
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Basel",
        customFlow: true,
      ),
    );
  }

  static Future<void> _updatePayment(String orderId) async {
    bool payment=true;
    await Services.updatePayment(orderId, payment);
  }
  
  static Future<void> _updateRating(String driverId,double rate) async {
    //double rate=0.0;
    //rate=rate+driver_Rate;
    await Services.updateRating(driverId, rate);
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'amount': amount,
          'currency': currency,
        },
      );
      final responseData = jsonDecode(response.body);
      return responseData["client_secret"];
    } catch (error) {
      // Rethrow the error for further handling
      throw Exception(error.toString());
    }
  }

   static void _showRatingDialog(BuildContext context) {
    double rating = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate the Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          driver_Image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
              Text('${driver_Email}'),
              SizedBox(height: 16),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                unratedColor: Colors.grey[300],
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                  driver_Rate=driver_Rate+(rating/5);
 //_updateRating(driver_Id, driver_Rate) 
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
               // Navigator.of(context).pop();
                Navigator.pushNamed(context, "/userpage");
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle rating submission
                // You can use the value of 'rating' to perform any necessary operations
                _updateRating(driver_Id, driver_Rate) ;
                // Close the dialog
                Navigator.pushNamed(context, "/userpage");
               // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}