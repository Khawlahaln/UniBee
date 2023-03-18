//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:unibeethree/appwelcome.dart';
import 'package:unibeethree/forgetPassApp1.dart';
import 'package:unibeethree/screen/AffliateHomePage.dart';
import 'package:unibeethree/screen/googleMap_Screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//text controllers

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
        await FirebaseFirestore.instance.collection("user affiliate").get();
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
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => AffliateHomePage()));*/
      //pop loading circle
      //Navigator.of(context).pop();
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
      Navigator.pop(context);
    }

    print(validuser);
    print(errorMessage2);
    print(count);

    if (validuser == false && errorMessage2 == false) {
      errorMessage = "Your Account is not an Affiliate";
      Navigator.pop(context);
    } else if (validuser == true && errorMessage2 == false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => googleMap_Screen()));
    }
    //  else
    //   Navigator.of(context).pop();
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
        body: SingleChildScrollView(
      child: Form(
        key: _key,
        child: Container(
          height: 850,
          child: Stack(
            children: [
              //images:

              //1) back
              /*Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff204854))),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 35,
                  ),
                ),
              ),*/

              //2) yellow
              Positioned(child: Image.asset('assets/yellow.png')),

              //3) green
              Positioned(
                  right: 0, bottom: 0, child: Image.asset('assets/green.png')),

              //4) pink
              Positioned(
                  right: 0, bottom: 0, child: Image.asset('assets/pink.png')),

              //5) bee
              Positioned(
                  left: 0, bottom: 0, child: Image.asset('assets/bee.png')),

              //Email text
              Positioned(
                left: 57,
                top: 360,
                child: Text(
                  "Email",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),

              //password text
              Positioned(
                left: 57,
                top: 470,
                child: Text(
                  "Password",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),

              ///////////////////////////////////////////////////
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 200),

                    //Welcome Back! text
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.alice(
                          fontSize: 40, color: Color(0xff204854)),
                    ),
                    ////
                    SizedBox(height: 140),

                    //Email textfield

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Container(
                        height: 50,
                        width: 2000,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextFormField(
                          maxLength: 30,
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

                    SizedBox(height: 65),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Container(
                        height: 50,
                        width: 2000,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextFormField(
                          maxLength: 15,
                          controller: _passwordController,

                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ' Enter your Password',
                            contentPadding:
                                EdgeInsets.only(left: 20.0, top: 30.0),
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure3
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
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
                            } else
                              return null;
                          },

                          //////////////////////////////////
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

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
                        style: GoogleFonts.alice(
                          fontSize: 15,
                          color: Color.fromARGB(255, 215, 1, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90.0),
                      child: ElevatedButton(
                        child: Text('Sign In',
                            style: GoogleFonts.alice(
                              fontSize: 30,
                            )),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff204854))),
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            signIn();
                          } //if
                        },
                      ),
                    ),

                    //////////////////////////////////////
                  ],
                ),
              ),
              //back

              Padding(
                padding: EdgeInsets.only(left: 25, top: 50),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/back.png')),
              ),

              // forgot password?
              /*Padding(
                padding: EdgeInsets.only(top: 660, left: 90),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => forgetPassApp1()));
                  },
                  child: Text("Forgot Password?",
                      style: GoogleFonts.alice(
                        fontSize: 14,
                        color: Color(0xff204854),
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),*/
              Positioned(
                left: 45,
                top: 550,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const forgetPassApp1()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.alice(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 67, 134),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
