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
            const SizedBox(height: 60.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Playstage Co.,Ltd',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Business Registration No.: 637-03-02344',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Email: maychoice@naver.com',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Mobile: 010-7586-8888',
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
