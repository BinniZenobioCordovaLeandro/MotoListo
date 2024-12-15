import 'package:cloud_firestore/cloud_firestore.dart';

Future<Stream<DocumentSnapshot<Object?>>> acceptServiceFromFirestore(
    String documentId) async {
  CollectionReference requests =
      FirebaseFirestore.instance.collection('clients');
  DocumentReference requestDoc = requests.doc(documentId);
  // accept only if status is requesting
  Map<String, dynamic>? data =
      (await requestDoc.get()).data() as Map<String, dynamic>?;
  if (data?['status'] != 'requesting') throw 'Service already accepted';
  await requestDoc.update({'status': 'accepted'});
  return await requestDoc.snapshots();
}

void updateServiceFromFirestore(String documentId, String status) {
  CollectionReference requests =
      FirebaseFirestore.instance.collection('clients');
  DocumentReference requestDoc = requests.doc(documentId);
  requestDoc.update({'status': status});
}
