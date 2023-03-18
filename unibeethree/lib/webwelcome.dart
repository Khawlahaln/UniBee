import 'package:flutter/material.dart';
import './AdminHP.dart';
import './adminList.dart';
import 'login_pageweb.dart';

class webwelcome extends StatefulWidget {
  //this comment for linking
  //final VoidCallback showRegisterPage;
  //const webwelcome({Key? key, required this.showRegisterPage}) : super(key: key);
  const webwelcome({super.key}); // i will deleate after linking

  @override
  State<webwelcome> createState() => _webwelcomeState();
}

class _webwelcomeState extends State<webwelcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1440,
        height: 832,
        color: Colors.white,
        child: Stack(
          children: [
            //yellow top
            Positioned(
              top: -1,
              left: 720,
              child: Container(
                width: 650,
                height: 345,
                child: Image(image: AssetImage('assets/images/TOPyellowPIC.png')),
              ),
            ),

            //bee pic
            Positioned(
              top: -147,
              left: 1050,
              child: Container(
                width: 315,
                height: 450,
                child: Image(image: AssetImage('assets/images/bee1.png')),
              ),
            ),

            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Stack(
                          children: [
                            //unibeeWord
                            Positioned(
                              left: 105,
                              top: 45,
                              child: Container(
                                width: 133.38,
                                height: 35,
                                child: Image(
                                    image: AssetImage('assets/images/UniBeeWORD.png')),
                              ),
                            ),

                            //unibeeLogo
                            Positioned(
                              left: 10,
                              top: 5,
                              child: Container(
                                width: 120,
                                height: 95,
                                child: Image(
                                    image: AssetImage('assets/images/UniBeeLOGO.png')),
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

            //line of footer
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 1440,
                  height: 30,
                  color: Color(0xff4b6d76),
                ),
              ),
            ),

            //copy right
            Positioned.fill(
              bottom: 8,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: Text(
                    "©2022 UniBee. All rights reserved.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            //yellow bottom
            Positioned.fill(
              bottom: 30,
              left: -190,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 1300,
                  height: 495,
                  child: Image(image: AssetImage('assets/images/BOTTOMyellowPIC.png')),
                ),
              ),
            ),

            //uni pic
            Positioned.fill(
              bottom: 16,
              left: 420,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 900,
                  height: 522,
                  child: Image(image: AssetImage('assets/images/uniPIC.png')),
                ),
              ),
            ),

            //golf car pic
            Positioned.fill(
              bottom: 25,
              left: 200,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 248,
                  height: 221,
                  child: Image(image: AssetImage('assets/images/golfPIC.png')),
                ),
              ),
            ),

            Positioned(
              top: 140,
              left: 80,
              child: SizedBox(
                width: 604,
                height: 78,
                child: Text(
                  "welcome to uniBee",
                  style: TextStyle(
                    color: Color(0xffbabc84),
                    fontSize: 45,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 200,
              left: 80,
              child: SizedBox(
                width: 528,
                height: 75,
                child: Text(
                  "Your superhero to manage all the campus at a glance !",
                  style: TextStyle(
                    color: Color(0x9e4b6c76),
                    fontSize: 30,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 80,
              top: 280,
              child:TextButton( 
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Container(
                width: 193,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Color(0x1e000000),
                    width: 1,
                  ),
                  color: Color(0xcc1e4854),
                ),
                child: Center(
                  child: GestureDetector(
                    //onTab: Widget.showRegisterPage, //registration page onPressed?
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}