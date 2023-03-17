import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:playstage/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'subscriber_info.dart';
import 'package:playstage/people/main_view.dart';
import 'package:http/http.dart' as http;

class AllowLocation extends StatefulWidget {
  const AllowLocation({
    Key? key,
  }) : super(key: key);

  @override
  State<AllowLocation> createState() => _AllowLocationState();
}

class _AllowLocationState extends State<AllowLocation> {
  bool _filled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_filled == false) {
                  return;
                }

                await signUp();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                side: BorderSide(
                  width: 2.0,
                  color: _filled
                      ? const Color(0xFFFFC800)
                      : const Color(0xFFE9E9E9),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'complete'.tr,
                style: TextStyle(
                  color: _filled
                      ? const Color(0xFFFFC800)
                      : const Color(0xFFE9E9E9),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Image.asset('assets/images/allow_location.png',
                          fit: BoxFit.fitWidth)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'STEP 5/5',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFFFC000),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 80),
                    Text(
                      'allow_location'.tr,
                      style: const TextStyle(
                        fontSize: 33,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'allow_location_desc'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF8E8E8E),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Visibility(
                visible: _filled ? false : true,
                child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: Text(
                        'allow_location'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await _determinePosition();

                        Position position = await Geolocator.getCurrentPosition();
                        String address = await getAddressFromLatLng(position.latitude, position.longitude);

                        SubscriberInfo info = SubscriberInfo();
                        info.latitude = position.latitude;
                        info.longitude = position.longitude;
                        info.address = address;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    setState(() {
      _filled = true;
    });

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks[0];
    String address = '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}';
    return address;
  }

  /*
  {
    "memberPhone": "010-1234-1234",
    "memberName": "테스트",
    "memberBirthday": "19900101",
    "memberIntro": "테스트 입니다.",
    "memberHeight": "180",
    "bodyInfo": "탄탄한",
    "language": "광둥어",
    "drinkInfo": "가끔",
    "smokingInfo": "가끔",
    "memberTendencyCd": "T0000",
    "searchTendencyCd1": "T0000",
    "searchTendencyCd2": "T0000",
    "searchTendencyCd3": "T0000"
  }
   */
  Future<void> signUp() async {
    SubscriberInfo info = SubscriberInfo();

    final msg = jsonEncode({
      "memberPhone": info.phoneNumber,
      "memberName": info.name,
      "memberBirthday": info.birthDay?.replaceAll('/', ''),
      "memberIntro": info.aboutMe,
      "memberHeight": info.height.toString(),
      "bodyInfo": info.bodyType,
      "language": info.languageSpoken,
      "drinkInfo": info.drink,
      "smokingInfo": info.smoking,
      "memberTendencyCd": info.iam,
      "searchTendencyCd1": info.toFind[0],
      "searchTendencyCd2": info.toFind.length > 1 && info.toFind[1].isNotEmpty ? info.toFind[1] : "",
      "searchTendencyCd3": info.toFind.length > 2 && info.toFind[2].isNotEmpty ? info.toFind[2] : "",
    });

    String url = BASE_URL + '/member/joinMember';
    var response = await http.post(Uri.parse(url),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
      },
      body: msg,
    );

    /*
    {
      "resultCode": "200",
      "resultMessage": "string",
      "data": {
        "memberId": "string"
      }
    }
     */
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['resultCode'] == 200) {
        var memberId = jsonResponse['data']['memberId'];
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('memberId', memberId);
          prefs.setBool('isLogged', true);
        });

      }

      Get.offAll(() => const MainView());

    } else {
      // 요청이 실패함
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
