import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bank_application/Screens/AllFoldersList.dart';
import 'package:bank_application/Screens/AllHistoryScreen.dart';
import 'package:bank_application/Screens/SelectFolderScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  double amount = 0;
  List<Map<String, dynamic>> transactionHistory = [];
  bool loadingScreen = false;

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

  Future<void> getData() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // get the amount...
    try {
      setState(() {
        loadingScreen = true;
      });
      try {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('AllHistory')
            .doc('TotalAmount')
            .get();
        var data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          amount = double.parse(data['Amount'].toString());
        });
      } catch (e) {
        print("Getting error : $e");
        const snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Gettting error to fetch the total amount.',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }

      try {
        // get the quick history data.
        List<Map<String, dynamic>> quickHistoryScreen = [];
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('QuickHistory').get();
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Add both the document data and its ID to the map
          data['docId'] = doc.id; // Store document ID in the data map
          quickHistoryScreen.add(data); // Add the entire map to the list
        }

        setState(() {
          transactionHistory =
              quickHistoryScreen; // Store all documents' data in the list
        });
      } catch (e) {
        print("getting error : $e");
        const snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Getting error to fetch the recent transactions.',
            contentType: ContentType.warning,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      print("Getting error : $e");
    } finally {
      setState(() {
        loadingScreen = false;
      });
    }
  }

  void _quickButtonClick(String label) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            const Duration(milliseconds: 500), // Shorter duration
        pageBuilder: (context, animation, secondaryAnimation) =>
            label == "Credit" || label == "Withdraw"
                ? SelectFolderScreen(
                    label: label,
                  )
                : label == "History"
                    ? const AllHistoryScreen()
                    : AllFoldersList(
                        label: label,
                      ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = 0.0;
          var end = 1.0;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _refreshPage() async {
    await getData();
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: loadingScreen
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 7, 22, 27),
                ),
                child: Center(
                  child: LoadingAnimationWidget.hexagonDots(
                    color: const Color.fromARGB(255, 61, 115, 127),
                    size: 35,
                  ),
                ),
              )
            : Container(
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
                              width: double.infinity,
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
                                      'assets/lotties/billAnimation.json',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.fill,
                                      repeat: false,
                                    ),
                                  ),
                                  Positioned(
                                    top: 25,
                                    left: 20,
                                    child: Text(
                                      'Total Amount:',
                                      style: GoogleFonts.lora(
                                        textStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 206, 199, 191),
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
                                          color: Color.fromARGB(
                                              255, 206, 199, 191),
                                        ),
                                        Text(
                                          amount.toString(),
                                          style: GoogleFonts.lora(
                                            textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 206, 199, 191),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 30),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildIconWithLabel(
                                      'assets/lotties/creditAnimation.json',
                                      'Credit'),
                                  SizedBox(width: (width - 330) / 4),
                                  _buildIconWithLabel(
                                      'assets/lotties/withdrawalAnimation.json',
                                      'Withdraw'),
                                  SizedBox(width: (width - 330) / 4),
                                  _buildIconWithLabel(
                                      'assets/lotties/historyAnimation.json',
                                      'History'),
                                  SizedBox(width: (width - 330) / 4),
                                  _buildIconWithLabel(
                                      'assets/lotties/folderAnimation.json',
                                      'Folder'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Text(
                              'History:',
                              style: GoogleFonts.lora(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 206, 199, 191),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          // Wrap ListView.builder in a SizedBox or use shrinkWrap: true
                          transactionHistory.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                    child: Text(
                                      'No Recent Transactions.',
                                      style: GoogleFonts.lora(
                                        textStyle: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 61, 115, 127),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      300, // Adjust the height as per your layout
                                  child: ListView.builder(
                                    itemCount: transactionHistory.length,
                                    shrinkWrap: true, // Prevents layout issues
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Disable scrolling inside the ListView
                                    itemBuilder: (context, index) {
                                      return _buildListview(
                                        transactionHistory[index]['name'],
                                        transactionHistory[index]['amount'],
                                        transactionHistory[index]
                                                    ['transaction'] ==
                                                "credit"
                                            ? Icons.call_received_outlined
                                            : Icons.call_made_outlined,
                                        transactionHistory[index]['date']
                                            .toString(),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Helper method to create a container with a Lottie animation and a label below it
  Widget _buildIconWithLabel(String lottiePath, String label) {
    return GestureDetector(
      onTap: () {
        _quickButtonClick(label);
      },
      child: Column(
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
              child: Hero(
                tag: label,
                child: Lottie.asset(
                  lottiePath,
                  width: 50, // Adjust width as needed
                  height: 50, // Adjust height as needed
                  fit: BoxFit.fill,
                  repeat: true, // Do not repeat the animation automatically
                ),
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
              overflow:
                  TextOverflow.ellipsis, // Add ellipsis if text is too long
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListview(
      String name, String amount, IconData icon, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                color: const Color.fromARGB(255, 61, 115, 127),
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
