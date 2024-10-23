import 'package:cloud_firestore/cloud_firestore.dart';

class DeletingAccountFromDatabase {

/// Deletes all documents within the specified collection.
Future<void> deleteCollection(String collectionPath) async {
  try {
    // Get a reference to the collection.
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);

    // Fetch all documents inside the collection.
    final querySnapshot = await collectionRef.get();

    // Loop through each document and delete them.
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print("Collection '$collectionPath' and all its documents have been deleted.");
  } catch (e) {
    print("Error deleting collection: $e");
  }
}

}