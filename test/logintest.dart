import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'components/dropdowndemo.dart';
import 'package:flutter_nta_final/pages/model/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  // final _typeController=dropdownValue;
  String userId = "";
  String userType = "";
  String errorMessage = "";

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
  }

  _clearTextInput() {
    _email.text = '';
    _pass.text = '';
  }

  void _login() async {
    if (_email.text.isEmpty || _pass.text.isEmpty) {
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
        //   print('Empty Field');
      }
      return;
    } else {
      try {
        var data = await Services.login(_email.text, _pass.text);
        //  var data = response;
        final prefs = await SharedPreferences.getInstance();
        if (data['status'] == 'success') {
          var userId = data['userId'];
          var userImage = data['userImage'] ?? '';
          var userType = data['userType'];
          prefs.setString('userId', userId);
          prefs.setString('userImage', userImage) ?? '';
          prefs.setString('userEmail', _email.text);
          prefs.setString('userType', userType);
          if (userType == "Admin") {
            Navigator.pushNamed(context, "/adminpage");
          } else if (userType == "Customer") {
            Navigator.pushNamed(context, "/userpage");
          } else if (userType == "Driver") {
            Navigator.pushNamed(context, "/driverpage");
          } else {
            _clearTextInput();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFFb2a676),
                content: Row(
                  children: [
                    Icon(Icons.thumb_up, color: Colors.white),
                    Text(
                      ' Faild Login  ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }
        } else if (data['status'] == 'fail') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFb2a676),
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                  Text(
                    'Invalid credentials ',
                    style: TextStyle(color: Color(0xFFE71F1F)),
                  ),
                ],
              ),
            ),
          );
        }
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
      } on HttpException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFb2a676),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                Text(
                  ' unexpected error ',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
        // show unexpected error snackbar
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFb2a676),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                Text(
                  ' generic error ',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
        // show generic error snackbar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SafeArea(
        child: Scaffold(
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Form(
                  key: _form,
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Log in",
                            style:
                                TextStyle(fontSize: 33, fontFamily: "myfont"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SvgPicture.asset(
                            "assets/icons/login.svg",
                            width: 258.0,
                            height: 170.0,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 227, 190),
                              borderRadius: BorderRadius.circular(66),
                            ),
                            width: 266,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 9.0),
                            child: TextFormField(
                              controller: _email,
                              decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 195, 171, 35),
                                  ),
                                  hintText: "Your Email :",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                var pattern = r'^[^@]+@gmail\.com$';

                                RegExp regex = RegExp(pattern);

                                if (!regex.hasMatch(value)) {
                                  return 'Enter a valid Gmail';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 227, 190),
                              borderRadius: BorderRadius.circular(66),
                            ),
                            width: 266,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: _pass,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password.';
                                }
                                if (value.length != 8) {
                                  return 'Password must be 8 digits long.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.visibility,
                                  color: Colors.purple[900],
                                ),
                                icon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 174, 159, 31),
                                  size: 19,
                                ),
                                hintText: 'Password:',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_form.currentState!.validate()) {
                                // email is valid, continue
                                _login();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 176, 162, 39)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 106, vertical: 10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(27))),
                            ),
                            child: const Text(
                              "login",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an accout? "),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/signup");
                                  },
                                  child: const Text(
                                    " Sign up",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Image.asset(
                    "assets/images/main_top.png",
                    width: 100,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/login_bottom.png",
                    width: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
