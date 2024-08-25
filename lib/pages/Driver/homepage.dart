import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String imageUrl = "";
  List driver = [];
  List Totalprice = [];
  late AnimationController _animationController;
  late Animation<double> _nameAnimation;
  late Animation<double> _priceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _nameAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5),
      ),
    );

    _priceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1),
      ),
    );

    _animationController.forward();
  }

  Future<List> getuserdata() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    String userType = prefs.getString('userType') ?? '';

    driver = await Services.viewdataprofile(userId, userType);
    return driver;
  }

  Future<List> gettotalprice() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    Totalprice = await Services.viewtotalprice(userId);
    return Totalprice;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: Future.wait([getuserdata(), gettotalprice()]),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          driver = snapshot.data![0] ?? [];
          Totalprice = snapshot.data![1] ?? [];

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
                ListTile(
                  leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${driver[0]['image'] ?? 'image'}',
                          scale: 1.0,
                          width: 80,
                          height: 80,
                          
                        ),
              
              
                  ),
                  title: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: _nameAnimation.value * 40,
                    child: Text(
                      driver[0]['name'] ?? 'Name',
                      style: TextStyle(
                        fontSize: _nameAnimation.value * 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                const SizedBox(height: 16.0),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: _priceAnimation.value * 40,
                 child: Center(
                   child: RichText(
                    textAlign: TextAlign.center,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'Total Price: ',
                            style: TextStyle(
                              fontSize: _priceAnimation.value * 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      children:[
                        TextSpan(
                            text: '${Totalprice.isNotEmpty ? Totalprice[0]['Total'] ?? '00' : 'N/A'} SAR',
                            style: TextStyle(
                              fontSize: _priceAnimation.value * 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, // Change the color to your desired color
                      ),
                    ),
                      ],
                                   ),
                                 ],
                               ),
                   ),
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