import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'model/server.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String dropdownValue = 'User';
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
   final TextEditingController _passcon = TextEditingController();
  String _password = '';
  String _confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
    _passcon.dispose();
  }

  _clearTextInput() {
    _email.text = '';
    _pass.text = '';
    dropdownValue = 'User';
  }

  _register() async {
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
      }
      return;
    } else {
      Services.register(
        _email.text,
        _pass.text,
        dropdownValue,
      ).then((result) {
        if ('Success' == result) {
          _clearTextInput();
         Navigator.pushNamed(context, "/login");
        } else if ('Exists' == result) {
          _clearTextInput();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFb2a676),
              content: Row(
                children: [
                   Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                  Text(
                    ' Email already exists',
                    style: TextStyle(color: Color(0xFFE71F1F)),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFb2a676),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('Home'),
          ),
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
                            height: 5,
                          ),
                          Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 35,
                                fontFamily: "myfont",
                                color: Colors.grey[800]),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SvgPicture.asset(
                            "assets/icons/signup.svg",
                            height: 120,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 227, 190),
                              borderRadius: BorderRadius.circular(66),
                            ),
                            width: 266,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: _email,
                              decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 176, 162, 39),
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
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 227, 190),
                              borderRadius: BorderRadius.circular(66),
                            ),
                            width: 266,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                                controller: _pass,
                               obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                  
                                  icon: const Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 174, 159, 31),
                                    size: 19,
                                  ),
                                  hintText: "Password :",
                                 // prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  _password = value;
                                },
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Password is required please enter';
                                  }
                                  // you can check password length and specifications

                                  return null;
                                }),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 227, 190),
                              borderRadius: BorderRadius.circular(66),
                            ),
                            width: 266,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                                controller: _passcon,
                               obscureText: !_isPasswordVisible2,
                              decoration: InputDecoration(
                                  
                                  icon: const Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 174, 159, 31),
                                    size: 19,
                                  ),
                                    hintText: "Co-Password :",
                                     // prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible2
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible2 = !_isPasswordVisible2;
                                });
                              },
                            ),
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  _confirmPassword = value;
                                },
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Conform password is required please enter';
                                  }
                                  if (value != _password) {
                                    return 'Confirm password not matching';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 227, 190),
                              borderRadius: BorderRadius.circular(66),
                            ),
                            width: 266,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            ///////
                            child: Row(
                                //  mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Type:  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  DropdownButton<String>(
                                    // Step 3.
                                    value: dropdownValue,
                                    // Step 4.
                                    items: <String>['User', 'Driver']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    // Step 5.
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_form.currentState!.validate()) {
                                _register();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 176, 162, 39)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 103, vertical: 12)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(27))),
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an accout? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/login");
                                },
                                child: const Text(
                                  " Log in",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            width: 299,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  thickness: 0.6,
                                  color: Color.fromARGB(255, 176, 162, 39),
                                )),
                                Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 176, 162, 39),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                  thickness: 0.6,
                                  color: Color.fromARGB(255, 176, 162, 39),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(9.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 176, 162, 39),
                                            width: 1)),
                                    child: SvgPicture.asset(
                                      "assets/icons/facebook.svg",
                                      color: const Color.fromARGB(255, 176, 162, 39),
                                      height: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 176, 162, 39),
                                            width: 1)),
                                    child: SvgPicture.asset(
                                      "assets/icons/google-plus.svg",
                                      color: const Color.fromARGB(255, 176, 162, 39),
                                      height: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 176, 162, 39),
                                            width: 1)),
                                    child: SvgPicture.asset(
                                      "assets/icons/twitter.svg",
                                      color: const Color.fromARGB(255, 176, 162, 39),
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
