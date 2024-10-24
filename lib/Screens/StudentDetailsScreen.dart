// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bank_application/Screens/HistoryDetailsScreen.dart';
import 'package:bank_application/components/DeletingAccountFromDatabase.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:bank_application/components/UpdateQuickHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<bool> deleteAccount() async {
    try {
      if (widget.studentData['amount'] != 0) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Confirmation"),
            content: const Text(
              "There are balance in the account. Are you sure you want to continue?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (widget.studentData['amount'] != "0") {
                    DocumentSnapshot docSnapshot = await FirebaseFirestore
                        .instance
                        .collection('AllHistory')
                        .doc('TotalAmount')
                        .get();
                    var data = docSnapshot.data() as Map<String, dynamic>;
                    double amount = double.parse(data['Amount'].toString());
                    final FirebaseFirestore _firestore =
                        FirebaseFirestore.instance;
                    await _firestore
                        .collection('AllHistory')
                        .doc('TotalAmount')
                        .update({
                      "Amount": amount -
                          double.parse(widget.studentData['amount'].toString()),
                    });

                    DocumentReference docRef =
                        await _firestore.collection("AllHistory").add({
                      "name": widget.studentData['name'],
                      "amount": widget.studentData['amount'],
                      "transaction": "debit",
                      "date": _getCurrentDate(),
                      "remarks":
                          "Debit the rest amount with the account closing.",
                      "folder_name": widget.studentData['folder_name'],
                    });

                    Updatequickhistory uq = Updatequickhistory();
                    await uq.addNewDocument(
                      widget.studentData['name'],
                      widget.studentData['amount'],
                      "debit",
                      "Debit the rest amount with the account closing.",
                      widget.studentData['folder_name'],
                    );
                  }

                  DeletingAccountFromDatabase d = DeletingAccountFromDatabase();
                  await d.deleteCollection(
                      "FolderList/${widget.studentData['folder_name']}/StudentList/${widget.studentData['docID']}/History");

                  await FirebaseFirestore.instance
                      .collection('FolderList')
                      .doc(widget.studentData['folder_name'])
                      .collection('StudentList')
                      .doc(widget.studentData['docID'])
                      .delete();
                },
                child: const Text("Delete"),
              ),
            ],
          ),
        );
      } else {
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        await _firestore
            .collection('FolderList')
            .doc(widget.studentData['folder_name'])
            .collection('StudentList')
            .doc(widget.studentData['docID'])
            .delete();
      }
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Account has successfully closed. You can go back.',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return true;
    } catch (e) {
      print("Getting error : $e");
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'Cannot delete the account getting some errors.',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return false;
    }
  }

  String _getCurrentDate() {
    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as dd/mm/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    // Print the formatted date to the console
    return formattedDate;
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
            onPressed: () async {
              if (isEditing) {
                setState(() {
                  widget.studentData['name'] = nameController.text;
                  isEditing = false;
                  loadingScreen = true;
                });
                await FirebaseFirestore.instance
                    .collection("FolderList")
                    .doc(widget.studentData['folder_name'])
                    .collection("StudentList")
                    .doc(widget.studentData['docID'])
                    .update({"name": nameController.text});
                setState(() {
                  loadingScreen = false;
                });
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
                      widget.studentData['gender'] == "Male"
                          ? 'assets/lotties/manAnimation.json'
                          : 'assets/lotties/womanAnimation.json',
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
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Align title and text
        children: [
          // Title
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
          const SizedBox(width: 10), // Add spacing between title and value
          // Editable Text or Text Field
          Expanded(
            child: Align(
              alignment: Alignment.centerRight, // Align text to the right
              child: isEditing
                  ? TextField(
                      controller: controller,
                      textAlign: TextAlign.right, // Align input to the right
                      style: GoogleFonts.lora(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 199, 191),
                          fontSize: 20,
                        ),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    )
                  : Text(
                      widget.studentData['name'],
                      textAlign: TextAlign.right, // Align text to the right
                      style: GoogleFonts.lora(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 199, 191),
                          fontSize: 20,
                        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Text
          Flexible(
            flex: 2,
            child: Text(
              title,
              style: GoogleFonts.lora(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 206, 199, 191),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10), // Spacing between title and value
          // Value Text with Right Alignment
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right, // Align text to the right
              style: GoogleFonts.lora(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 206, 199, 191),
                  fontSize: 20,
                ),
              ),
              maxLines: null, // Allow multiple lines
              overflow: TextOverflow.visible, // Avoid overflow issues
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
            onPressed: () async {
              Navigator.pop(context);
              deleteAccount();
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
                      ? Icons.call_received_outlined
                      : Icons.call_made_outlined,
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
                  transaction.addAll({
                    "name": widget.studentData['name'],
                    "folder_name": widget.studentData['folder_name']
                  });
                  Navigator.of(context).push(
                    FadeSlideTransition(
                      page: HistoryDetailsScreen(
                        HistoryData: transaction,
                      ),
                    ),
                  );
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
