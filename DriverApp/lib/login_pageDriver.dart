import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unibeethree/screen/DriverHomePage.dart';
//import 'home_page.dart';
import 'forgetPassApp1.dart';
//import 'DriverHomePage.dart';

class LoginPageDriver extends StatefulWidget {
  const LoginPageDriver({Key? key}) : super(key: key);

  @override
  State<LoginPageDriver> createState() => _LoginPageDriverState();
}

class _LoginPageDriverState extends State<LoginPageDriver> {
//text controllers

  //final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance.collection("drivers").where('status', isEqualTo: false).snapshots();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  bool _isObscure3 = true;
  String errorMessage = '';
  bool validDriver = true;
  bool validuser = false;
  int count = 0;
  int countv = 0;
  bool errorMessage2 = false;

  void isAccepted() async {
    final QuerySnapshot<Map<String, dynamic>> readRequest =
        await FirebaseFirestore.instance
            .collection("drivers")
            .where('status', isEqualTo: false)
            .get();
    count = readRequest.size;
    for (var i = 0; i < count; i++) {
      if (_emailController.text.trim() ==
          readRequest.docs[i]['email'].toString()) {
        validDriver = false;
        //print(validDriver);
        break;
      }
    }
  }

  void isValid() async {
    final QuerySnapshot<Map<String, dynamic>> readdrivers =
        await FirebaseFirestore.instance.collection("drivers").get();
    countv = readdrivers.size;
    for (var i = 0; i < countv; i++) {
      if (_emailController.text.trim() ==
          readdrivers.docs[i]['email'].toString()) {
        validuser = true;
        //print(validDriver);
        break;
      }
    }
  }

  Future signIn() async {
    _form1Key.currentState!.validate();
    _form2Key.currentState!.validate();
    if (validDriver == false) {
      validDriver = true;
    }
    if (validuser == true) {
      validuser = false;
    }
    if (errorMessage2 == true) {
      errorMessage2 = false;
    }

    setState(() {
      isAccepted();
    });
    setState(() {
      isValid();
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

    print(validDriver);
    print(validuser);
    print(errorMessage2);
    print(count);
    print(countv);

    if (validDriver == false && errorMessage2 == false && validuser == true)
      errorMessage = "Your account is not activated, Please try again later";

    if (validDriver == true && errorMessage2 == false && validuser == false)
      errorMessage = "Your account is not a driver account";

    if (validDriver == true && errorMessage2 == false && validuser == true) {
      _emailController.clear();
      _passwordController.clear();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => DriverHomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
    // Navigator.pushNamed(context, 'home');
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => DriverHomePage()));
    else
      Navigator.of(context).pop();

    setState(() {});
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
                left: 48,
                top: 360,
                child: Text(
                  "Email",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),

              //password text
              Positioned(
                left: 48,
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Form(
                          key: _form1Key,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            maxLength: 30,
                            controller: _emailController,

                            decoration: InputDecoration(
                              counterText: " ",
                              border: InputBorder.none,
                              hintText: ' Enter your Email',
                              contentPadding: EdgeInsets.only(left: 20.0),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Form(
                          key: _form2Key,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            maxLength: 15,

                            controller: _passwordController,

                            obscureText: _isObscure3,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: ' Enter your Password',
                              contentPadding:
                                  EdgeInsets.only(left: 20.0, top: 20.0),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
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
                    ),

                    SizedBox(height: 60),

                    // error message

                    Container(
                        child: (Center(
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.alice(
                          fontSize: 15,
                          color: Color.fromARGB(255, 215, 1, 1),
                        ),
                      ),
                    ))),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90.0),
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.alice(
                                fontSize: 30, color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff204854))),
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              signIn();
                            }
                          },
                        ),
                      ),
                    ),

                    //////////////////////////////////////
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 25, top: 50),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/back.png')),
              ),

              Positioned(
                left: 45,
                top: 550,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'forget');
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const forgetPassApp1()));
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
