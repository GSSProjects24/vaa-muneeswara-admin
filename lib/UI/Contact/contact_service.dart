
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactFirebase {
  final CollectionReference contactInfoCollection =
  FirebaseFirestore.instance.collection('contact');

  Future<Map<String, dynamic>?> getContactInfo(String docId) async {
    DocumentSnapshot docSnapshot = await contactInfoCollection.doc(docId).get();
    if (docSnapshot.exists) {
      return docSnapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> updateContactInfo(String docId, Map<String, dynamic> updatedData) async {
    await contactInfoCollection.doc(docId).update(updatedData);
  }
}
