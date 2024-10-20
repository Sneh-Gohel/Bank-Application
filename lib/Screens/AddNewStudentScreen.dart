// ignore_for_file: must_be_immutable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bank_application/components/CustomTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';

class AddNewStudentScreen extends StatefulWidget {
  String folderName;
  AddNewStudentScreen({required this.folderName, super.key});

  @override
  State<StatefulWidget> createState() => _AddNewStudentScreen();
}

class _AddNewStudentScreen extends State<AddNewStudentScreen> {
  final name_Controller = TextEditingController();
  final amount_Controller = TextEditingController();
  final name = FocusNode();
  final amount = FocusNode();
  bool isMale = true;
  bool loadingScreen = false;

  Future<void> addStudent() async {
    if (name_Controller.text.isEmpty) {
      Vibration.vibrate(duration: 50);
      FocusScope.of(context).requestFocus(name);
      return;
    }
    try {
      setState(() {
        loadingScreen = true;
      });
      String docId = "";
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      try {
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        final DocumentReference docRef = await _firestore
            .collection("FolderList")
            .doc(widget.folderName)
            .collection('StudentList')
            .add({
          "name": name_Controller.text,
          "gender": isMale ? "Male" : "Female",
          "amount":
              amount_Controller.text.isEmpty ? "0" : amount_Controller.text,
          "account_opening_date": _getCurrentDate(),
          "folder_name": widget.folderName
        });
        docId = docRef.id;
        await _firestore
            .collection("FolderList")
            .doc(widget.folderName)
            .collection("StudentList")
            .doc(docId)
            .update({"docID": docId});
      } catch (e) {
        print("Getting error to add new student");
        const snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Cannot add student.',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      if (amount_Controller.text.isNotEmpty) {
        try {
          final FirebaseFirestore _firestore = FirebaseFirestore.instance;
          DocumentReference docRef =
              await _firestore.collection("AllHistory").add({
            "name": name_Controller.text,
            "amount": amount_Controller.text,
            "transaction": "credit",
            "date": _getCurrentDate(),
            "remarks": "Credited with account opening.",
            "folder_name": widget.folderName,
          });

          DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
              .collection('AllHistory')
              .doc('TotalAmount')
              .get();
          var data = docSnapshot.data() as Map<String, dynamic>;

          await _firestore.collection('AllHistory').doc('TotalAmount').update({
            "Amount": data['Amount'] +
                int.parse(amount_Controller.text), // Add a new field here
          });

          docRef = await _firestore
              .collection("FolderList")
              .doc(widget.folderName)
              .collection('StudentList')
              .doc(docId)
              .collection("History")
              .add({
            "amount": amount_Controller.text,
            "transaction": "credit",
            "date": _getCurrentDate(),
            "remarks": "Credited with account opening.",
          });

          CollectionReference collection =
              FirebaseFirestore.instance.collection('QuickHistory');

          await collection.add({
            "name": name_Controller.text,
            "amount": amount_Controller.text,
            "transaction": "credit",
            "date": _getCurrentDate(),
            "remarks": "Credited with account opening.",
            "folder_name": widget.folderName,
          });

          // Ensure only the latest 3 documents are kept
          QuerySnapshot snapshot =
              await collection.orderBy('date', descending: true).get();
          if (snapshot.docs.length > 3) {
            // Delete older documents beyond the first 3
            for (var i = 3; i < snapshot.docs.length; i++) {
              await collection.doc(snapshot.docs[i].id).delete();
            }
          }
        } catch (e) {
          print("Cannot add the transaction into the history.");
        }
      }
      Navigator.pop(context);
    } catch (e) {
      print("Getting error : $e");
    } finally {
      setState(() {
        loadingScreen = false;
      });
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Add Student",
          style: GoogleFonts.lora(
            color: const Color.fromARGB(255, 7, 22, 27),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 61, 115, 127),
      body: loadingScreen
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 61, 115, 127),
              ),
              child: Center(
                child: LoadingAnimationWidget.hexagonDots(
                  color: const Color.fromARGB(255, 7, 22, 27),
                  size: 35,
                ),
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: (width - 180) / 2),
                  child: Lottie.asset(
                    'assets/lotties/addStudentAnimation.json',
                    width: 180,
                    height: 180,
                    fit: BoxFit.fill,
                    repeat: true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Enter Username : ',
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
                  keyboardType: TextInputType.name,
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
                    'Select Gender : ',
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: SizedBox(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMale = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 60,
                            width: (width - 60) / 2,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: isMale
                                    ? const Color.fromARGB(255, 206, 199, 191)
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(255, 7, 22, 27),
                            ),
                            child: Center(
                              child: Text(
                                'Male',
                                style: GoogleFonts.lora(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 206, 199, 191),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 60,
                              width: (width - 60) / 2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: isMale
                                      ? Colors.transparent
                                      : const Color.fromARGB(
                                          255, 206, 199, 191),
                                ),
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromARGB(255, 7, 22, 27),
                              ),
                              child: Center(
                                child: Text(
                                  'Female',
                                  style: GoogleFonts.lora(
                                    textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 206, 199, 191),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Enter Amount (Optional) : ',
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
                  keyboardType: TextInputType.number,
                  hintText: "Amount",
                  prefixIcon: Icons.currency_rupee_outlined,
                  showSuffixIcon: false,
                  onSuffixTap: () {
                    setState(() {
                      amount_Controller.clear();
                    });
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 110),
                  child: ElevatedButton(
                    onPressed: () {
                      addStudent();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      backgroundColor: const Color(0xFFCEC7BF),
                      shape: const StadiumBorder(),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Add",
                        style: TextStyle(
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
    );
  }
}
