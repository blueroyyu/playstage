import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/settings/about_view.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
      body: Column(
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
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
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
    ));
  }
}
