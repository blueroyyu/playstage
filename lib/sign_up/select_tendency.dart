import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subscriber_info.dart';
import 'select_popup.dart';
import 'create_profile.dart';

class SelectTendency extends StatefulWidget {
  const SelectTendency({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectTendency> createState() => _SelectTendencyState();
}

class _SelectTendencyState extends State<SelectTendency> {
  bool _filled = false;
  String? _myTendency;
  String? _toFindTendency;

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
              onPressed: () {
                if (_filled == false) {
                  return;
                }

                Get.to(const CreateProfile());
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
                'next'.tr,
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
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'STEP 1/5',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFFC000),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 80),
              Text(
                'iam'.tr,
                style: const TextStyle(
                  fontSize: 33,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'no_change_within_30d'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8E8E8E),
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: () {
                  _showIamPopup();
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _myTendency ?? "",
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Text(
                'find_tendency'.tr,
                style: const TextStyle(
                  fontSize: 33,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'up_to_3'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8E8E8E),
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: () {
                  _showToFindPopup();
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _toFindTendency ?? "",
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIamPopup() async {
    final selectedCodes = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return SelectPopup(
          title: 'iam'.tr,
          length: 1,
          codes: tendencies,
        );
      },
    );

    SubscriberInfo info = SubscriberInfo();
    info.iam = null;

    if (selectedCodes != null) {
      info.iam = tendencies[selectedCodes[0]]['code'];
      setState(() {
        _myTendency = tendencies[selectedCodes[0]]['label'];
        _filled = info.toFind.isNotEmpty;
      });
    } else {
      setState(() {
        _myTendency = "";
        _filled = false;
      });
    }
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

    SubscriberInfo info = SubscriberInfo();
    info.toFind.clear();

    if (selectedCodes != null) {
      String tendency = "";
      for (int index in selectedCodes) {
        info.toFind.add(tendencies[index]['code']!);
        tendency += '${tendencies[index]['label']!}, ';
      }

      tendency = tendency.substring(0, tendency.length - 2);
      setState(() {
        _toFindTendency = tendency;
        _filled = info.iam != null;
      });
    } else {
      setState(() {
        _toFindTendency = "";
        _filled = false;
      });
    }
  }
}
