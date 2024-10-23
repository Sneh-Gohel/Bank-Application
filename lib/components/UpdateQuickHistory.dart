import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Updatequickhistory {
  // Function to manage document IDs in QuickHistory
  Future<void> updateDocumentIds() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(
              'QuickHistory') // Assume eventDetails contains 'name' of the event
          .get();

      // Initialize an empty list to hold all student details
      List<Map<String, dynamic>> quickHistory = [];

      // Loop through all the documents in the collection
      for (var doc in querySnapshot.docs) {
        // Skip the document with ID 'QuickAdd_details'
        if (doc.id == 'QuickAdd_details') {
          continue; // Skip this document and move to the next iteration
        }

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        data['docId'] = doc.id;
        quickHistory.add(data);
      }
      for (int i = quickHistory.length; i > 0; i--) {
        if (i == 3) {
          await FirebaseFirestore.instance
              .collection('QuickHistory')
              .doc('3')
              .delete();
        } else if (i == 2) {
          await copyDocument("2", "3");
        } else if (i == 1) {
          await copyDocument("1", "2");
        }
      }
    } catch (e) {}
  }

// Main function to add a new document
  Future<void> addNewDocument(String name, String amount, String transaction,
      String remarks, String folderName) async {
    await updateDocumentIds(); // Update IDs before adding a new document

    // Add the new document with ID '1'
    CollectionReference collection =
        FirebaseFirestore.instance.collection('QuickHistory');

    Timestamp timestamp = Timestamp.now();
    DateTime dateTime = timestamp.toDate();

    await collection.doc('1').set({
      "name": name,
      "amount": amount,
      "transaction": transaction,
      "date": _getCurrentDate(),
      "remarks": remarks,
      "folder_name": folderName,
    });
  }

  String _getCurrentDate() {
    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as dd/mm/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    // Print the formatted date to the console
    return formattedDate;
  }

  Future<void> copyDocument(String sourceDocId, String targetDocId) async {
    try {
      // Reference to the source document
      DocumentReference sourceDocRef = FirebaseFirestore.instance
          .collection('QuickHistory')
          .doc(sourceDocId);

      // Get the data from the source document
      DocumentSnapshot sourceDocSnapshot = await sourceDocRef.get();

      if (sourceDocSnapshot.exists) {
        // Reference to the target document
        DocumentReference targetDocRef = FirebaseFirestore.instance
            .collection('QuickHistory')
            .doc(targetDocId);

        // Copy data to the target document
        await targetDocRef
            .set(sourceDocSnapshot.data() as Map<String, dynamic>);
      } else {
        print("Source document does not exist.");
      }
    } catch (e) {
      print("Error copying document: $e");
    }
  }
}
