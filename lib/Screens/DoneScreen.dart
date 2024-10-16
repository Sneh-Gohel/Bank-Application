import 'package:bank_application/Screens/HomeScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context)
            .pushReplacement(FadeSlideTransition(page: const HomeScreen()));
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
        child: Center(
          child: Lottie.asset(
            'assets/lotties/doneAnimation.json',
            width: 300,
            height: 275,
            fit: BoxFit.fill,
            repeat: false, // Prevent automatic looping
            controller: _controller, // Attach the animation controller
            onLoaded: (composition) {
              // Set the animation duration based on the Lottie composition
              _controller.duration = composition.duration;
              // Start the animation when it's loaded
              _controller.forward();
            },
          ),
        ),
      ),
    );
  }
}
