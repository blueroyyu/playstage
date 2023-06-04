import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/sign_in/privacy_policy.dart';
import 'package:playstage/sign_in/terms.dart';
import 'package:playstage/factory.dart';

import 'dart:io' show Platform;

import 'input_phone_number.dart';

enum LanguageMenuItem { itemOne, itemTwo, itemThree }

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  LanguageMenuItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0xff, 0xc8, 0x00),
      // 배경색을 노란색으로 설정합니다.
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 258,
                  // 이미지의 가로 크기
                  height: 258,
                  // 이미지의 세로 크기
                  margin: const EdgeInsets.only(top: 120),
                  // 위쪽에 120픽셀의 여백을 추가합니다.
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      // 이미지 파일 경로
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 77),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'terms_agree1'.tr,
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'terms_agree2'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const Terms());
                            },
                        ),
                        TextSpan(
                          text: 'terms_agree3'.tr,
                        ),
                        TextSpan(
                          text: 'terms_agree4'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const PrivacyPolicy());
                            },
                        ),
                        TextSpan(
                          text: 'terms_agree5'.tr,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height < 620 ? 50 : 100),
                iconButton(
                  icon: Icon(
                    Platform.isAndroid
                        ? Icons.phone_android
                        : Icons.phone_iphone,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  label: Text(
                    'continue_phone'.tr,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    // var merchantUid =
                    //     'mid_${DateTime.now().millisecondsSinceEpoch}';

                    // CertificationData data = CertificationData(
                    //   merchantUid: merchantUid,
                    // );

                    // Get.toNamed('/certification', arguments: data);

                    // Get.to(const VerifyIdentity());
                    Get.to(const InputPhoneNumber());
                    // Get.to(const MainView());
                  },
                ),
              ],
            ),
            Positioned(
              top: 50,
              right: 20,
              child: Visibility(
                visible: false,
                child: PopupMenuButton<LanguageMenuItem>(
                  initialValue: selectedMenu,
                  // Callback that sets the selected popup menu item.
                  onSelected: (LanguageMenuItem item) {
                    setState(() {
                      selectedMenu = item;
                      if (item == LanguageMenuItem.itemOne) {
                        Get.updateLocale(const Locale('ko', 'KR'));
                      } else if (item == LanguageMenuItem.itemTwo) {
                        Get.updateLocale(const Locale('en', 'US'));
                      } else if (item == LanguageMenuItem.itemThree) {
                        Get.updateLocale(const Locale('zh', 'Hans'));
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<LanguageMenuItem>>[
                    PopupMenuItem<LanguageMenuItem>(
                      value: LanguageMenuItem.itemOne,
                      child: Text(
                        'lang0'.tr,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    PopupMenuItem<LanguageMenuItem>(
                      value: LanguageMenuItem.itemTwo,
                      child: Text(
                        'lang1'.tr,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    PopupMenuItem<LanguageMenuItem>(
                      value: LanguageMenuItem.itemThree,
                      child: Text(
                        'lang2'.tr,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
