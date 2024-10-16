import 'package:bank_application/Screens/ManageStudents.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:bank_application/Screens/SelectStudentScreen.dart';

class AllFoldersList extends StatefulWidget {
  String label;
  AllFoldersList({required this.label, super.key});

  @override
  State<AllFoldersList> createState() => _AllFoldersListState();
}

class _AllFoldersListState extends State<AllFoldersList> {
  int folderCount = 5;
  Set<int> selectedFolders = {}; // Track selected folder indexes
  bool hasUnsavedChanges = false; // Track unsaved changes

  bool get isSelectionMode => selectedFolders.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 7, 22, 27),
          elevation: 0,
          title: isSelectionMode
              ? Text(
                  "${selectedFolders.length} Selected",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 61, 115, 127),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              : const Text(
                  "Select Folder",
                  style: TextStyle(
                    color: Color.fromARGB(255, 61, 115, 127),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 61, 115, 127),
          ),
          actions: _buildAppBarActions(), // Dynamically build AppBar actions
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
                    final isSelected = selectedFolders.contains(index);

                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        splashColor: const Color.fromARGB(
                            100, 61, 115, 127), // Splash color
                        onTap: isSelectionMode
                            ? () => _toggleSelection(index)
                            : () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const ManageStudents(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      var begin = 0.0;
                                      var end = 1.0;
                                      var curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                      return FadeTransition(
                                        opacity: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                        onLongPress: () => _toggleSelection(index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: isSelected
                                  ? Colors.red
                                  : const Color.fromARGB(255, 61, 115, 127),
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
                                "Folder ${index + 1}",
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
                  },
                ),
              ),
              Positioned(
                bottom: 50,
                right: 20,
                child: FloatingActionButton(
                  onPressed: _addFolder,
                  child: const Icon(Icons.create_new_folder),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedFolders.contains(index)) {
        selectedFolders.remove(index);
      } else {
        selectedFolders.add(index);
      }
    });
  }

  void _addFolder() {
    setState(() {
      folderCount++;
      hasUnsavedChanges = true; // Mark as unsaved
    });
  }

  void _saveChanges() {
    setState(() {
      hasUnsavedChanges = false; // Mark as saved
    });
    print("Saved");
  }

  Future<bool> _onWillPop() async {
    if (hasUnsavedChanges) {
      final shouldLeave = await _showUnsavedChangesDialog();
      return shouldLeave ?? false;
    }
    return true;
  }

  Future<bool?> _showUnsavedChangesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Unsaved Changes"),
          content: const Text(
              "You have unsaved changes. Do you really want to leave?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Leave"),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    if (hasUnsavedChanges) {
      return [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveChanges,
        ),
      ];
    } else if (isSelectionMode) {
      return [
        if (selectedFolders.length == 1)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _renameFolder,
          ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteFolders,
        ),
      ];
    }
    return [];
  }

  void _renameFolder() {
    if (selectedFolders.length == 1) {
      print("Renaming folder ${selectedFolders.first}");
    }
  }

  void _deleteFolders() {
    setState(() {
      folderCount -= selectedFolders.length;
      selectedFolders.clear();
    });
  }
}
