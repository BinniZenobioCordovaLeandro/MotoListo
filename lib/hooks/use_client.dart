import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future<List> getNearClients(Position position, double meters) async {
  CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');
  final center = GeoPoint(position.latitude, position.longitude);
  final radius = meters / 1000;
  return clients
      .where('position',
          isLessThanOrEqualTo:
              GeoPoint(center.latitude + radius, center.longitude + radius),
          isGreaterThanOrEqualTo:
              GeoPoint(center.latitude - radius, center.longitude - radius))
      .where('status', isEqualTo: 'requesting')
      .get()
      .then((value) {
    return value.docs;
  }).then((value) {
    return value.map((e) => e.data()).toList();
  });
}
