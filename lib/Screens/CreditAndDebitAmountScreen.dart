// ignore_for_file: non_constant_identifier_names

import 'package:bank_application/Screens/DoneScreen.dart';
import 'package:bank_application/components/CustomTextField.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CreditAndDebitAmountScreen extends StatefulWidget {
  String label;
  CreditAndDebitAmountScreen({required this.label, super.key});

  @override
  State<StatefulWidget> createState() => _CreditAndDebitAmountScreen();
}

class _CreditAndDebitAmountScreen extends State<CreditAndDebitAmountScreen> {
  final name_Controller = TextEditingController();
  final amount_Controller = TextEditingController();
  final remarks_Controller = TextEditingController();
  final name = FocusNode();
  final amount = FocusNode();
  final remark = FocusNode();

  Future<void> creditClick() async {
    Navigator.of(context).push(FadeSlideTransition(page: const DoneScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 61, 115, 127),
        ),
      ),
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
                color: const Color.fromARGB(255, 7, 22, 27),
                child: Center(
                  child: Lottie.asset(
                    'assets/lotties/creditScreenAnumation.json', // Path to your Lottie file
                    width: width, // Adjust width as needed
                    height: 300, // Adjust height as needed
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
                  height: 150,
                  width: width,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      widget.label,
                      style: GoogleFonts.lora(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 199, 191),
                          fontSize: 75,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Student Name : ',
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
                        controller: name_Controller,
                        focusNode: name,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Student Name",
                        prefixIcon: Icons.person,
                        onSuffixTap: () {
                          name_Controller.clear();
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Enter Amount : ',
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
                        controller: amount_Controller,
                        focusNode: amount,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Amount",
                        prefixIcon: Icons.currency_rupee_outlined,
                        // obscureText: show_password_bool,
                        showSuffixIcon: false,
                        // showPassword: show_password_bool,
                        onSuffixTap: () {
                          setState(() {
                            remarks_Controller.clear();
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Enter Remarks : ',
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
                        controller: remarks_Controller,
                        focusNode: remark,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Remarks",
                        prefixIcon: Icons.text_fields_outlined,
                        showSuffixIcon: false,
                        onSuffixTap: () {
                          setState(() {
                            remarks_Controller.clear();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50, horizontal: 90),
                        child: ElevatedButton(
                          onPressed: () {
                            creditClick();
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            backgroundColor: const Color(0xFFCEC7BF),
                            shape: const StadiumBorder(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              widget.label,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color.fromARGB(255, 61, 115, 127),
                              ),
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
