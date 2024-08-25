import 'package:flutter/material.dart';
import 'package:flutter_nta_final/pages/admin/viewdriverpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profilepage.dart';
import 'homepage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class AdminPageController {
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

class _AdminPageState extends State<AdminPage> {
  late AdminPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdminPageController();
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

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(), 
    const ViewDriverPage(),// Replace with the appropriate widget
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
          title: const Text('Admin Page'),
          actions: [
            IconButton(
              icon:  CircleAvatar(
                backgroundImage:  NetworkImage(
                      'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${_controller.userImage ?? ''}',
                      scale: 1.0,
                    ),
                backgroundColor: Colors.black12,
                child: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 176, 162, 39),
                ),
               ),
              onPressed: () {
                // Add your desired functionality here
              },
            ),
          ],
        ),
        drawer: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5, // Set the desired width here
          child: Drawer(
            child: ListView(
               children: <Widget>[
                 UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color:  Color(0xFFb2a676)),
                  accountName: const Text(
                    "Admin",
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
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:  NetworkImage(
                      'https://ntafproject.000webhostapp.com/fnta_api/upload/userimage/${_controller.userImage ?? ''}',
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
                  leading: const Icon(Icons.people_alt_outlined),
                  title: const Text('Active Drivers'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
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