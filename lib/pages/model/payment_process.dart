import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:flutter_nta_final/pages/model/stripe_key.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentManager {
   static String driver_Id = "";
 static String driver_Image= "";
 static double driver_Rate= 0.0;
 static String driver_Email = "";   
 static Map<String, dynamic>? paymentIntentData;
  @override

static Future<void> makePayment(String orderId,String driverId,String driverImage,String driverRate,String driverEmail,int amount, String currency, BuildContext context) async {
   
    try {
      driver_Id = driverId;
          driver_Image= driverImage;
          driver_Rate= double.parse(driverRate);
          driver_Email = driverEmail;  
      paymentIntentData =
          await createPaymentIntent(amount.toString(), currency); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret: ApiKeys.secretKey,
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  //applePay: PaymentSheetApplePay.,
                  //googlePay: true,
                  //testEnv: true,
                //  customFlow: true,
                  style: ThemeMode.dark,
                  // merchantCountryCode: 'US',
                  merchantDisplayName: 'NTA'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(orderId,context);
    } catch (e, s) {
      print('Payment exception:$e$s');
    }
  }

  static displayPaymentSheet(String orderId,BuildContext context) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              //       parameters: PresentPaymentSheetParameters(
              // clientSecret: paymentIntentData!['client_secret'],
              // confirmPayment: true,
              // )
              )
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));
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

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  static createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${ApiKeys.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  static calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
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
                          scale: 1.0,
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