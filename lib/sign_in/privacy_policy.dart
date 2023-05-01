import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _TermsState();
}

class _TermsState extends State<PrivacyPolicy> {
  String fileContent = '';

  @override
  void initState() {
    super.initState();
    readFile();
  }

  Future<void> readFile() async {
    try {
      String content =
          await rootBundle.loadString('assets/privacy_policy_kr.txt');
      setState(() {
        fileContent = content;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to read file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'terms_agree4'.tr,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(fileContent),
        ),
      ),
    );
  }
}
