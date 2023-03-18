import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unibeethree/webwelcome.dart';

import 'AdminHP.dart';
//import 'forgetPassApp1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//text controllers

  //final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance.collection("drivers").where('status', isEqualTo: false).snapshots();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isObscure3 = true;
  String errorMessage = '';
  bool validuser = false;
  int count = 0;
  bool errorMessage2 = false;

  void isAccepted() async {
    final QuerySnapshot<Map<String, dynamic>> readRequest =
        await FirebaseFirestore.instance.collection("Admins").get();
    count = readRequest.size;
    for (var i = 0; i < count; i++) {
      if (_emailController.text.trim() ==
          readRequest.docs[i]['email'].toString()) {
        validuser = true;
        //print(validDriver);
        break;
      }
    }
  }

  Future signIn() async {
    if (validuser == true) {
      validuser = false;
    }
    if (errorMessage2 == true) {
      errorMessage2 = false;
    }

    setState(() {
      isAccepted();
    });

    try {
      //loading circle
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      setState(() {});
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => adminList()));

      //pop loading circle
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        //errorMessage = error.message!;
        errorMessage = "Your Email or password is incorrect, Please try again";
        errorMessage2 = true;
        print("No user found for this email");
      } else if (error.code == 'wrong-password') {
        errorMessage = "Your Email or password is incorrect, Please try again";
        errorMessage2 = true;
        print("Wrong password");
      }
      setState(() {});
    }

    print(validuser);
    print(errorMessage2);
    print(count);

    if (validuser == false && errorMessage2 == false) {
      errorMessage = "Your Account is not an Admin";
    } else if (validuser == true && errorMessage2 == false) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => AdminHP()));
    } else
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        /////////
        body: Form(
      key: _key,
      child: Container(
        height: 1440,
        child: Stack(
          children: [
            //images:

            //2) yellow
            Positioned(
                right: 0,
                bottom: -110,
                child: Container(
                  width: 1150.82,
                  height: 974.09,
                  child: Image.asset('assets/images/yellowlogweb.png'))),

            //3) logo
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
            ), // end logo

            //4) pink
            Positioned(
                left: -310,
                bottom: -60,
                child: Container(
                  width: 1500,
                  child: Image.asset('assets/images/pinklogweb.png'))),

            //5) bee
            Positioned(
                right: 0, top: 0, child: Image.asset('assets/images/bee1.png')),

            //Email text
            Positioned(
              left: 750,
              top: 250,
              child: Text(
                "Email",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xff4b6d76),
                ),
              ),
            ),

            //password text
            Positioned(
              left: 750,
              top: 360,
              child: Text(
                "Password",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xff4b6d76),
                ),
              ),
            ),

            // forgot password?
            /* Positioned(
              left: 45,
              top: 570,
              child: Text(
                "Forgot Password?",
                style: GoogleFonts.alice(
                  fontSize: 12,
                  color: Color.fromARGB(255, 215, 1, 1),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),*/

            ///////////////////////////////////////////////////
            Positioned.fill(
              left: 490,
              child: Column(
                children: [

                  SizedBox(height: 180),

                  //Welcome Back! text
                  /*Text(
                    'Welcome Back!',
                    style: GoogleFonts.alice(
                        fontSize: 40, color: Color(0xff204854)),
                  ),
////
                  SizedBox(height: 140),*/

                  //Email textfield

                  SizedBox(height: 115),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 240.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextFormField(
                        controller: _emailController,

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Enter your Email',
                          contentPadding: EdgeInsets.only(left: 20.0),
                        ),
                        //////////////validation////////////
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else if (!RegExp(
                                  r"^(?!.* )[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)) {
                            return "Enter a valid email";
                          } else
                            return null;
                        },

                        //////////////////////////////////
                        ///
                      ),
                    ),
                  ),

                  //Password textfield

                  SizedBox(height: 60),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 240.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextFormField(
                        controller: _passwordController,

                        obscureText: _isObscure3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Enter your Password',
                          contentPadding:
                              EdgeInsets.only(left: 20.0, top: 10.0),
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure3
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure3 = !_isObscure3;
                                  //isAccepted();
                                });
                              }),
                        ),

                        //////////////validation////////////
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else if (!RegExp(r"^(?!.* ).{8,15}")
                              .hasMatch(value!)) {
                            return "Enter a valid password";
                          } /*else if(validDriver == false){
                                  return "your account is not accepted yet";
                                }*/
                          else
                            return null;
                        },

                        //////////////////////////////////
                      ),
                    ),
                  ),

                  //SizedBox(height: 80),

                  //Sign in button GestureDetector
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color(0xff204854),
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.alice(
                                fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),*/

                  /*Center(
                    child: Text(errorMessage),
                  ),*/
                  // error message
                  Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 215, 1, 1),
                      ),
                    ),
                  ),

                  /*Container(
                            width: 30,
                            height: 20,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: readRequest,
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                if (snapshot.hasData){
                                  final users = snapshot.data!;
                                  int count = users.docs.length;
                                  for(int x = 0 ; x < count ;x++){
                                    if ( _emailController.text.trim() == users.docs[x]['email'].toString()){
                                      validDriver = false;
                                      return Text(
                                                  "your account is not accepted yet!",
                                              );}; }
                                              return Text(
                                                  "",
                                              );
                                    }
                                  return Center(child: CircularProgressIndicator()); 
                                },
                                        ),
                          ),*/
                /*Row(
                   children:[
                  Positioned(
                    left: 1000,
                      child: TextButton(
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
              
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            signIn();
                          } //if
                        },
                      ),
                  ),
                  
              Positioned(
              left: 1000,
              top: 500,
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
                    color: Color(0xff204854),
                    width: 1,
                  ),
                  color: Color(0xffffdf75),
                ),
                child: Center(
                  child: GestureDetector(
                    //onTab: Widget.showRegisterPage, //registration page onPressed?
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: Color(0xff204854),
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              ),
            ),
            ],
                ),*/
                  //////////////////////////////////////
                ],
              ),
            ),

          Positioned(
                    left: 730,
                    top:500,
                      child: TextButton(
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
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            signIn();
                          } //if
                        },
                      ),
                  ),
                  
              Positioned(
              left: 930,
              top: 500,
              child:TextButton( 
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => webwelcome()));
                      },
                      child: Container(
                width: 193,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Color(0xff204854),
                    width: 1,
                  ),
                  color: Color(0xffffdf75),
                ),
                child: Center(
                  child: GestureDetector(
                    //onTab: Widget.showRegisterPage, //registration page onPressed?
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xff204854),
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              ),
            ),


            //1) Welcome Back!
            Positioned(
              left: 150,
              top: 250,
              child: Text(
                "Welcome Back!",
                style:
                    TextStyle(fontSize: 40, color: Color(0xff204854)),
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
          ],
        ),
      ),
    ));
  }
}

