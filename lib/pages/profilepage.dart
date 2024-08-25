import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/server.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _Copass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  String userId = "";
  String userType = "";
  String _password = "";
  String _Copassword = "";
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _pass.dispose();
    _phone.dispose();
    _Copass.dispose();
  }

  _clearTextInput() {
    _name.text = '';
    _pass.text = '';
    _phone.text = '';
    _Copass.text = '';
  }

  Future<void> choiceImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  _updateProfile() async {
    if (_name.text.isEmpty || _pass.text.isEmpty || _phone.text.isEmpty|| _image==null) {
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
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
      userType = prefs.getString('userType') ?? '';
      Services.updateProfile(
        userId,
        _name.text,
        _pass.text,
        _phone.text,
        _image!,
        userType,
      ).then((result) {
        if ('Success' == result) {
          _clearTextInput();
        } else if ('Error' == result) {
          _clearTextInput();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFb2a676),
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                  Text(
                    ' Error Update try Again',
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
          appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(148, 150, 195, 178),
          elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
               ),
          title: Text('Edit Profile', style: Theme.of(context).textTheme.headlineMedium),
          ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // -- IMAGE with ICON
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                     // child: ClipRRect(
                    //    borderRadius: BorderRadius.circular(100),
                  //      child: _image == null ? Text('No Image Selected') : Image.file(_image!),
                    child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _image == null
                              ? Image.asset('assets/images/userprofile.png') // Replace 'assets/default_image.png' with your default image path
                              : Image.file(_image!),
                        ),
      
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          choiceImage();
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(255, 176, 162, 39),
                          ),
                          child: const Icon(LineAwesomeIcons.camera, color: Color.fromARGB(255, 255, 255, 255), size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
      
                // -- Form Fields
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(LineAwesomeIcons.user),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone No',
                          prefixIcon: Icon(LineAwesomeIcons.phone),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                          controller: _pass,
                           obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            )
                            ),
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
                      const SizedBox(height: 7),
                      TextFormField(
                          controller: _Copass,
                          obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            labelText: 'Co-Password',
                            hintText: 'Repeat your password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            )
                            ),
                          onChanged: (value) {
                            _Copassword = value;
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
                       const SizedBox(height: 20),
                      // -- Form Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                              onPressed: () {
                                if (_form.currentState!.validate()) {
                                  _updateProfile();
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
                                " Save",
                                style: TextStyle(fontSize: 18),
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
    );
  }
}
