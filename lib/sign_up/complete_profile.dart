import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'subscriber_info.dart';
import 'select_popup.dart';
import 'add_photo.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool _filled = true;

  String _height = "";
  String _bodyType = "";
  String _langSpoken = "";
  String _drink = "";
  String _cigarette = "";

  final ScrollController _scrollController = ScrollController();

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

                Get.to(const AddPhoto());
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                side: BorderSide(
                  width: 2.0,
                  color: _filled ? const Color(0xFFFFC800) : const Color(0xFFE9E9E9),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'skip'.tr,
                style: TextStyle(
                  color: _filled ? const Color(0xFFFFC800) : const Color(0xFFE9E9E9),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'STEP 3/5',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFC000),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 80),
                Text(
                  'complete_profile'.tr,
                  style: const TextStyle(
                    fontSize: 33,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'complete_after_desc'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
                const SizedBox(height: 80),
                Text(
                  'height'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showHeightPopup();
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
                          _height,
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
                const SizedBox(height: 20),
                Text(
                  'body_type'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showBodyTypePopup();
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
                          _bodyType,
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
                const SizedBox(height: 20),
                Text(
                  'language_spoken'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showLanguagePopup();
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
                          _langSpoken,
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
                const SizedBox(height: 20),
                Text(
                  'drinking'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showDrinkingPopup();
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
                          _drink,
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
                const SizedBox(height: 20),
                Text(
                  'cigarettes'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showCigarettePopup();
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
                          _cigarette,
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
      ),
    );
  }

  void _showHeightPopup() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int height = 170;
        return AlertDialog(
          title: const Text('Select your height'),
          content: Container(
            height: 200.0,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: 50),
              itemExtent: 32.0,
              onSelectedItemChanged: (int index) {
                height = 110 + index;
              },
              children: List<Widget>.generate(140, (int index) {
                return Text('${110 + index} cm');
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Handle the selected height value here
                print('Selected height: $height');

                SubscriberInfo info = SubscriberInfo();

                setState(() {
                  _height = '$height cm';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBodyTypePopup() async {
    final selectedCodes = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return SelectPopup(
          title: 'body_type'.tr,
          length: 1,
          codes: bodyTypes,
        );
      },
    );

    SubscriberInfo info = SubscriberInfo();
    info.bodyType = null;

    if (selectedCodes != null) {
      info.bodyType = bodyTypes[selectedCodes[0]]['code'];
      setState(() {
        _bodyType = bodyTypes[selectedCodes[0]]['label']!;
      });
    } else {
      setState(() {
        _bodyType = "";
      });
    }
  }

  void _showLanguagePopup() async {
    final selectedCodes = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return SelectPopup(
          title: 'language_spoken'.tr,
          length: 1,
          codes: languages,
        );
      },
    );

    SubscriberInfo info = SubscriberInfo();
    info.languageSpoken = null;

    if (selectedCodes != null) {
      info.languageSpoken = languages[selectedCodes[0]]['code'];
      setState(() {
        _langSpoken = languages[selectedCodes[0]]['label']!;
      });
    } else {
      setState(() {
        _langSpoken = "";
      });
    }
  }

  void _showDrinkingPopup() async {
    final selectedCodes = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return SelectPopup(
          title: 'drinking'.tr,
          length: 1,
          codes: frequencies,
        );
      },
    );

    SubscriberInfo info = SubscriberInfo();
    info.drink = null;

    if (selectedCodes != null) {
      info.drink = frequencies[selectedCodes[0]]['code'];
      setState(() {
        _drink = frequencies[selectedCodes[0]]['label']!;
      });
    } else {
      setState(() {
        _drink = "";
      });
    }
  }

  void _showCigarettePopup() async {
    final selectedCodes = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return SelectPopup(
          title: 'cigarettes'.tr,
          length: 1,
          codes: frequencies,
        );
      },
    );

    SubscriberInfo info = SubscriberInfo();
    info.smoking = null;

    if (selectedCodes != null) {
      info.smoking = frequencies[selectedCodes[0]]['code'];
      setState(() {
        _cigarette = frequencies[selectedCodes[0]]['label']!;
      });
    } else {
      setState(() {
        _cigarette = "";
      });
    }
  }
}
