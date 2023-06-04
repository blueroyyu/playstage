import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subscriber_info.dart';
import 'complete_profile.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  bool _filled = false;

  final TextEditingController _controller = TextEditingController();
  final int _characterLimit = 15;

  String _name = '';
  String _birthDay = '';
  // final String _df = "yyyy/MM/dd";

  String _aboutMe = '';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SubscriberInfo si = SubscriberInfo();
    setState(() {
      _name = si.certInfo!.name!;
      _controller.text = _name;
      _birthDay = si.certInfo!.birthday!;
    });
  }

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

                SubscriberInfo info = SubscriberInfo();
                info.aboutMe = _aboutMe;

                Get.to(const CompleteProfile());
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
                  'STEP 2/5',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFC000),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 80),
                Text(
                  'create_profile'.tr,
                  style: const TextStyle(
                    fontSize: 33,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 92),
                Text(
                  'name'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _controller,
                  readOnly: true,
                  maxLength: _characterLimit,
                  // onChanged: (value) {
                  //   _name = value;

                  //   if (_name.isNotEmpty &&
                  //       _birthDay.isNotEmpty &&
                  //       _aboutMe.isNotEmpty) {
                  //     setState(() {
                  //       _filled = true;
                  //     });
                  //   }
                  // },
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'input_name'.tr,
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF8E8E8E),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'birthday'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  // onTap: () async {
                  // DateTime? selectedDate = await _selectDate(context);
                  // if (selectedDate != null) {
                  //   if (kDebugMode) {
                  //     print(selectedDate.toString());
                  //   }
                  //   setState(() {
                  //     _birthDay = DateFormat(_df).format(selectedDate);

                  //     if (_name.isNotEmpty &&
                  //         _birthDay.isNotEmpty &&
                  //         _aboutMe.isNotEmpty) {
                  //       _filled = true;
                  //     }
                  //   });
                  // }
                  // },
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
                          _birthDay,
                          style: const TextStyle(
                            fontSize: 15.0,
                            // color: _birthDay == _df
                            //     ? const Color(0xFF8E8E8E)
                            //     : Colors.black,
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
                const SizedBox(height: 40),
                Text(
                  'about_me'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    maxLines: null,
                    maxLength: 50,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      hintText: 'input_after_touch'.tr,
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF8E8E8E),
                      ),
                    ),
                    onChanged: (value) {
                      _aboutMe = value;

                      if (_name.isNotEmpty &&
                          _birthDay.isNotEmpty &&
                          _aboutMe.isNotEmpty) {
                        setState(() {
                          _filled = true;
                        });
                      }
                    },
                    onTap: () {
                      _scrollController.animateTo(120.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    return picked;
  }

// Future<DateTime?> _selectDate(BuildContext context) async {
//   final DateTime? picked = await showCupertinoModalPopup(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         height: 300,
//         child: CupertinoDatePicker(
//           mode: CupertinoDatePickerMode.date,
//           initialDateTime: DateTime.now(),
//           minimumDate: DateTime(1900),
//           maximumDate: DateTime.now(),
//           onDateTimeChanged: (DateTime dateTime) {
//             // Do something with the selected date
//           },
//         ),
//       );
//     },
//   );
//   return picked;
// }

// Future<DateTime?> _selectDate(BuildContext context) async {
//   DateTime? selectedDate;
//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return CupertinoAlertDialog(
//         content: Container(
//           height: 200,
//           child: CupertinoDatePicker(
//             mode: CupertinoDatePickerMode.date,
//             initialDateTime: DateTime.now(),
//             onDateTimeChanged: (DateTime newDateTime) {
//               selectedDate = newDateTime;
//             },
//           ),
//         ),
//         actions: [
//           CupertinoDialogAction(
//             child: Text('Done'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
//   return selectedDate;
// }

// void _showIamPopup() async {
//   final selectedCodes = await showDialog<List<int>>(
//     context: context,
//     builder: (context) {
//       return SelectPopup(
//         title: 'iam'.tr,
//         length: 1,
//         codes: tendencies,
//       );
//     },
//   );
//
//   SubscriberInfo info = SubscriberInfo();
//   info.iam = null;
//
//   if (selectedCodes != null) {
//     info.iam = tendencies[selectedCodes[0]]['code'];
//     setState(() {
//       _myTendency = tendencies[selectedCodes[0]]['label'];
//       _filled = info.toFind.length > 0;
//     });
//   } else {
//     setState(() {
//       _myTendency = "";
//       _filled = false;
//     });
//   }
// }
//
// void _showToFindPopup() async {
//   final selectedCodes = await showDialog<List<int>>(
//     context: context,
//     builder: (context) {
//       return SelectPopup(
//         title: 'find_tendency'.tr,
//         length: 3,
//         codes: tendencies,
//       );
//     },
//   );
//
//   SubscriberInfo info = SubscriberInfo();
//   info.toFind.clear();
//
//   if (selectedCodes != null) {
//     String tendency = "";
//     for (int index in selectedCodes) {
//       info.toFind.add(tendencies[index]['code']!);
//       tendency += tendencies[index]['label']! + ', ';
//     }
//
//     tendency = tendency.substring(0, tendency.length - 2);
//     setState(() {
//       _toFindTendency = tendency;
//       _filled = info.iam != null;
//     });
//   } else {
//     setState(() {
//       _toFindTendency = "";
//       _filled = false;
//     });
//   }
// }
}
