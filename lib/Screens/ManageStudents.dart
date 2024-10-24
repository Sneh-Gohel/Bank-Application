// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bank_application/Screens/AddNewStudentScreen.dart';
import 'package:bank_application/Screens/MoveScreen.dart';
import 'package:bank_application/Screens/StudentDetailsScreen.dart';
import 'package:bank_application/components/DeletingAccountFromDatabase.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:bank_application/components/UpdateQuickHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class ManageStudents extends StatefulWidget {
  final String folderName;
  ManageStudents({required this.folderName, super.key});

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  bool isSelectionMode = false;
  final Set<String> selectedStudents = {}; // Store selected docIDs here
  bool loadingScreen = false;

  void _toggleSelection(String docID) {
    setState(() {
      if (selectedStudents.contains(docID)) {
        selectedStudents.remove(docID);
      } else {
        selectedStudents.add(docID);
      }
      isSelectionMode = selectedStudents.isNotEmpty;
    });
  }

  void _clearSelection() {
    setState(() {
      selectedStudents.clear();
      isSelectionMode = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (isSelectionMode) {
      _clearSelection();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            isSelectionMode
                ? "${selectedStudents.length} Selected"
                : "Student List",
            style: GoogleFonts.lora(
              color: const Color.fromARGB(255, 61, 115, 127),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 61, 115, 127),
          ),
          actions: isSelectionMode
              ? [
                  IconButton(
                    icon: const Icon(Icons.move_to_inbox),
                    onPressed: () async {
                      final snapshot = await FirebaseFirestore.instance
                          .collection('FolderList')
                          .doc(widget.folderName)
                          .collection('StudentList')
                          .get();

                      Navigator.of(context).push(
                        FadeSlideTransition(
                          page: MoveScreen(
                            studentDetails: snapshot.docs,
                            selectedStudents: selectedStudents,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await _showDeleteConfirmationDialog();
                      if (confirm) {
                        // Get the latest list of student docs from Firestore
                        final snapshot = await FirebaseFirestore.instance
                            .collection('FolderList')
                            .doc(widget.folderName)
                            .collection('StudentList')
                            .get();

                        _deleteSelectedStudentIndices(
                            snapshot.docs); // Call the new method here
                        // Perform additional delete logic here if needed
                        print("Delete operation performed.");
                      }
                    },
                  ),
                ]
              : [],
        ),
        backgroundColor: const Color.fromARGB(255, 7, 22, 27),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 7, 22, 27)),
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: "Folder",
                  child: Lottie.asset(
                    'assets/lotties/folderAnimation.json',
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
                          final studentData =
                              doc.data() as Map<String, dynamic>;
                          final docID = doc.id;
                          final isSelected = selectedStudents.contains(docID);

                          return _buildCustomListView(
                              width, studentData, context, docID, isSelected);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      FadeSlideTransition(
                        page: AddNewStudentScreen(
                          folderName: widget.folderName,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
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
      ),
    );
  }

  Widget _buildCustomListView(
    double width,
    Map<String, dynamic> studentData,
    BuildContext context,
    String docID,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (isSelectionMode) {
          _toggleSelection(docID);
        } else {
          Navigator.of(context).push(
            FadeSlideTransition(
              page: StudentDetailsScreen(
                studentData: studentData,
                tag: "tag${studentData['name'] ?? ''}_$docID",
              ),
            ),
          );
        }
      },
      onLongPress: () => _toggleSelection(docID),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.redAccent.withOpacity(0.8)
              : const Color.fromARGB(255, 61, 115, 127),
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

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
                "This data will be permanently deleted and cannot be recovered."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteSelectedStudentIndices(
      List<QueryDocumentSnapshot> docs) async {
    for (int i = 0; i < docs.length; i++) {
      if (selectedStudents.contains(docs[i].id)) {
        print("Selected Student Index: $i, ID: ${docs[i].id}");
        setState(() {
          loadingScreen = true;
        });
        try {
          if (docs[i]['amount'] != "0") {
            DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
                .collection('AllHistory')
                .doc('TotalAmount')
                .get();
            var data = docSnapshot.data() as Map<String, dynamic>;
            double amount = double.parse(data['Amount'].toString());
            final FirebaseFirestore _firestore = FirebaseFirestore.instance;
            await _firestore
                .collection('AllHistory')
                .doc('TotalAmount')
                .update({
              "Amount": amount - double.parse(docs[i]['amount'].toString()),
            });
            Timestamp timestamp = Timestamp.now();
            DateTime dateTime = timestamp.toDate();
            DocumentReference docRef =
                await _firestore.collection("AllHistory").add({
              "name": docs[i]['name'],
              "amount": docs[i]['amount'],
              "transaction": "debit",
              "date": dateTime,
              "remarks": "Debit the rest amount with the account closing.",
              "folder_name": docs[i]['folder_name'],
            });

            Updatequickhistory uq = Updatequickhistory();
            await uq.addNewDocument(
                docs[i]['name'],
                docs[i]['amount'],
                "debit",
                "Debit the rest amount with the account closing.",
                widget.folderName);
          }

          DeletingAccountFromDatabase d = DeletingAccountFromDatabase();
          await d.deleteCollection(
              "FolderList/${docs[i]['folder_name']}/StudentList/${docs[i]['docID']}/History");

          await FirebaseFirestore.instance
              .collection('FolderList')
              .doc(docs[i]['folder_name'])
              .collection('StudentList')
              .doc(docs[i]['docID'])
              .delete();
        } catch (e) {
          print("Getting error : $e");
        } finally {
          setState(() {
            loadingScreen = false;
          });
        }
      }
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
}
