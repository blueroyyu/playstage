import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/sign_up/select_popup.dart';
import 'package:playstage/sign_up/subscriber_info.dart';
import 'package:playstage/utils/api_provider.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  String _location = '';
  RangeValues _ageRange = const RangeValues(30, 50);
  double _distance = 5.0;
  String _toFindTendency = '';

  @override
  void initState() {
    super.initState();

    SharedData sd = SharedData();
    MemberInfoEntity member = sd.owner!;
    setState(() {
      _toFindTendency = member.searchTendency();
      _ageRange = RangeValues(sd.fromAge.toDouble(), sd.toAge.toDouble());
      _distance = sd.distance.toDouble();
    });

    _loadLocation();
  }

  Future<void> _loadLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      String address =
          await getAddressFromLatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _location = address;
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'filter'.tr,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              SharedData().fromAge = _ageRange.start.round();
              SharedData().toAge = _ageRange.end.round();
              SharedData().distance = _distance.round();

              try {
                await ApiProvider.requestUpdateMember(SharedData().owner!);
              } on Exception catch (e) {
                if (kDebugMode) {
                  print(e);
                }

                rethrow;
              }

              Get.back(result: true);
            },
            icon: const Icon(
              Icons.check,
              color: colorTabBottom,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          ListTile(
            // onTap: () {},
            title: Text(
              'location'.tr,
              style: const TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(_location),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            onTap: () {
              _showToFindPopup();
            },
            title: Text(
              'find_tendency'.tr,
              style: const TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(_toFindTendency),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20.0),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'age'.tr,
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Spacer(),
                Text(
                  '${_ageRange.start.round().toString()} - ${_ageRange.end.round() > 70 ? '70+' : _ageRange.end.round().toString()}',
                ),
              ],
            ),
            subtitle: RangeSlider(
              values: _ageRange,
              activeColor: colorTabBottom,
              inactiveColor: colorSlderInactive,
              onChanged: (RangeValues values) {
                setState(() {
                  _ageRange = values;
                });
              },
              min: 19,
              max: 71,
            ),
          ),
          const SizedBox(height: 20.0),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'distance'.tr,
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Spacer(),
                Text(
                  _distance.round() > 499
                      ? 'unlimited'.tr
                      : '${_distance.round()} km',
                ),
              ],
            ),
            subtitle: Slider(
              value: _distance,
              activeColor: colorTabBottom,
              inactiveColor: colorSlderInactive,
              onChanged: (value) {
                setState(() {
                  _distance = value;
                });
              },
              min: 5,
              max: 500,
            ),
          ),
        ],
      )),
    );
  }

  void _showToFindPopup() async {
    final selectedCodes = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return SelectPopup(
          title: 'find_tendency'.tr,
          length: 3,
          codes: tendencies,
        );
      },
    );

    if (selectedCodes != null) {
      int i = 0;
      for (int index in selectedCodes) {
        switch (i) {
          case 0:
            SharedData().owner!.searchTendencyCd1 = tendencies[index]['code']!;
            break;
          case 1:
            SharedData().owner!.searchTendencyCd2 = tendencies[index]['code']!;
            break;
          case 2:
            SharedData().owner!.searchTendencyCd3 = tendencies[index]['code']!;
            break;
          default:
        }

        i++;
      }

      setState(() {
        _toFindTendency = SharedData().owner!.searchTendency();
      });
    }
  }
}
