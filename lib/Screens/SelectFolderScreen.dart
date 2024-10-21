// ignore_for_file: must_be_immutable

import 'package:bank_application/Screens/SelectStudentScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectFolderScreen extends StatefulWidget {
  String label = "";
  SelectFolderScreen({required this.label, super.key});

  @override
  State<StatefulWidget> createState() => _SelectFolderScreen();
}

class _SelectFolderScreen extends State<SelectFolderScreen> {
  int folderCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 22, 27),
        elevation: 0, // Removes the shadow
        title: const Text(
          "Select Folder",
          style: TextStyle(
            color:
                Color.fromARGB(255, 61, 115, 127), // Sets the title text color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 61, 115, 127), // Sets the icon color
        ),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: const BoxDecoration(
                color: Color.fromARGB(180, 7, 22, 27),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  mainAxisSpacing: 10, // Vertical space between items
                  crossAxisSpacing: 10, // Horizontal space between items
                  childAspectRatio: 1, // Keep items square
                ),
                itemCount: folderCount,
                itemBuilder: (context, index) {
                  return Material(
                    color:
                        Colors.transparent, // Transparent background for splash
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      splashColor: const Color.fromARGB(
                          100, 61, 115, 127), // Red splash color
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                                milliseconds: 500), // Shorter duration
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SelectStudentScreen(label: widget.label),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = 0.0;
                              var end = 1.0;
                              var curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return FadeTransition(
                                opacity: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 61, 115, 127),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder,
                              size: 55,
                              color: Color.fromARGB(255, 61, 115, 127),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Folder ${index + 1}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 206, 199, 191),
                                  fontSize: 14,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
