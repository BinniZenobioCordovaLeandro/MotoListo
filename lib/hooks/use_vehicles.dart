import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future<List> getNearVehicles(Position position, double metros) {
  CollectionReference vehicles =
      FirebaseFirestore.instance.collection('vehicles');
  final center = GeoPoint(position.latitude, position.longitude);
  final radius = metros / 1000;
  return vehicles
      .where('position',
          isLessThanOrEqualTo:
              GeoPoint(center.latitude + radius, center.longitude + radius),
          isGreaterThanOrEqualTo:
              GeoPoint(center.latitude - radius, center.longitude - radius))
      .where('available', isEqualTo: true)
      .get()
      .then((value) {
    return value.docs;
  }).then((value) {
    return value.map((e) => e.data()).toList();
  });
}
