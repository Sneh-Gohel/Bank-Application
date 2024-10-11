import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AllHistoryScreen extends StatefulWidget {
  const AllHistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllHistoryScreen();
}

class _AllHistoryScreen extends State<AllHistoryScreen> {
  bool loadingScreen = true;
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'History',
                child: Lottie.asset(
                  'assets/lotties/historyAnimation.json',
                  width: 250, // Adjust width as needed
                  height: 250, // Adjust height as needed
                  fit: BoxFit.fill,
                  repeat: true, // Do not repeat the animation automatically
                ),
              ),
            ),
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(180, 7, 22, 27)),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Material(
                      color: Colors
                          .transparent, // Transparent to see the splash color properly
                      borderRadius: BorderRadius.circular(
                          25), // Border radius for the splash
                      child: InkWell(
                        onTap: () {
                          // Handle onTap if needed
                        },
                        splashColor: const Color.fromARGB(
                            100, 61, 115, 127), // Splash color
                        highlightColor:
                            Colors.transparent, // Transparent highlight color
                        borderRadius: BorderRadius.circular(
                            25), // Border radius for the splash
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 61, 115, 127), // Red border color
                              width: 2, // Border width
                            ),
                            borderRadius:
                                BorderRadius.circular(25), // Rounded corners
                          ),
                          child: ListTile(
                            title: Text(
                              "Gohel Sneh",
                              style: GoogleFonts.lora(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 206, 199, 191),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.currency_rupee_sharp,
                                  color: Color.fromARGB(255, 206, 199, 191),
                                ),
                                Text(
                                  "50,000",
                                  style: GoogleFonts.lora(
                                    textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 206, 199, 191),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            leading: Lottie.asset(
                              'assets/lotties/creditAnimation.json',
                              width: 50, // Adjust width as needed
                              height: 50, // Adjust height as needed
                              fit: BoxFit.fill,
                              repeat:
                                  true,
                            ),
                            trailing: Text(
                              "(10/10/2024)",
                              style: GoogleFonts.lora(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 61, 115, 127),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
