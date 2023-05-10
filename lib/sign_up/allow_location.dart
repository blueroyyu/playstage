import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import 'package:playstage/const.dart';
import 'package:playstage/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playstage/utils/loader.dart';
import 'subscriber_info.dart';
import 'package:playstage/people/main_view.dart';

import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as fd;
import 'package:dio/src/multipart_file.dart' as mf;

class AllowLocation extends StatefulWidget {
  const AllowLocation({
    Key? key,
  }) : super(key: key);

  @override
  State<AllowLocation> createState() => _AllowLocationState();
}

class _AllowLocationState extends State<AllowLocation> {
  bool _filled = false;
  bool _isLoading = false;

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

                        Position position =
                            await Geolocator.getCurrentPosition();
                        String address = await getAddressFromLatLng(
                            position.latitude, position.longitude);

                        SubscriberInfo info = SubscriberInfo();
                        info.latitude = position.latitude;
                        info.longitude = position.longitude;
                        info.address = address;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                  child:
                      _isLoading ? const Loader(loadingTxt: '') : Container()),
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
    latitude	[...]
    longitude	[...]
    address	[...]
    address2	[...]
    address3	[...]
    ci	[...]
  }
   */
  Future<void> signUp() async {
    SubscriberInfo info = SubscriberInfo();

    final jsonData = jsonEncode({
      "memberPhone": info.phoneNumber,
      "memberName": info.name,
      "memberBirthday": info.birthDay!.replaceAll('/', ''),
      "memberIntro": info.aboutMe,
      "memberHeight": info.height?.toString() ?? "",
      "bodyInfo": info.bodyType ?? "",
      "language": info.languageSpoken ?? "",
      "drinkInfo": info.drink ?? "",
      "smokingInfo": info.smoking ?? "",
      "memberTendencyCd": info.iam,
      "searchTendencyCd1": info.toFind[0],
      "searchTendencyCd2": info.toFind.length > 1 && info.toFind[1].isNotEmpty
          ? info.toFind[1]
          : "",
      "searchTendencyCd3": info.toFind.length > 2 && info.toFind[2].isNotEmpty
          ? info.toFind[2]
          : "",
      "latitude": info.latitude.toString(),
      "longitude": info.longitude.toString(),
      "address": info.address ?? "",
      "address2": info.address2 ?? "",
      "address3": info.address3 ?? "",
      "ci": info.ci ?? info.phoneNumber, // TODO: 본인인증
    });

    try {
      final dio = Dio();
      final formData = fd.FormData();

      final files = info.profileImages;
      for (final file in files) {
        if (file.isEmpty) {
          continue;
        }

        formData.files.add(MapEntry(
          'files',
          await mf.MultipartFile.fromFile(file),
        ));
      }

      formData.fields.add(MapEntry('joinMemberReqDto', jsonData));

      setState(() {
        _isLoading = true;
      });

      final response = await dio.post(
        '$baseUrl/member/joinMember',
        data: formData,
      );

      setState(() {
        _isLoading = false;
      });

      final responseData = json.decode(response.toString());

      if (responseData['resultCode'] == '200') {
        var memberId = responseData['data']['memberId'];
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString(keyUserId, memberId);
          prefs.setBool(keyLoggedIn, true);

          Get.offAll(() => const MainView());
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      if (kDebugMode) {
        print(error);
      }

      Get.showSnackbar(GetSnackBar(message: 'try_again'.tr));
    }
  }
}
