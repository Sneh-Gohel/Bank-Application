// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:bank_application/components/DeletingAccountFromDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class MoveScreen extends StatefulWidget {
  var studentDetails;
  var selectedStudents;
  MoveScreen(
      {required this.studentDetails,
      required this.selectedStudents,
      super.key});

  @override
  State<StatefulWidget> createState() => _MoveScreen();
}

class _MoveScreen extends State<MoveScreen> {
  bool loadingScreen = false;
  Future<void> copyDocument(
      String sourceDocID, String studentDocID, String targetDocID) async {
    try {
      // Reference to the source document
      DocumentSnapshot sourceDoc = await FirebaseFirestore.instance
          .collection('FolderList')
          .doc(sourceDocID)
          .collection('StudentList')
          .doc(studentDocID)
          .get();

      if (sourceDoc.exists) {
        // Copy the data from the source document
        Map<String, dynamic>? data = sourceDoc.data() as Map<String, dynamic>?;

        // Write the data to the target document
        await FirebaseFirestore.instance
            .collection('FolderList')
            .doc(targetDocID)
            .collection('StudentList')
            .doc(studentDocID)
            .set(data!);

        await FirebaseFirestore.instance
            .collection('FolderList')
            .doc(targetDocID)
            .collection('StudentList')
            .doc(studentDocID)
            .update({"folder_name": targetDocID});

        DeletingAccountFromDatabase d = DeletingAccountFromDatabase();
        await d.deleteCollection(
            "FolderList/$sourceDocID/StudentList/$studentDocID/History");

        await FirebaseFirestore.instance
            .collection('FolderList')
            .doc(sourceDocID)
            .collection('StudentList')
            .doc(studentDocID)
            .delete();

        print("Document copied successfully!");
      } else {
        print("Source document does not exist.");
      }
    } catch (e) {
      print("Error copying document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 22, 27),
        elevation: 0,
        title: const Text(
          "Move to...",
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
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
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('FolderList')
                    .doc('AllFolders')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      !snapshot.data!.exists ||
                      (snapshot.data!.data() as Map<String, dynamic>).isEmpty) {
                    print("No data found");
                    return _buildEmptyFolderMessage();
                  } else {
                    print("Data is available");
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    return _buildFolderGrid(data);
                  }
                },
              ),
            ),
            loadingScreen
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
                : const Center(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFolderMessage() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: const BoxDecoration(color: Color.fromARGB(180, 7, 22, 27)),
        child: Center(
          child: Text(
            "No Folders are available",
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 14,
              ),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildFolderGrid(Map<String, dynamic> data) {
    int folderCount = data.length;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: const BoxDecoration(color: Color.fromARGB(180, 7, 22, 27)),
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: folderCount,
        itemBuilder: (context, index) {
          String folderName = data[(index + 1).toString()];
          return _buildFolderTile(folderName, index);
        },
      ),
    );
  }

  Widget _buildFolderTile(String folderName, int index) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        splashColor: const Color.fromARGB(100, 61, 115, 127),
        onTap: () {
          setState(() {
            loadingScreen = true;
          });
          for (int i = 0; i < widget.studentDetails.length; i++) {
            if (widget.selectedStudents.contains(widget.studentDetails[i].id)) {
              copyDocument(widget.studentDetails[i]['folder_name'],
                  widget.studentDetails[i]['docID'], folderName);
            }
          }
          setState(() {
            loadingScreen = false;
          });
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: const Color.fromARGB(255, 61, 115, 127),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder,
                size: 55,
                color: Color.fromARGB(255, 61, 115, 127),
              ),
              const SizedBox(height: 10),
              Text(
                folderName,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 206, 199, 191),
                    fontSize: 14,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
