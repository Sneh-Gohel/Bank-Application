// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDetailsScreen extends StatefulWidget {
  var studentData;
  String tag;
  StudentDetailsScreen(
      {required this.studentData, required this.tag, super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  bool isEditing = false; // Controls if user is in edit mode
  bool loadingScreen = false;
  List<Map<String, dynamic>> transactionHistory = [];
  final TextEditingController nameController = TextEditingController();

  Future<void> getHistoryData() async {
    setState(() {
      loadingScreen = true;
    });
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("FolderList")
          .doc(widget.studentData['folder_name'])
          .collection('StudentList')
          .doc(widget.studentData['docID'])
          .collection("History")
          .get();

      List<Map<String, dynamic>> historyDetails = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id;
        historyDetails.add(data);
      }
      setState(() {
        transactionHistory = historyDetails;
      });
      _showTransactionHistory();
    } catch (e) {
      print("Getting error : $e");
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'Getting error to fetch the student history.',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } finally {
      setState(() {
        loadingScreen = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      nameController.text = widget.studentData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 22, 27),
        elevation: 0,
        title: const Text(
          "Student Details",
          style: TextStyle(
            color: Color.fromARGB(255, 61, 115, 127),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 61, 115, 127),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                setState(() {
                  widget.studentData['name'] = nameController.text;
                  isEditing = false;
                });
                print("Details saved.");
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation();
            },
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Hero(
                    tag: widget.tag,
                    child: Lottie.asset(
                      'assets/lotties/manAnimation.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                      repeat: true,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildEditableInfoCard("Name", nameController),
                const SizedBox(height: 20),
                _buildInfoCard("Gender", widget.studentData['gender']),
                const SizedBox(height: 20),
                _buildInfoCard(
                    "Total Balance", "₹ ${widget.studentData['amount']}"),
                const SizedBox(height: 20),
                _buildInfoCard("Account Opening Date",
                    widget.studentData['account_opening_date']),
                const SizedBox(height: 20),
                _buildInfoCard("Folder", widget.studentData['folder_name']),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    getHistoryData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 61, 115, 127),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    child: Text(
                      "History",
                      style: TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            loadingScreen
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(180, 7, 22, 27),
                    ),
                    child: Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: const Color.fromARGB(255, 61, 115, 127),
                        size: 35,
                      ),
                    ),
                  )
                : const Center(),
          ],
        ),
      ),
    );
  }

  // Editable Info Card for the Student Name
  Widget _buildEditableInfoCard(
      String title, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 61, 115, 127),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isEditing
              ? Expanded(
                  child: TextField(
                    controller: controller,
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 20,
                      ),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                )
              : Expanded(
                  child: Text(
                    widget.studentData['name'],
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Static Info Card for Total Balance
  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 61, 115, 127),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show Delete Confirmation Dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Confirmation"),
        content: const Text(
          "Data will be permanently deleted. Are you sure you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              print("Deleted.");
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Show Transaction History Dialog
  void _showTransactionHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(
            255, 7, 22, 27), // Background color matching theme
        title: Text(
          "Transaction History",
          style: GoogleFonts.lora(
            textStyle: const TextStyle(
              color: Color.fromARGB(
                  255, 61, 115, 127), // Title text color matching app theme
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        content: SizedBox(
          height: 300, // Fixed height to prevent overflow
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: transactionHistory.length,
            itemBuilder: (context, index) {
              final transaction = transactionHistory[index];
              return ListTile(
                leading: Icon(
                  transaction['transaction'] == 'credit'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: transaction['transaction'] == 'credit'
                      ? const Color.fromARGB(
                          255, 61, 115, 127) // Greenish blue arrow for credit
                      : Colors.redAccent, // Red arrow for debit
                ),
                title: Text(
                  "${transaction['transaction']}: ₹${transaction['amount']}",
                  style: GoogleFonts.lora(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 206, 199, 191),
                      fontSize: 18,
                    ),
                  ),
                ),
                subtitle: Text(
                  "Date: ${transaction['date']}",
                  style: GoogleFonts.lora(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                      fontSize: 14,
                    ),
                  ),
                ),
                splashColor: const Color.fromARGB(255, 61, 115, 127),
                onTap: () {
                  print("Tapped");
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Close",
              style: GoogleFonts.lora(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 61, 115, 127),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
