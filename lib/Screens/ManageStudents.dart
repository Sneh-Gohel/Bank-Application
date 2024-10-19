// ignore_for_file: non_constant_identifier_names

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bank_application/Screens/AddNewStudentScreen.dart';
import 'package:bank_application/Screens/StudentDetailsScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ManageStudents extends StatefulWidget {
  String folderName;
  ManageStudents({required this.folderName, super.key});

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  bool isSelectionMode = false;
  final List<int> selectedStudents = [];

  void _toggleSelection(int index) {
    setState(() {
      if (selectedStudents.contains(index)) {
        selectedStudents.remove(index);
      } else {
        selectedStudents.add(index);
      }

      // Enable/disable selection mode based on the selection count
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
      _clearSelection(); // Deselect items on back press
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
        extendBodyBehindAppBar: true,
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
                    onPressed: () {
                      print("Move");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await _showDeleteConfirmationDialog();
                      if (confirm) print("Delete");
                    },
                  ),
                ]
              : [],
        ),
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
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
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
                          .collection('StudentList') // Adjust this if needed
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              "No Students Found.", // Assuming 'name' field exists
                              style: GoogleFonts.lora(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 206, 199, 191),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }

                        // Step to generate the list of students
                        return SingleChildScrollView(
                          child: Column(
                            children: snapshot.data!.docs
                                .map((QueryDocumentSnapshot document) {
                              Map<String, dynamic> studentData =
                                  document.data() as Map<String, dynamic>;
                              int index = snapshot.data!.docs.indexOf(
                                  document); // Get the index for selection

                              return _buildCustomListView(
                                  width, studentData, context, index);
                            }).toList(),
                          ),
                        );
                      },
                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomListView(double width, Map<String, dynamic> studentData,
      BuildContext context, int index) {
    final isSelected = selectedStudents.contains(index);

    return GestureDetector(
      onTap: () {
        if (isSelectionMode) {
          _toggleSelection(index);
        } else {
          Navigator.of(context).push(
            FadeSlideTransition(
                page: StudentDetailsScreen(
              studentData: studentData,
              tag: "tag$index",
            )),
          );
        }
      },
      onLongPress: () => _toggleSelection(index),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentData['name'], // Assuming 'name' field exists
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
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.currency_rupee_sharp,
                          size: 28,
                          color: Color.fromARGB(255, 206, 199, 191),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          studentData['amount']
                              .toString(), // Assuming 'amount' field exists
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
              const SizedBox(
                width: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Hero(
                  tag: "tag$index",
                  child: Lottie.asset(
                    studentData['gender'] == "Male"
                        ? 'assets/lotties/manAnimation.json'
                        : 'assets/lotties/womanAnimation.json',
                    width: (width - 40) / 3,
                    height: (width - 40) / 3,
                    fit: BoxFit.cover,
                    repeat: true,
                  ),
                ),
              ),
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
}
