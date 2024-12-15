import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

storeUser(User user) {
  FirebaseFirestore.instance.collection('clients').doc(user.uid).set({
    'phoneNumber': user.phoneNumber,
    'position': GeoPoint(0, 0),
  });
}

updateLocation(Position position) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseFirestore.instance.collection('vehicles').doc(user.uid).update({
      'position': GeoPoint(position.latitude, position.longitude),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

updateAvailable(bool available) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseFirestore.instance.collection('vehicles').doc(user.uid).update({
      'available': available,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