/*SizedBox(
      width: 390,
      height: 844,
      child: Material(
        color: Colors.white,
        elevation: 4,
        //color: Color(0x3f000000),
        child: Stack(
          children: [
            Positioned(
              left: 47,
              top: 479,
              child: SizedBox(
                width: 296,
                height: 37,
                child: Material(
                  color: Color(0x1e000000),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0x1e000000),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Transform.rotate(
              angle: 3.14,
              child: Container(
                width: 390,
                height: 844,
                padding: const EdgeInsets.only(
                  right: 89,
                  top: 41,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.rotate(
                      angle: 3.14,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FlutterLogo(size: 40),
                      ),
                    ),
                    SizedBox(height: 606),
                    Container(
                      width: double.infinity,
                      height: 844,
                      child: FlutterLogo(size: 390),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 68,
              top: 19,
              child: Transform.rotate(
                angle: -1.60,
                child: Container(
                  width: 209.12,
                  height: 149.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(101),
                  ),
                  child: FlutterLogo(size: 149.84681701660156),
                ),
              ),
            ),
            Positioned(
              left: 47,
              top: 392,
              child: SizedBox(
                width: 296,
                height: 37,
                child: Material(
                  color: Color(0x1e000000),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0x1e000000),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 61,
              top: 255,
              child: Text(
                "Welcome Back!",
                style: TextStyle(
                  color: Color(0xff204854),
                  fontSize: 40,
                ),
              ),
            ),
            Positioned(
              left: 80,
              top: 586,
              child: SizedBox(
                width: 230.83,
                height: 50,
                child: Material(
                  color: Color(0xff1e4845),
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 74,
                      right: 81,
                      top: 12,
                      bottom: 11,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 57,
              top: 368,
              child: Text(
                "E-mail",
                style: TextStyle(
                  color: Color(0xff204854),
                  fontSize: 15,
                ),
              ),
            ),
            Positioned(
              left: 57,
              top: 524,
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: Color(0xffff3939),
                  fontSize: 10,
                ),
              ),
            ),
            Positioned(
              left: 57,
              top: 455,
              child: Text(
                "Password",
                style: TextStyle(
                  color: Color(0xff204854),
                  fontSize: 15,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 266,
                  height: 312,
                  child: FlutterLogo(size: 266),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 224,
                  height: 149,
                  child: FlutterLogo(size: 149),
                ),
              ),
            ),
          ],
        ),
      ),
    );*/