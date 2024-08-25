import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/model/stripe_key.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

abstract class PaymentManager {
  static Future<void> makePayment(int amount, String currency, BuildContext context) async {
    try {
      String clientSecret = await _getClientSecret((amount * 100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (error) {
      
      if (error.toString().contains('The payment flow has been canceled')) {
        // Display a SnackBar when the payment is canceled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment canceled.'),
          ),
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
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Basel",
      ),
    );
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
}