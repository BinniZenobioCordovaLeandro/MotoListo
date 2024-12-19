import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motolisto/hooks/use_messaging.dart';

Future<Stream<DocumentSnapshot<Object?>>> streamRequestDocument() async {
  CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');
  DocumentReference clientDoc =
      clients.doc(FirebaseAuth.instance.currentUser!.uid);
  return await clientDoc.snapshots();
}

Future<void> sendRequest(Position position) async {
  FirebaseMessaging.instance.requestPermission();
  CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');

  DocumentReference clientDoc =
      clients.doc(FirebaseAuth.instance.currentUser!.uid);
  await clientDoc.set({
    'position': GeoPoint(position.latitude, position.longitude),
    'user': FirebaseAuth.instance.currentUser!.uid,
    'status': 'requesting',
    'token': await FirebaseMessaging.instance.getToken(),
    'phone': FirebaseAuth.instance.currentUser!.phoneNumber,
    'timestamp': FieldValue.serverTimestamp(),
  });
  return;
}

Future<void> cancelRequest() async {
  CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');
  DocumentReference clientDoc =
      clients.doc(FirebaseAuth.instance.currentUser!.uid);
  await clientDoc.update({
    'status': 'cancelled',
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Future<void> sendNotificationToNearbyVehicles(List<String> tokens) async {
  debugPrint(
      '🎸🎸🎸 Enviando notificación a vehículos cercanos, Tokens: $tokens');
  await sendNotification(tokens);
}
