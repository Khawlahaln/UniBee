import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unibeethree/appwelcome.dart';

import 'login_pageDriver.dart';

class SignupPageDriver extends StatefulWidget {
  const SignupPageDriver({Key? key}) : super(key: key);

  @override
  State<SignupPageDriver> createState() => _SignupPageDriverState();
}

class _SignupPageDriverState extends State<SignupPageDriver> {
//text controllers
  final _firstnameDController = TextEditingController();
  final _lastnameDController = TextEditingController();
  final _phonenumberDController = TextEditingController();
  final _emailDController = TextEditingController();
  final _passwordDController = TextEditingController();
  final _confirmpasswordDController = TextEditingController();
  final _GolfCarIDController = TextEditingController();
  bool _isObscure3 = true;
  bool _isObscure2 = true;
  final formKey = GlobalKey<FormState>();
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  final _form3Key = GlobalKey<FormState>();
  final _form4Key = GlobalKey<FormState>();
  final _form5Key = GlobalKey<FormState>();
  final _form6Key = GlobalKey<FormState>();
  final _form7Key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String errorMessage = '';
  bool status = false;
  bool _trueva = true;

  Future signUpD() async {
    try {
      if (passwordConfirm()) {
        await _auth.createUserWithEmailAndPassword(
          email: _emailDController.text.trim(),
          password: _passwordDController.text.trim(),
        );
        setState(() {});
        // add user infromation
        adduserdetails(
          _firstnameDController.text.trim(),
          _lastnameDController.text.trim(),
          int.parse(_phonenumberDController.text.trim()),
          int.parse(_passwordDController.text.trim()),
          _emailDController.text.trim(),
          _GolfCarIDController.text.trim(),
          status,
        );
      }
      return HomePageopegDriver();
    } on FirebaseAuthException catch (error) {
      if (_form3Key.currentState!.validate())
        errorMessage = "The email you enter already exists";
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE')
        print('The email you enter already exists');
    }
    setState(() {});
  }

  Future adduserdetails(String firstname, String lastname, int phone, int Pass,
      String email, String GolfCarId, bool status) async {
    await FirebaseFirestore.instance.collection('drivers').add({
      'first name': firstname,
      'last name': lastname,
      'phone': phone,
      'password': Pass.toString(),
      'email': email,
      'GolfCarId': GolfCarId,
      'status': status,
      'avgRate': 0.0,
      'numOfRates': 0.0
    });
  }

  bool passwordConfirm() {
    if (formKey.currentState!.validate()) {
      _form1Key.currentState!.validate();
      _form2Key.currentState!.validate();
      _form3Key.currentState!.validate();
      _form4Key.currentState!.validate();
      _form5Key.currentState!.validate();
      _form6Key.currentState!.validate();
      _form7Key.currentState!.validate();

      return true;
    } else {
      return false;
    }
  }

  void HomePageopegDriver() {
    Navigator.pushNamed(context, 'signin');
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => LoginPageDriver()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstnameDController.dispose();
    _lastnameDController.dispose();
    _phonenumberDController.dispose();
    _emailDController.dispose();
    _passwordDController.dispose();
    _confirmpasswordDController.dispose();
    _GolfCarIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: 850,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                //2) yellow
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Image.asset('assets/yellow3.png')),

                //3) green
                Positioned(
                    left: 0, top: 0, child: Image.asset('assets/green2.png')),

                //4) bee
                Positioned(
                    right: 0, top: 0, child: Image.asset('assets/bee2.png')),

                //5) pink
                Positioned(
                    left: 0, bottom: 0, child: Image.asset('assets/pink2.png')),

                // sign up
                Positioned(
                  left: 130,
                  top: 90,
                  child: Text(
                    "SIGN UP",
                    style: GoogleFonts.alice(
                        fontSize: 30, color: Color(0xff204854)),
                  ),
                ),

