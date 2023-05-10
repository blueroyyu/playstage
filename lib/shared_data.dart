import 'package:geocoding/geocoding.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';

class SharedData {
  static final SharedData _singleton = SharedData._internal();

  factory SharedData() {
    return _singleton;
  }

  SharedData._internal();

  MemberInfoEntity? owner;

  // filter
  int fromAge = 19;
  int toAge = 71;
  int distance = 500;
}

Future<String> getAddressFromLatLng(double lat, double lng) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  Placemark place = placemarks[0];
  String address =
      '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}';
  return address;
}
