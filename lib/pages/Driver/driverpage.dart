
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profilepage.dart';
import 'homepage.dart';
import 'setlocation.dart';
import 'vieworder.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  _DriverPageState createState() => _DriverPageState();
}

class DriverPageController {
  String? userId;
  String? userImage;
  String? userType;
  String? userEmail;

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    userImage = prefs.getString('userImage') ?? '';
    userType = prefs.getString('userType') ?? '';
    userEmail = prefs.getString('userEmail') ?? '';
  }
}

class _DriverPageState extends State<DriverPage> {
  late DriverPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DriverPageController();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _controller.getData();
      // Data fetching completed successfully
    } catch (error) {
      // Handle any errors that occurred during data fetching
    }
  }

   _logout() async {
    Navigator.pushNamed(context, "/login");
  }

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(), // Replace with the appropriate widget
    const ViewOrderPage(),
    const SetLocation(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFb2a676),
          elevation: 0,
          title: const Text('Driver Page'),
          actions: [
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 176, 162, 39),
                ),
              ),
              tooltip: 'Logout',
              alignment: Alignment.center,
              padding: const EdgeInsets.all(0),
              iconSize: 24,
              splashRadius: 24,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
              focusColor: const Color.fromARGB(207, 219, 52, 36),
              hoverColor: const Color.fromARGB(207, 219, 52, 36),
              highlightColor: const Color.fromARGB(219, 210, 180, 27),
              splashColor: const Color.fromARGB(200, 255, 255, 255),
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
            ),
          ],
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.5, // Set the desired width here
          child: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFFb2a676)),
                  accountName: const Text(
                    "Driver",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    _controller.userEmail ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture:  CircleAvatar(
                    backgroundImage:  NetworkImage(
                      'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${_controller.userImage ?? 'image'}',
                      scale: 1.0,
                    ),
                    maxRadius: 10,
                    backgroundColor: const Color.fromARGB(182, 107, 112, 187),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('View transfer Order'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                    ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: const Text('Set Location'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Log Out '),
                  onTap: () {
                    Navigator.pushNamed(context, "/login");
                 //   Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
          ),
        ),
        body: _screens[_selectedIndex],
      ),
    );
  }
}
