import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class GeolocationService {
  final geo = GeoFlutterFire();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Method to get the current location
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  // Method to store location in Firestore
  Future<void> storeLocation(String uid, Position position) async {
    GeoFirePoint point = geo.point(latitude: position.latitude, longitude: position.longitude);
    await firestore.collection('masseurs').doc(uid).update({
      'location': {
        'latitude': point.latitude,
        'longitude': point.longitude,
        'geohash': point.hash,
      },
      // ... other user data updates if needed ...
    });
  }

  // Method to get nearby locations
  Stream<List<DocumentSnapshot>> getNearbyUsers(GeoFirePoint center, double radius) {
    var collectionReference = firestore.collection('masseurs');
    var query = geo.collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: 'position');

    return query;
  }

}
