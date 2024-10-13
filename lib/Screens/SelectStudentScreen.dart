import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SelectStudentScreen extends StatefulWidget {
  String label = "";
  SelectStudentScreen({required this.label, super.key});

  @override
  State<StatefulWidget> createState() => _SelectStudentScreen();
}

class _SelectStudentScreen extends State<SelectStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Makes the AppBar transparent
        elevation: 0, // Removes the shadow
        title: const Text(
          "All History",
          style: TextStyle(
            color:
                Color.fromARGB(255, 61, 115, 127), // Sets the title text color
            fontWeight: FontWeight.bold, // Optional: makes the text bold
            fontSize: 20, // Optional: sets the font size
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(
              255, 61, 115, 127), // Sets the icon color (e.g., back button)
        ),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: const BoxDecoration(color: Color.fromARGB(255, 7, 22, 27)),
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: widget.label,
                child: Lottie.asset(
                  widget.label == "Credit"
                      ? 'assets/lotties/creditAnimation.json'
                      : 'assets/lotties/withdrawalAnimation.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.fill,
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
