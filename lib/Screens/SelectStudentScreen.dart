// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:bank_application/Screens/CreditAndDebitAmountScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Select student",
          style: TextStyle(
            color: Color.fromARGB(255, 61, 115, 127),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 61, 115, 127),
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
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 0, // Ensures that the content takes up available space
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration:
                    const BoxDecoration(color: Color.fromARGB(180, 7, 22, 27)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    // Fix: Wrap ListView inside SingleChildScrollView or give ListView a fixed height
                    child: Column(
                      children: [
                        CustomListView(width, true, context,widget.label),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        CustomListView(width, false, context,widget.label),
                      ],
                    ),
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

Widget CustomListView(double width, bool isMan, context,String label) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context)
          .push(FadeSlideTransition(page: CreditAndDebitAmountScreen(label: label)));
    },
    child: Container(
      width: width - 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 61, 115, 127),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          SizedBox(
            width: (width - 40) / 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Sneh Bharatbhai Gohel",
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 24,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.currency_rupee_sharp,
                        size: 34,
                        color: Color.fromARGB(255, 206, 199, 191),
                      ),
                      Text(
                        '75,000',
                        style: GoogleFonts.lora(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 206, 199, 191),
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Lottie.asset(
              isMan
                  ? 'assets/lotties/manAnimation.json'
                  : 'assets/lotties/womanAnimation.json',
              width: (width - 40) / 2,
              height: (width - 40) / 2,
              fit: BoxFit.fill,
              repeat: true,
            ),
          ),
        ],
      ),
    ),
  );
}