                //Firstname text
                Positioned(
                  left: 65,
                  top: 150,
                  child: Text(
                    "First Name",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 168,
                  top: 155,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //Lastname text
                Positioned(
                  left: 65,
                  top: 240,
                  child: Text(
                    "Last Name ",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 165,
                  top: 245,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //Email text
                Positioned(
                  left: 65,
                  top: 325,
                  child: Text(
                    "E-mail",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 130,
                  top: 330,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //phone text
                Positioned(
                  left: 65,
                  top: 405,
                  child: Text(
                    "phone number",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 205,
                  top: 410,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //Password text
                Positioned(
                  left: 65,
                  top: 485,
                  child: Text(
                    "Password",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 160,
                  top: 490,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //confirm password
                Positioned(
                  left: 65,
                  top: 565,
                  child: Text(
                    "Confirm Password",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 240,
                  top: 570,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //ID text
                Positioned(
                  left: 65,
                  top: 645,
                  child: Text(
                    "Golf Car ID",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 170,
                  top: 650,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                // TextField //

                Container(
                  child: Column(
                    children: [
                      //top space
                      SizedBox(
                        height: 180,
                      ),

                      //Firstname textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 55,
                        ),
                        child: Container(
                          height: 50,
                          width: 2000,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(161, 224, 224, 224),
                            border: Border.all(
                                color: Color.fromARGB(112, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _form1Key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              maxLength: 10,
                              controller: _firstnameDController,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: ' First name',
                                contentPadding: EdgeInsets.only(left: 20.0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return " Please Enter your First Name ";
                                } else if (!RegExp(r'[a-z A-Z]+$')
                                    .hasMatch(value!)) {
                                  return "please use letters";
                                } else if (value.contains(' ')) {
                                  return "spaces not allowed";
                                } else if (value.length > 10) {
                                  return "your first name must be less than 10 Letters";
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //Lastname textfield
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: Container(
                          height: 50,
                          width: 2000,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(161, 224, 224, 224),
                            border: Border.all(
                                color: Color.fromARGB(112, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _form2Key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              maxLength: 10,
                              controller: _lastnameDController,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: ' Last name',
                                contentPadding: EdgeInsets.only(left: 20.0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return " Please Enter your Last Name ";
                                } else if (!RegExp(r'[a-z A-Z]+$')
                                    .hasMatch(value!)) {
                                  return "please use letters";
                                } else if (value.contains(' ')) {
                                  return "spaces not allowed";
                                } else if (value.length > 10) {
                                  return "your last name must be less than 10 Letters";
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //E-mail textfield
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: Container(
                          height: 50,
                          width: 2000,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(161, 224, 224, 224),
                            border: Border.all(
                                color: Color.fromARGB(112, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _form3Key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              autofocus: true,
                              maxLength: 30,
                              controller: _emailDController,
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

                      //phonenumber textfield
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: Container(
                          height: 50,
                          width: 2000,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(161, 224, 224, 224),
                            border: Border.all(
                                color: Color.fromARGB(112, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _form4Key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              maxLength: 15,
                              controller: _phonenumberDController,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: ' Phone number',
                                contentPadding: EdgeInsets.only(left: 20.0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return " Please Enter your Phone number ";
                                } else if (!RegExp(
                                        r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$')
                                    .hasMatch(value!)) {
                                  return "please enter correct Phone number";
                                } else if (value.contains(' ')) {
                                  return "spaces not allowed";
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //Password textfield
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 55.0,
                        ),
                        child: Container(
                          height: 50,
                          width: 2000,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(161, 224, 224, 224),
                            border: Border.all(
                                color: Color.fromARGB(112, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _form5Key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              maxLength: 15,
                              controller: _passwordDController,
                              obscureText: _isObscure3,
                              decoration: InputDecoration(
                                counterText: " ",
                                border: InputBorder.none,
                                hintText: ' Password',
                                // contentPadding: EdgeInsets.only(left: 20.0),
                                contentPadding:
                                    EdgeInsets.only(left: 20.0, top: 30),

                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure3
                                        ? Icons.visibility_off
                                        : Icons.visibility),
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
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return " Please Enter your Password ";
                                } else if (value.length < 8) {
                                  return "password lengt must be 8 or more";
                                } else if (value.contains(' ')) {
                                  return "spaces not allowed";
                                } else if (value.length > 15) {
                                  return "your password must be less than 15 ";
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //confirm password
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: Container(
                          height: 50,
                          width: 2000,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(161, 224, 224, 224),
                            border: Border.all(
                                color: Color.fromARGB(112, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _form6Key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              maxLength: 15,
                              controller: _confirmpasswordDController,
                              obscureText: _isObscure2,
                              decoration: InputDecoration(
                                counterText: " ",
                                border: InputBorder.none,
                                hintText: ' Confirm Password',
                                // contentPadding: EdgeInsets.only(left: 20.0),
                                contentPadding:
                                    EdgeInsets.only(left: 20.0, top: 30),
                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure2
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure2 = !_isObscure2;
                                      });
                                    }),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return " Please confirm your password ";
                                } else if (value != _passwordDController.text) {
                                  return "password mismatch !";
                                } else if (value.contains(' ')) {
                                  return "spaces not allowed";
                                } else if (value.length > 15) {
                                  return "your password must be less than 15 ";
                                } else if (value.length < 8) {
                                  return "password lengt must be 8 or more";
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //ID textfiled
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 55,
                        ),
                        child: Container(
                          height: 50,
                          width: 2000,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(161, 224, 224, 224),
                            border: Border.all(
                                color: Color.fromARGB(112, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _form7Key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              maxLength: 4,
                              controller: _GolfCarIDController,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: ' Golf Car ID',
                                contentPadding: EdgeInsets.only(left: 20.0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty || value == null) {
                                  return " Please enter Golf Car ID ";
                                } else if (!RegExp(r'[0-9]').hasMatch(value!)) {
                                  return "please use numbers";
                                } else if (value.contains(' ')) {
                                  return "spaces not allowed";
                                } else if (value.length < 4 ||
                                    value.length > 4) {
                                  return "Golf Car ID must be 4 numbers ";
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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

                      //Sign Up button
                      SizedBox(height: 5),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          child: Text('Sign Up',
                              style: GoogleFonts.alice(
                                fontSize: 30,
                              )),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff204854),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              signUpD();
                            }
                            setState(() {});
                          },
                        ),
                      ),
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
              ],
            ),
          )),
    ));
  }
}
