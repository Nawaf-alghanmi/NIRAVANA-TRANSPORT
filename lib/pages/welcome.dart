import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Welcome",
                        style: TextStyle(fontSize: 33, fontFamily: "myfont"),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    
                      SvgPicture.asset(
                        "assets/icons/chat.svg",
                        width: 283,
                        height: 200,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                        const Text(
                        "Efficient, Reliable, and Convenient Freight Transport App. Experience seamless delivery of your goods with speed and accuracy",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "myfont"
                         ),
                        textAlign: TextAlign.center,
                       
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 155, 127, 40)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 50, vertical: 13)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27))),
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 255, 255, 255),),
                          
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 219, 199, 110)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 50, vertical: 13)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27))),
                        ),
                        child: Text(
                          "SIGNUP",
                          style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ],
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
                child: Image.asset(
                  "assets/images/main_bottom.png",
                  width: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
