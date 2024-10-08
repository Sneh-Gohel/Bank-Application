import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // Gives the width
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
                    255, 7, 22, 27), // Set background color to transparent
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
              bottom: 0,
              child: Container(
                height: 300,
                width: width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 61, 115, 127),
                ),
              ),
            ),
            Positioned(
              child: Text(
                'Login',
                style: GoogleFonts.lora(
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 35,
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
