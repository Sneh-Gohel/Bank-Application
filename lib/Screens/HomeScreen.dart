import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;
  String _greetingMessage = "";

  void _printGreeting() {
    final DateTime now = DateTime.now();
    final int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      _greetingMessage = 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      _greetingMessage = 'Good Afternoon!';
    } else if (hour >= 17 && hour < 21) {
      _greetingMessage = 'Good Evening!';
    } else {
      _greetingMessage = 'Good Night!';
    }
    setState(() {}); // Update the UI
  }

  @override
  void initState() {
    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    _printGreeting(); // Call this to set greeting at the start
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                          _textAnimation.value,
                          _textAnimation.value + 0.1,
                        ],
                        colors: [
                          const Color(0xFFCEC7BF),
                          const Color(0xFFCEC7BF).withOpacity(0.0),
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      _greetingMessage,
                      style: GoogleFonts.lora(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 199, 191),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AnimatedContainer(
                      height: 170,
                      width: width,
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 61, 115, 127),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -45,
                            top: -35,
                            child: Lottie.asset(
                              'assets/lotties/billAnimation.json', // Path to your Lottie file
                              width: 200, // Adjust width as needed
                              height: 200, // Adjust height as needed
                              fit: BoxFit.fill,
                              repeat:
                                  false, // Do not repeat the animation automatically
                            ),
                          ),
                          Positioned(
                            top: 25,
                            left: 20,
                            child: Text(
                              'Total Amount:',
                              style: GoogleFonts.lora(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 206, 199, 191),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 70,
                            left: 20,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.currency_rupee_sharp,
                                  size: 34,
                                  color: Color.fromARGB(255, 206, 199, 191),
                                ),
                                Text(
                                  '50,000,000',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Make the Row scrollable horizontally if needed
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildIconWithLabel(
                            'assets/lotties/creditAnimation.json',
                            'Credit',
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8)),
                          _buildIconWithLabel(
                            'assets/lotties/withdrawalAnimation.json',
                            'Withdrawal',
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8)),
                          _buildIconWithLabel(
                            'assets/lotties/historyAnimation.json',
                            'History',
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8)),
                          _buildIconWithLabel(
                            'assets/lotties/folderAnimation.json',
                            'Folder',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Text(
                      'History :',
                      style: GoogleFonts.lora(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 199, 191),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  _buildListview(
                    "Gohel Sneh",
                    "50,000",
                    Icons.call_received_outlined,
                    "10/10/2024",
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  _buildListview(
                    "Shree Krishana",
                    "30,000",
                    Icons.call_made_outlined,
                    "10/10/2024",
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  _buildListview(
                    "Shree Ram",
                    "4,000",
                    Icons.call_made_outlined,
                    "10/10/2024",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a container with a Lottie animation and a label below it
  Widget _buildIconWithLabel(String lottiePath, String label) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 70,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 7, 22, 27),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: const Color.fromARGB(255, 61, 115, 127),
            ),
          ),
          child: Center(
            child: Lottie.asset(
              lottiePath,
              width: 50, // Adjust width as needed
              height: 50, // Adjust height as needed
              fit: BoxFit.fill,
              repeat: true, // Do not repeat the animation automatically
            ),
          ),
        ),
        const SizedBox(height: 5), // Space between container and text
        SizedBox(
          width: 70, // Set a fixed width to match the container width
          child: Text(
            label,
            textAlign: TextAlign.center, // Align text in the center
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 14,
              ),
            ),
            maxLines: 2, // Limit to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
          ),
        ),
      ],
    );
  }

  Widget _buildListview(
      String name, String amount, IconData icon, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        color:
            Colors.transparent, // Transparent to see the splash color properly
        borderRadius: BorderRadius.circular(25), // Border radius for the splash
        child: InkWell(
          onTap: () {
            // Handle onTap if needed
          },
          splashColor: const Color.fromARGB(100, 61, 115, 127), // Splash color
          highlightColor: Colors.transparent, // Transparent highlight color
          borderRadius:
              BorderRadius.circular(25), // Border radius for the splash
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    const Color.fromARGB(255, 61, 115, 127), // Red border color
                width: 2, // Border width
              ),
              borderRadius: BorderRadius.circular(25), // Rounded corners
            ),
            child: ListTile(
              title: Text(
                name,
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
                    amount,
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              leading: Icon(
                icon,
                color: const Color.fromARGB(255, 206, 199, 191),
                size: 24,
              ),
              trailing: Text(
                "($date)",
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
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
