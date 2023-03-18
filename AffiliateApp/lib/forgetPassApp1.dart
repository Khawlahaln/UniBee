import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class forgetPassApp1 extends StatefulWidget {
  const forgetPassApp1({super.key});

  @override
  State<forgetPassApp1> createState() => _forgetPassApp1State();
}

class _forgetPassApp1State extends State<forgetPassApp1> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String errorMessage = "";
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        title: 'Password reset link sent! Check your email',
        btnOkOnPress: () {},
      ).show();
      _emailController.clear();
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());

      if (e.code.toString() == "invalid-email")
        errorMessage = "";
      else
        errorMessage = e.message.toString();

      // if (e.code.toString() == "missing-email")
      //   errorMessage = "An email address must be provided.";
      // if (e.code.toString() == "user-not-found")
      //   errorMessage = "An email address must be provided.";

      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       content: Text(e.message.toString()),
      //     );
      //   },
      // );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 850,
          child: Stack(
            children: [
              // yellow
              Positioned(
                  top: 0, right: 0, child: Image.asset('assets/yellow4.png')),
              //green bottom
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset('assets/green3.png'),
              ),

              //pink bottom
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset('assets/pinkBottom.png'),
              ),
              //bee bottom
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset('assets/bee3.png'),
              ),

              //Welcome Back! text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 200),
                child: Text(
                  'Forgot password?',
                  style:
                      GoogleFonts.alice(fontSize: 40, color: Color(0xff204854)),
                ),
              ),
              ////
              Positioned(
                left: 57,
                top: 360,
                child: Text(
                  "Email",
                  style:
                      GoogleFonts.alice(fontSize: 20, color: Color(0xff204854)),
                ),
              ),
              // //Email textfield

              Column(children: [
                //E-mail textfield
                SizedBox(
                  height: 400,
                ),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        maxLength: 30,
                        controller: _emailController,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: ' E-mail',
                          contentPadding: EdgeInsets.only(left: 20.0),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return " Please Enter your E-mail ";
                          } else if (!value.contains("@") ||
                              !value.contains(".")) {
                            return "please enter correct E-mail";
                          } else if (value.contains(' ')) {
                            return "spaces not allowed";
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ]),

              Center(
                child: Container(
                  width: 350,
                  child: errorMessage == "An email address must be provided."
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 90,
                            left: 55,
                          ),
                          child: Text(
                            errorMessage,
                            style: GoogleFonts.alice(
                              fontSize: 15,
                              color: Color.fromARGB(255, 215, 1, 1),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 110,
                            left: 30,
                          ),
                          child: Text(
                            errorMessage,
                            style: GoogleFonts.alice(
                              fontSize: 15,
                              color: Color.fromARGB(255, 215, 1, 1),
                            ),
                          ),
                        ),
                ),
              ),
              //on tap
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 520, left: 95),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        child: Text(
                          'Reset password',
                          style: GoogleFonts.alice(
                              fontSize: 20, color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff204854))),
                        onPressed: () {
                          passwordReset();
                          setState(() {});
                        }),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
