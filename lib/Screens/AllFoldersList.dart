// ignore_for_file: unused_local_variable

import 'package:bank_application/Screens/ManageStudents.dart';
import 'package:bank_application/components/DeletingAccountFromDatabase.dart';
import 'package:bank_application/components/UpdateQuickHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class AllFoldersList extends StatefulWidget {
  final String label;
  AllFoldersList({required this.label, super.key});

  @override
  State<AllFoldersList> createState() => _AllFoldersListState();
}

class _AllFoldersListState extends State<AllFoldersList> {
  Set<int> selectedFolders = {}; // Track selected folder indexes
  bool loadingScreen = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

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
              StreamBuilder<DocumentSnapshot>(
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
              Positioned(
                bottom: 50,
                right: 20,
                child: FloatingActionButton(
                  onPressed: _showAddFolderDialog,
                  child: const Icon(Icons.create_new_folder),
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
          final isSelected = selectedFolders.contains(index);

          return _buildFolderTile(folderName, index, isSelected);
        },
      ),
    );
  }

  Widget _buildFolderTile(String folderName, int index, bool isSelected) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        splashColor: const Color.fromARGB(100, 61, 115, 127),
        onTap: () {
          if (isSelectionMode) {
            _toggleSelection(
                index); // Allow normal tap to select when in selection mode
          } else {
            _navigateToManageStudents(
                folderName); // Navigate if not in selection mode
          }
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

  void _toggleSelection(int index) {
    setState(() {
      if (selectedFolders.contains(index)) {
        selectedFolders.remove(index);
      } else {
        selectedFolders.add(index);
      }
    });
  }

  void _showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String folderName = '';
        return AlertDialog(
          backgroundColor:
              const Color.fromARGB(255, 7, 22, 27), // Dark background color
          title: Text(
            'Add New Folder',
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191), // Light text color
                fontSize: 18,
              ),
            ),
          ),
          content: TextField(
            onChanged: (value) => folderName = value,
            style:
                const TextStyle(color: Colors.white), // Text color inside input
            decoration: const InputDecoration(
              hintText: 'Enter folder name',
              hintStyle: TextStyle(
                  color: Color.fromARGB(255, 161, 161, 161)), // Hint text color
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 61, 115, 127)), // Input border color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 61, 115, 127)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.lora(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(
                        255, 206, 199, 191), // Light text for buttons
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _addFolderToDatabase(folderName);
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
                style: GoogleFonts.lora(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(
                        255, 61, 115, 127), // Button highlight color
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addFolderToDatabase(String folderName) async {
    var docRef =
        FirebaseFirestore.instance.collection('FolderList').doc('AllFolders');
    var snapshot = await docRef.get();
    Map<String, dynamic> data =
        snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};

    int newIndex = data.length + 1;
    data[newIndex.toString()] = folderName;

    await docRef.set(data);

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('FolderList').doc(folderName).set({
      "name": folderName, // Add a new field here
    });

    print('Folder added: $folderName');
  }

  void _navigateToManageStudents(String folderName) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => ManageStudents(
          folderName: folderName,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut));
          return FadeTransition(opacity: animation.drive(tween), child: child);
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (selectedFolders.isNotEmpty) {
      setState(() {
        selectedFolders.clear(); // Clear the selection
      });
      return false; // Prevent going back immediately
    }
    return true; // Proceed with the default back navigation
  }

  List<Widget> _buildAppBarActions() {
    if (isSelectionMode) {
      return [
        selectedFolders.length == 1
            ? IconButton(
                icon: const Icon(Icons.drive_file_rename_outline_outlined),
                onPressed: _renameFolder,
              )
            : const Center(),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteFolders,
        ),
      ];
    }
    return [];
  }

  Future<void> _renameFolder() async {
    if (selectedFolders.length != 1)
      return; // Ensure only one folder is selected

    int index = selectedFolders.first; // Get the selected folder index
    String folderName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Dark background
          title: const Text(
            'Rename Folder',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            onChanged: (value) => folderName = value,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter new folder name',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                await _updateFolderInDatabase(folderName, index);
                Navigator.of(context).pop();
                setState(() {
                  selectedFolders.clear(); // Clear selection after renaming
                });
              },
              child:
                  const Text('Rename', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateFolderInDatabase(String newName, int index) async {
    var docRef =
        FirebaseFirestore.instance.collection('FolderList').doc('AllFolders');
    var snapshot = await docRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      String oldName = (data[(index + 1).toString()]);

      // Step 1: Get the old document's data
      var oldDocRef =
          FirebaseFirestore.instance.collection('FolderList').doc(oldName);
      var oldDocSnapshot = await oldDocRef.get();

      if (oldDocSnapshot.exists) {
        // Step 2: Copy the data from old document to new document
        Map<String, dynamic>? oldData = oldDocSnapshot.data();

        // Update folder name in the main collection
        data[(index + 1).toString()] = newName; // Update the folder name
        await docRef.set(data); // Save updated data

        // Create a new document with copied data
        await FirebaseFirestore.instance
            .collection('FolderList')
            .doc(newName)
            .set(oldData!);

        // Step 3: Delete the old document
        await oldDocRef.delete();

        print('Folder renamed to: $newName and data copied successfully.');
      } else {
        print('Old document does not exist.');
      }
    } else {
      print('Main document does not exist.');
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

  void _deleteFolders() async {
    if (selectedFolders.isEmpty) return; // No folders selected, exit.

    // Show confirmation dialog to confirm the deletion operation.
    bool confirmDeletion = await _showDeleteConfirmationDialog();
    if (!confirmDeletion) return; // If user cancels, exit.

    setState(() {
      loadingScreen = true;
    });

    try {
      var docRef =
          FirebaseFirestore.instance.collection('FolderList').doc('AllFolders');
      var snapshot = await docRef.get();

      if (!snapshot.exists) return; // No data found, exit.

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var sf = selectedFolders.toList();
      for (int i = 0; i < sf.length; i++) {
        String folderName = data['${sf[i] + 1}'];

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('FolderList')
            .doc(folderName)
            .collection('StudentList')
            .get();

        // Initialize an empty list to hold all student details
        List<Map<String, dynamic>> studentData = [];

        // Loop through all the documents in the collection
        for (var doc in querySnapshot.docs) {
          // Skip the document with ID 'QuickAdd_details'
          if (doc.id == 'QuickAdd_details') {
            continue; // Skip this document and move to the next iteration
          }

          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Add both the document data and its ID to the map
          data['docId'] = doc.id; // Store document ID in the data map
          studentData.add(data); // Add the entire map to the list
        }

        for (int index = 0; index < studentData.length; index++) {
          try {
            if (studentData[i]['amount'] != "0") {
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
                "Amount":
                    amount - double.parse(studentData[i]['amount'].toString()),
              });

              DocumentReference docRef =
                  await _firestore.collection("AllHistory").add({
                "name": studentData[i]['name'],
                "amount": studentData[i]['amount'],
                "transaction": "debit",
                "date": _getCurrentDate(),
                "remarks": "Debit the rest amount with the account closing.",
                "folder_name": folderName,
              });
              Updatequickhistory uq = Updatequickhistory();
              await uq.addNewDocument(
                studentData[i]['name'],
                studentData[i]['amount'],
                "debit",
                "Debit the rest amount with the account closing.",
                studentData[i]['folder_name'],
              );
            }

            DeletingAccountFromDatabase d = DeletingAccountFromDatabase();
            await d.deleteCollection(
                "FolderList/$folderName/StudentList/${studentData[i]['docID']}/History");

            await FirebaseFirestore.instance
                .collection('FolderList')
                .doc(folderName)
                .collection('StudentList')
                .doc(studentData[i]['docID'])
                .delete();
          } catch (e) {
            print("Getting error : $e");
          }
        }
        DeletingAccountFromDatabase d = DeletingAccountFromDatabase();
        await d.deleteCollection("FolderList/$folderName/StudentList");
      }

      // Collect the indexes of folders to delete, sorted in descending order.
      List<int> indexesToDelete = selectedFolders.toList()
        ..sort((a, b) => b.compareTo(a));

      // Remove the selected folders from the "AllFolders" document.
      for (int index in indexesToDelete) {
        String folderName = data[(index + 1).toString()];
        data.remove((index + 1).toString()); // Remove folder from "AllFolders".

        // Delete the specific folder document from the collection.
        await FirebaseFirestore.instance
            .collection('FolderList')
            .doc(folderName)
            .delete();
        print("Folder document deleted: $folderName");
      }

      // Create a new map with sequential indexing after deletion.
      Map<String, dynamic> newData = {};
      int newIndex = 1;

      for (var entry in data.entries) {
        newData[newIndex.toString()] = entry.value;
        newIndex++;
      }

      // Save the updated data back to Firestore.
      await docRef.set(newData);

      setState(() {
        selectedFolders.clear();
        print("Folders deleted and reordered successfully.");
      });
    } catch (e) {
      print("Getting some error while deleting the folders... like : $e");
    } finally {
      setState(() {
        loadingScreen = false;
      });
    }
  }

// Function to show a confirmation dialog before deleting folders.
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Delete Folder',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete the selected folder(s) permanently?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false), // Cancel deletion.
            child: const Text('No', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(true), // Confirm deletion.
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool get isSelectionMode => selectedFolders.isNotEmpty;
}
