import 'package:bank_application/Screens/HomeScreen.dart';
import 'package:bank_application/components/CustomTextField.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final user_id_Controller = TextEditingController();
  final password_Controller = TextEditingController();
  var show_password_bool = true;
  final user_id = FocusNode();
  final password = FocusNode();

  loginClick() {
    Navigator.of(context).push(FadeSlideTransition(page: const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; 
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: 600,
                color: const Color.fromARGB(
                    255, 7, 22, 27),
                child: Center(
                  child: Lottie.asset(
                    'assets/lotties/loginAnimation.json', // Path to your Lottie file
                    width: 200, // Adjust width as needed
                    height: 200, // Adjust height as needed
                    fit: BoxFit.fill,
                    repeat: true, // Do not repeat the animation automatically
                  ),
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  height: 100,
                  width: width,
                  child: Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.lora(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 199, 191),
                          fontSize: 75,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  height: 450,
                  width: width - 10,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 61, 115, 127),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  child: ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Enter Username : ',
                          style: GoogleFonts.lora(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 206, 199, 191),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: user_id_Controller,
                        focusNode: user_id,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "User Name",
                        prefixIcon: Icons.person,
                        onSuffixTap: () {
                          user_id_Controller.clear();
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Enter Password : ',
                          style: GoogleFonts.lora(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 206, 199, 191),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: password_Controller,
                        focusNode: password,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Password",
                        prefixIcon: Icons.key,
                        obscureText: show_password_bool,
                        showSuffixIcon: true,
                        showPassword: show_password_bool,
                        onSuffixTap: () {
                          setState(() {
                            show_password_bool = !show_password_bool;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50, horizontal: 110),
                        child: ElevatedButton(
                          onPressed: () {
                            loginClick();
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            backgroundColor: const Color(0xFFCEC7BF),
                            shape: const StadiumBorder(),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(
                                      255, 61, 115, 127),),
                            ),
                          ),
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
    );
  }
}
