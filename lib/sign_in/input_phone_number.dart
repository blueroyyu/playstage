import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'input_auth_code.dart';
import 'package:playstage/sign_up/subscriber_info.dart';
import 'package:playstage/const.dart';
import 'package:http/http.dart' as http;

class InputPhoneNumber extends StatefulWidget {
  const InputPhoneNumber({Key? key}) : super(key: key);

  @override
  State<InputPhoneNumber> createState() => _InputPhoneNumberState();
}

class _InputPhoneNumberState extends State<InputPhoneNumber> {
  bool _filled = false;

  PhoneNumber? phoneNumber;

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

                await requestSmsAuth();
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
                'input_phonenumber'.tr,
                style: const TextStyle(
                  fontSize: 33,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 127),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'input_phonenumber'.tr,
                  labelStyle: const TextStyle(
                    color: Color(0xFF8E8E8E),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'KR',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  if (phone.number.length >= 11) {
                    setState(() {
                      _filled = true;
                      phoneNumber = phone;
                    });
                  } else {
                    setState(() {
                      _filled = false;
                    });
                  }
                },
                onCountryChanged: (country) {
                  if (kDebugMode) {
                    print('Country changed to: ${country.name}');
                  }
                },
              ),
              const SizedBox(height: 70),
              Text(
                'input_phonenumber_detail'.tr,
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

  Future<void> requestSmsAuth() async {
    String unformatted = phoneNumber!.number;
    String number = '${unformatted.substring(0, 3)}-${unformatted.substring(3, 7)}-${unformatted.substring(7, 11)}';
    final msg = jsonEncode({"authValue": number});

    String url = '$baseUrl/member/smsAuth';
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
      "resultMessage": "",
      "data": {
        "isMember": false,
        "authNumber": "434566"
      }
    }
     */
    if (response.statusCode == 200) {
      // 요청이 성공적으로 처리됨
      var jsonResponse = json.decode(response.body);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('ID: ${jsonResponse['data']['authNumber']}');
      }

      Get.to(() => InputAuthCode(
            phoneNumber: number,
            authCode: jsonResponse['data']['authNumber'],
            isMember: jsonResponse['data']['isMember'],
          ));
    } else {
      // 요청이 실패함
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }
}
