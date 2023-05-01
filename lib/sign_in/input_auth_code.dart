import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:playstage/people/main_view.dart';
import 'package:playstage/sign_up/select_tendency.dart';
import 'package:playstage/sign_up/subscriber_info.dart';

class InputAuthCode extends StatefulWidget {
  const InputAuthCode({
    Key? key,
    required this.phoneNumber,
    required this.authCode,
    required this.isMember,
  }) : super(key: key);

  final String phoneNumber;
  final String authCode;
  final bool isMember;

  @override
  State<InputAuthCode> createState() => _InputAuthCodeState();
}

class _InputAuthCodeState extends State<InputAuthCode> {
  bool _filled = false;

  String _pin = '';

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

                if (_pin == widget.authCode) {
                  if (widget.isMember) {
                    Get.offAll(() => const MainView());
                  } else {
                    SubscriberInfo info = SubscriberInfo();
                    info.phoneNumber = widget.phoneNumber;

                    Get.to(() => const SelectTendency());
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('check_auth_code'.tr),
                  ));
                }
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
              const SizedBox(height: 80),
              Text(
                'input_auth_code'.tr,
                style: const TextStyle(
                  fontSize: 33,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 102),
              Pinput(
                length: 6,
                onCompleted: (pin) {
                  _pin = pin;
                  setState(() {
                    _filled = true;
                  });
                  if (kDebugMode) {
                    print(pin);
                  }
                },
              ),
              const SizedBox(height: 70),
              Text(
                widget.phoneNumber + 'input_auth_code_detail'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8E8E8E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
