// ignore: file_names
import 'package:bank_application/Screens/LoginScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplahScreen();
}

class _SplahScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String userId = "";
  String password = "";

  Future<void> _readFileAndStopAnimation() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user.text';
      final file = File(filePath);

      if (await file.exists()) {
        String fileContent = await file.readAsString();
        List<String> splitStrings = fileContent.split(" ");
        userId = splitStrings[0];
        password = splitStrings[1];

        print("Done");
      } else {
        print("File not found");
        Navigator.of(context)
            .push(FadeSlideTransition(page: const LoginScreen()));
      }
    } catch (e) {
      print("Error reading file: $e");
    } finally {
      setState(() {
        _controller.stop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Add a listener to detect when the animation completes one loop
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readFileAndStopAnimation(); // After one loop, check for the file and stop animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(
            255, 7, 22, 27), // Set background color to transparent
        child: Center(
          child: Lottie.asset(
            'assets/lotties/splashScreen.json', // Path to your Lottie file
            width: 225, // Adjust width as needed
            height: 200, // Adjust height as needed
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward(); // Start the animation
            },
            fit: BoxFit.fill,
            repeat: false, // Do not repeat the animation automatically
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when no longer needed
    super.dispose();
  }
}
