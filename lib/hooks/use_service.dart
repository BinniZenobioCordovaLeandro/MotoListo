import 'package:cloud_firestore/cloud_firestore.dart';

Future<Stream<DocumentSnapshot<Object?>>> streamServiceDocument(
    String documentId) async {
  CollectionReference requests =
      FirebaseFirestore.instance.collection('clients');
  DocumentReference requestDoc = requests.doc(documentId);
  return await requestDoc.snapshots();
}

Future<void> acceptService(String documentId) async {
  CollectionReference requests =
      FirebaseFirestore.instance.collection('clients');
  DocumentReference requestDoc = requests.doc(documentId);
  // accept only if status is requesting
  Map<String, dynamic>? data =
      (await requestDoc.get()).data() as Map<String, dynamic>?;
  if (data?['status'] != 'requesting') throw 'Service already accepted';
  await requestDoc.update({'status': 'accepted'});
  return;
}

void updateServiceFromFirestore(String documentId, String status) {
  CollectionReference requests =
      FirebaseFirestore.instance.collection('clients');
  DocumentReference requestDoc = requests.doc(documentId);
  requestDoc.update({'status': status});
}
