import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/sign_in/privacy_policy.dart';
import 'package:playstage/sign_in/terms.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text('about'.tr,
            style: const TextStyle(
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'terms_agree2'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(const Terms());
              },
            ),
            ListTile(
              title: Text(
                'terms_agree4'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(const PrivacyPolicy());
              },
            ),
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text(
                    '주식회사 라인온(Line on)',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '대표: 김상경외 1명 | 사업자등록번호: 637-03-02344',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '고객센터: 032-655-2212',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '이메일: playstage.m@gmail.com',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    '경기도 부천시 상동400 다모아빌딩 901호',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
