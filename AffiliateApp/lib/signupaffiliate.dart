import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unibeethree/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
//text controllers
  final _firstnameController = TextEditingController();
  final _lasttnameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  bool _isObscure3 = true;
  bool _isObscure2 = true;

  final formKey = GlobalKey<FormState>();
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  final _form3Key = GlobalKey<FormState>();
  final _form4Key = GlobalKey<FormState>();
  final _form5Key = GlobalKey<FormState>();
  final _form6Key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String errorMessage = '';

  Future signUp() async {
    try {
      if (passwordConfirm()) {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        setState(() {});
        // add user infromation
        adduserdetails(
          _firstnameController.text.trim(),
          _lasttnameController.text.trim(),
          int.parse(_phonenumberController.text.trim()),
          _emailController.text.trim(),
          int.parse(_passwordController.text.trim()),
        );
      }
      return HomePageopeg();
    } on FirebaseAuthException catch (error) {
      print(error.code);
      if (_form3Key.currentState!.validate())
        errorMessage = "The email you enter already exists";
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        print('The email you enter already exists');
      }
    }
    setState(() {});
  }

  Future adduserdetails(String firstname, String lastname, int phone,
      String email, int Pass) async {
    await FirebaseFirestore.instance.collection('user affiliate').add({
      'first name': firstname,
      'last name': lastname,
      'password': Pass.toString(),
      'phone': phone,
      'email': email,
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
      return true;
    }

    return false;
  }

  void HomePageopeg() {
    Navigator.pushNamed(context, 'signin');
    // Navigator.of(context)
    //     .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstnameController.dispose();
    _lasttnameController.dispose();
    _phonenumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
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
                // sign up
                Positioned(
                  left: 130,
                  top: 110,
                  child: Text(
                    "SIGN UP",
                    style: GoogleFonts.alice(
                        fontSize: 30, color: Color(0xff204854)),
                  ),
                ),
                //images:

                // //1) yellow
                // Positioned(
                //     right: 0, top: 0, child: Image.asset('assets/yellow2.png')),

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

                // //6)back

                // Positioned(
                //     left: 30, top: 40, child: Image.asset('assets/back.png')),

                //Firstname text
                Positioned(
                  left: 65,
                  top: 170,
                  child: Text(
                    "First Name",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 168,
                  top: 175,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //Lastname text
                Positioned(
                  left: 65,
                  top: 265,
                  child: Text(
                    "Last Name ",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 165,
                  top: 270,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //Email text
                Positioned(
                  left: 65,
                  top: 345,
                  child: Text(
                    "E-mail",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 130,
                  top: 350,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //phone text
                Positioned(
                  left: 65,
                  top: 425,
                  child: Text(
                    "phone number",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 205,
                  top: 430,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //Password text
                Positioned(
                  left: 65,
                  top: 505,
                  child: Text(
                    "Password",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 160,
                  top: 510,
                  child: Text(
                    "*",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color.fromARGB(255, 187, 3, 3)),
                  ),
                ),

                //confirm password
                Positioned(
                  left: 65,
                  top: 585,
                  child: Text(
                    "Confirm Password",
                    style: GoogleFonts.alice(
                        fontSize: 20, color: Color(0xff204854)),
                  ),
                ),
                //requierd
                Positioned(
                  left: 240,
                  top: 590,
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
                        height: 120,
                      ),

                      SizedBox(
                        height: 80,
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
                              controller: _firstnameController,
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
                              controller: _lasttnameController,
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
                              controller: _phonenumberController,
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
                              controller: _passwordController,
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
                              controller: _confirmpasswordController,
                              obscureText: _isObscure2,
                              decoration: InputDecoration(
                                counterText: " ",
                                border: InputBorder.none,
                                hintText: ' Confirm Password',
                                contentPadding:
                                    EdgeInsets.only(left: 20.0, top: 30),
                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
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
                                } else if (value != _passwordController.text) {
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
                      SizedBox(height: 40),

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
                                Color(0xff204854)),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              signUp();
                            }
                            setState(() {});
                          },
                        ),
                      ),
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
              ],
            ),
          )),
    ));
  }
}
