import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
import '../utils/api_provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final TextEditingController _controller = TextEditingController();
  final _characterLimit = 8;

  bool _filled = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text('계정 삭제'.tr,
            style: const TextStyle(
              color: Colors.black,
            )),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Text(
              'birthday'.tr,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                maxLength: _characterLimit,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _filled = true;
                  });
                },
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: '가입 시 인증한 생년월일을 입력하세요.(YYYYMMDD)'.tr,
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
                validator: (value) {
                  if (value != SharedData().owner!.memberBirthday) {
                    return '가입 시 인증한 생년월일이 아닙니다.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
                '계정 삭제 시 해당 앱 내의 사진, 메시지 그리고 프로필 등은 모두 영구적으로 삭제됩니다.\n삭제 후 동일 정보를 이용한 재가입은 30일간 제한됩니다.'
                    .tr),
            const SizedBox(height: 30),
            Text(
              '※ 삭제 시 돌이킬 수 없습니다.'.tr,
              style: const TextStyle(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_filled == false) {
                    return;
                  }

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await showAlert(context, '계정을 정말로 삭제하시겠습니까?',
                            showCancel: true)
                        .then((value) async {
                      if (value) {
                        try {
                          dynamic res = await ApiProvider.requestDeleteMember(
                              SharedData().owner!.memberSeq!);
                          final data = res['data'];
                          if (data) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove(keyUserId);
                            prefs.remove(keyLoggedIn);
                            prefs.remove(keyUseBiometrics);
                            prefs.remove(keyPushToken);

                            Get.showSnackbar(
                                const GetSnackBar(message: '계정을 삭제 했습니다.'));

                            Get.offAllNamed('/sign_in');
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  side: BorderSide(
                    width: 2.0,
                    color: _filled ? Colors.red : const Color(0xFFE9E9E9),
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: const Size(174, 40),
                ),
                child: Text(
                  '계정 삭제'.tr,
                  style: TextStyle(
                    color: _filled ? Colors.red : const Color(0xFFE9E9E9),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
