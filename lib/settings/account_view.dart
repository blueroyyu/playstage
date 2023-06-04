import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text('account'.tr,
            style: const TextStyle(
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                CupertinoIcons.square_arrow_left,
                size: 30.0,
              ),
              title: Text(
                'log_out'.tr,
                style: const TextStyle(fontSize: 20.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                dynamic ret =
                    await showAlert(context, '로그아웃 하시겠습니까?', showCancel: true);

                if (ret) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove(keyUserId);
                  prefs.remove(keyLoggedIn);
                  prefs.remove(keyUseBiometrics);
                  prefs.remove(keyPushToken);

                  Get.showSnackbar(const GetSnackBar(message: '로그아웃 했습니다.'));

                  Get.offAllNamed('/sign_in');
                }
              },
            ),
            // ListTile(
            //   title: Text(
            //     'delete_account'.tr,
            //     style: const TextStyle(
            //       fontSize: 20.0,
            //       color: Colors.red,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
