// ignore_for_file: non_constant_identifier_names

import 'package:bank_application/Screens/StudentDetailsScreen.dart';
import 'package:bank_application/components/FadeSlideTransition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({super.key});

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
            style: const TextStyle(
              color: Color.fromARGB(255, 61, 115, 127),
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          10,
                          (index) => _buildCustomListView(
                            width,
                            index.isEven,
                            context,
                            index,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    print("Add new student");
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

  Widget _buildCustomListView(
      double width, bool isMan, BuildContext context, int index) {
    final isSelected = selectedStudents.contains(index);

    return GestureDetector(
      onTap: () {
        if (isSelectionMode) {
          _toggleSelection(index);
        } else {
          Navigator.of(context).push(
            FadeSlideTransition(page: const StudentDetailsScreen()),
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
                      "Sneh Bharatbhai Gohel",
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.currency_rupee_sharp,
                          size: 28,
                          color: Color.fromARGB(255, 206, 199, 191),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '75,000',
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
                child: Lottie.asset(
                  isMan
                      ? 'assets/lotties/manAnimation.json'
                      : 'assets/lotties/womanAnimation.json',
                  width: (width - 40) / 3,
                  height: (width - 40) / 3,
                  fit: BoxFit.cover,
                  repeat: true,
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
