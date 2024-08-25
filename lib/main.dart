import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/Driver/driverpage.dart';
import 'package:flutter_nta_final/pages/Driver/vieworder.dart';
import 'package:flutter_nta_final/pages/admin/adminpage.dart';
import 'package:flutter_nta_final/pages/model/stripe_key.dart';
import 'package:flutter_nta_final/pages/users/displayorder.dart';
import 'package:flutter_nta_final/pages/users/driverlistpage.dart';
import 'package:flutter_nta_final/pages/profilepage.dart';
import 'package:flutter_nta_final/pages/users/orderpage.dart';
import 'package:flutter_nta_final/pages/users/userpage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'pages/admin/viewdriverpage.dart';
import 'pages/login.dart';

import 'pages/signup.dart';
import 'pages/users/furniturepage.dart';
import 'pages/users/mapscreen.dart';
import 'pages/welcome.dart';
//import 'package:firebase_core/firebase_core.dart';
void main() async {
 // Stripe.publishableKey=ApiKeys.publishableKey;
  WidgetsFlutterBinding.ensureInitialized();
    Stripe.publishableKey=ApiKeys.publishableKey;
  Stripe.merchantIdentifier = 'App';
  await Stripe.instance.applySettings();
 // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/" ,
      routes: {
        "/" : (context) => const Welcome(),
        "/login" : (context) =>  const Login(),
        "/signup" : (context) => const Signup(),
        "/adminpage" : (context) => const AdminPage(),
        "/driverpage" : (context) => const DriverPage(),
        "/userpage" : (context) => const UserPage(),
        "/mapscreen" : (context) =>  const MapsScreen(),
        "/orderpage" : (context) =>  const OrdersPage(),
        "/profilepage" : (context) =>  const ProfilePage(),
        "/driverlistpage" : (context) =>  const DriverListPage(),
        "/furniturepage" : (context) =>  const FurniturePage(),
        "/viewdriverpage" : (context) =>  const ViewDriverPage(), 
        "/displayorder" : (context) =>   const DisplayOrder(), 
         "/vieworder" : (context) =>   const ViewOrderPage(), 
  
          

      },
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
    );
  }
}
