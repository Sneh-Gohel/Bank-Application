import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bank_application/Screens/HistoryDetailsScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AllHistoryScreen extends StatefulWidget {
  const AllHistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllHistoryScreen();
}

class _AllHistoryScreen extends State<AllHistoryScreen> {
  bool loadingScreen = false;
  List<Map<String, dynamic>> historyData = [];

  Future<void> getData() async {
    setState(() {
      loadingScreen = true;
    });

    try {
      // Fetch all documents in the 'AllHistory' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('AllHistory')
          .orderBy('date', descending: true)
          .get();

      // Initialize an empty list to hold all student details
      List<Map<String, dynamic>> studentDetailsList = [];

      // Create a DateFormat instance for 'dd/MM/yyyy'
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');

      // Loop through all the documents in the collection
      for (var doc in querySnapshot.docs) {
        if (doc.id == 'TotalAmount') {
          continue; // Skip this document
        }

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Ensure 'date' field exists and is of type Timestamp
        if (data['date'] is Timestamp) {
          Timestamp timestamp = data['date'];
          DateTime dateTime = timestamp.toDate();
          data['date'] = dateFormat.format(dateTime); // Format the date
        } else {
          // Handle unexpected format if needed (optional)
          data['date'] = 'Invalid Date';
        }

        // Add both the document data and its ID to the map
        data['docId'] = doc.id; // Store document ID in the data map
        studentDetailsList.add(data); // Add the entire map to the list
      }

      // After collecting all documents, store the data in the historyData list
      setState(() {
        historyData = studentDetailsList;
      });
    } catch (e) {
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'Getting error in fetching the history.',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      setState(() {
        historyData = []; // Handle any errors by setting an empty list
      });
    } finally {
      setState(() {
        loadingScreen = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

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
            RefreshIndicator(
              onRefresh: () async {
                await getData();
              },
              child: loadingScreen
                  ? const Center()
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(180, 7, 22, 27)),
                      child: ListView.builder(
                        itemCount: historyData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            child: Material(
                              color: Colors
                                  .transparent, // Transparent to see the splash color properly
                              borderRadius: BorderRadius.circular(
                                  25), // Border radius for the splash
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    FadeSlideTransition(
                                      page: HistoryDetailsScreen(
                                        HistoryData: historyData[index],
                                      ),
                                    ),
                                  );
                                },
                                splashColor: const Color.fromARGB(
                                    100, 61, 115, 127), // Splash color
                                highlightColor: Colors
                                    .transparent, // Transparent highlight color
                                borderRadius: BorderRadius.circular(
                                    25), // Border radius for the splash
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 61, 115,
                                          127), // Red border color
                                      width: 2, // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        25), // Rounded corners
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      historyData[index]['name'],
                                      style: GoogleFonts.lora(
                                        textStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 206, 199, 191),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        const Icon(
                                          Icons.currency_rupee_sharp,
                                          color: Color.fromARGB(
                                              255, 206, 199, 191),
                                        ),
                                        Text(
                                          historyData[index]['amount'],
                                          style: GoogleFonts.lora(
                                            textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 206, 199, 191),
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    leading: Lottie.asset(
                                      historyData[index]['transaction'] ==
                                              "credit"
                                          ? 'assets/lotties/creditAnimation.json'
                                          : 'assets/lotties/withdrawalAnimation.json',
                                      width: 50, // Adjust width as needed
                                      height: 50, // Adjust height as needed
                                      fit: BoxFit.fill,
                                      repeat: true,
                                    ),
                                    trailing: Text(
                                      historyData[index]['date'],
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
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
