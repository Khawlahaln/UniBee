import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unibeethree/login_page.dart';
import 'package:unibeethree/signupaffiliate.dart';

class appwelcome extends StatefulWidget {
  //this comment for linking
  //final VoidCallback showDriverRegisterPage;
  //final VoidCallback showAffiliateRegisterPage;
  //final VoidCallback showLoginPage;
  //const webwelcome({Key? key, required this.showRegisterPage}) : super(key: key);???
  const appwelcome({super.key}); // i will deleate after linking

  @override
  State<appwelcome> createState() => _appwelcomeState();
}

class _appwelcomeState extends State<appwelcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 500,
          height: 850,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Stack(
                      children: [
                        // yellow
                        Positioned(
                            top: 60, child: Image.asset('assets/yellow6.png')),

                        //pink
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset('assets/pink.png')),

                        //green
                        Positioned(
                            left: 6,
                            bottom: 0,
                            child: Image.asset('assets/green6.png')),

                        //golf car
                        Positioned(
                          left: 10,
                          top: 150,
                          child: Image.asset('assets/GOLFCAR_welcomepage.png'),
                        ),

                        Positioned.fill(
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 230,
                                left: 90,
                                child: SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: ElevatedButton(
                                      child: Text(
                                        'Sign Up',
                                        style: GoogleFonts.alice(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xff204854))),
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'signup');
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           const SignupPage()),
                                        // );
                                      }),
                                ),
                                // child: SizedBox(
                                //   width: 207.75,
                                //   height: 45,
                                //   child: ElevatedButton(
                                //       onPressed: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   const LoginPage()),
                                //         );
                                //       },
                                //       child: Text(
                                //         'Sign Up',
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 20,
                                //         ),
                                //       ),
                                //       style: ButtonStyle(
                                //         shape: MaterialStateProperty.all<
                                //             RoundedRectangleBorder>(
                                //           RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(30.0),
                                //           ),
                                //         ),
                                //         backgroundColor:
                                //             MaterialStateProperty.all<Color>(
                                //                 Color(0xff1e4845)),
                                //       )),
                                // ),
                              ),
                              Padding(
                                // left: 90,
                                // bottom: 310,
                                padding: EdgeInsets.only(left: 70, top: 500),
                                child: SizedBox(
                                  child: Text(
                                    "let’s make your life easier",
                                    style: TextStyle(
                                        color: Color(0xffeb9880),
                                        fontSize: 35,
                                        fontFamily: 'Cookie'),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 45,
                                bottom: 190,
                                child: Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 180, 185, 127),
                                    fontFamily: 'Alice',
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 245,
                                bottom: 177,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'signin');
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           const LoginPage()),
                                    // );
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff1e4845),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Alice',
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
