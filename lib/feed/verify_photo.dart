import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';

class VerifyPhoto extends StatelessWidget {
  const VerifyPhoto({super.key, required this.title, required this.path});

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () async {
                Get.back(result: true);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorTabBottom,
              ),
              child: Text(
                'add'.tr,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  'photo_warning'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'photo_warning_detail'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
