// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bank_application/Screens/CreditAndDebitAmountScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SelectStudentScreen extends StatefulWidget {
  String label = "";
  String folderName;
  SelectStudentScreen(
      {required this.label, required this.folderName, super.key});

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
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(180, 7, 22, 27)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('FolderList')
                      .doc(widget.folderName)
                      .collection('StudentList')
                      .orderBy('name', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 61, 115, 127),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      const snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Error!',
                          message: 'Getting error in fetching the data.',
                          contentType: ContentType.failure,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                      return const SizedBox();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No Students Found.",
                          style: GoogleFonts.lora(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 206, 199, 191),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        final studentData = doc.data() as Map<String, dynamic>;
                        final docID = doc.id;

                        return _buildCustomListView(
                          width,
                          studentData,
                          context,
                          docID,
                          widget.label,
                        );
                      }).toList(),
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

Widget _buildCustomListView(
  double width,
  Map<String, dynamic> studentData,
  BuildContext context,
  String docID,
  String label,
) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(FadeSlideTransition(
          page: CreditAndDebitAmountScreen(
        label: label,
        studentData: studentData,
      )));
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 61, 115, 127),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentData['name'] ?? 'Unknown',
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.currency_rupee_sharp,
                        size: 28,
                        color: Color.fromARGB(255, 206, 199, 191),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        studentData['amount'].toString(),
                        style: GoogleFonts.lora(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 206, 199, 191),
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Hero(
                  tag: "tag${studentData['name'] ?? ''}_$docID",
                  child: Lottie.asset(
                    studentData['gender'] == "Male"
                        ? 'assets/lotties/manAnimation.json'
                        : 'assets/lotties/womanAnimation.json',
                    width: (width - 40) / 3,
                    height: (width - 40) / 3,
                    fit: BoxFit.cover,
                  ),
                )),
          ],
        ),
      ),
    ),
  );
}
