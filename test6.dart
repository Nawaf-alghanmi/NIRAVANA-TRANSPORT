import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
String imageUrl ="";
  List driver = [];
Future<List>  getuserdata()
   async   {
    final prefs = await SharedPreferences.getInstance();
   String userId = prefs.getString('userId') ?? '';
    String userType = prefs.getString('userType') ?? '';

   driver = await Services.viewdataprofile(userId,userType); 
    return driver;
  
  }
 
 @override
Widget build(BuildContext context) {
   return FutureBuilder<List>(
      future: getuserdata(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          driver = snapshot.data ?? [];
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to the HomePage',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 8.0),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${driver[0]['image']}',
                    ),
                  ),
                   title: Text(driver[0]['name'].toString()),
                  subtitle: RatingBarIndicator(
                    rating: double.parse(driver[0]['rating'].toString()),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,

                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
                 
      
  


