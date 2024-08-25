import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/server.dart';

class FurniturePage extends StatefulWidget {
  const FurniturePage({super.key});

  @override
  State<FurniturePage> createState() => _FurniturePageState();
}

class _FurniturePageState extends State<FurniturePage> {
  File? _image;
  final picker = ImagePicker();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _price = TextEditingController();
  String userId = "";

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _description.dispose();
    _quantity.dispose();
    _price.dispose();
  }

  _clearTextInput() {
    _name.text = '';
    _description.text = '';
    _quantity.text = '';
    _price.text = '';
  }

  Future<void> choiceImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  _addfurniture() async {
    if (_name.text.isEmpty ||
        _description.text.isEmpty ||
        _quantity.text.isEmpty ||
        _price.text.isEmpty ||
        _image == null) {
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

//==========

//============
try{
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
     
      var response= await Services.addfurniture(
        _name.text,
        _description.text,
        _quantity.text,
        _price.text,
        _image!,
        userId,
      ); 
      var data=response;
      
        if ('-1' != data) {
      prefs.setString('furnitureId', data);
          _clearTextInput();
          Navigator.pushNamed(context, "/orderpage");
        } else if ('-1' == data) {
          _clearTextInput();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFb2a676),
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFE31F1F)),
                  Text(
                    ' The name is Existing try Again',
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color(0xFFb2a676),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Add Furniture Details',
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 59, 59, 59)),
          ),
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
                            ? Image.asset(
                                'assets/images/set-furniture-vector.png') // Replace 'assets/default_image.png' with your default image path
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
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: const Color.fromARGB(255, 176, 162, 39),
                          ),
                          child: const Icon(LineAwesomeIcons.camera,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 20),
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
                          labelText: 'Furniture Name',
                          prefixIcon: Icon(LineAwesomeIcons.home),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _description,
                        decoration: const InputDecoration(
                          labelText: 'Furniture Description',
                          prefixIcon: Icon(LineAwesomeIcons.industry),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                          controller: _quantity,
                          decoration: const InputDecoration(
                              labelText: 'Quantity',
                              hintText: 'Enter the number of furniture',
                              prefixIcon: Icon(Icons.production_quantity_limits_outlined),
                             ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Quantity is required please enter';
                            }
                            return null;
                          }),
                      const SizedBox(height: 7),
                      TextFormField(
                          controller: _price,
                          decoration: const InputDecoration(
                              labelText: 'Price',
                              hintText: 'Enter the Price for transfer the furniture',
                              prefixIcon: Icon(Icons.price_change_sharp),
                             ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Price is required please enter';
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
                              _addfurniture();
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
                            " Next",
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
