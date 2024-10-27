// ignore_for_file: must_be_immutable

import 'package:bank_application/Screens/SelectStudentScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectFolderScreen extends StatefulWidget {
  String label = "";
  SelectFolderScreen({required this.label, super.key});

  @override
  State<StatefulWidget> createState() => _SelectFolderScreen();
}

class _SelectFolderScreen extends State<SelectFolderScreen> {
  int folderCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 22, 27),
        elevation: 0, // Removes the shadow
        title: const Text(
          "Select Folder",
          style: TextStyle(
            color:
                Color.fromARGB(255, 61, 115, 127), // Sets the title text color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 61, 115, 127), // Sets the icon color
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
          Navigator.of(context).push(
            FadeSlideTransition(
              page: SelectStudentScreen(
                  label: widget.label, folderName: folderName),
            ),
          );
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
