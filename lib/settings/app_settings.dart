import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playstage/settings/write_inquiry_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:playstage/settings/about_view.dart';
import 'package:playstage/settings/account_view.dart';

import 'block_info_list.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text('app_settings'.tr,
            style: const TextStyle(
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                CupertinoIcons.person,
                size: 30.0,
              ),
              title: Text(
                'account'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(() => const AccountView());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications_active_outlined,
                size: 30.0,
              ),
              title: Text(
                'notice'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (Platform.isIOS) {
                  launchUrl(Uri.parse('app-settings:'));
                } else if (Platform.isAndroid) {
                  launchUrl(Uri.parse('package:com.android.settings'));
                }
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.nosign,
                size: 30.0,
              ),
              title: Text(
                'prevented_list'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                Get.to(() => const BlockInfoList());
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.phone,
                size: 30.0,
              ),
              title: Text(
                'qa'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(() => const WriteInquiryView());
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.question_circle,
                size: 30.0,
              ),
              title: Text(
                'about'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(() => const AboutView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
