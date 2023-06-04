import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:playstage/sign_up/subscriber_info.dart';
import 'package:playstage/utils/auth_provider.dart';

import '../models/certification_info/certification_info.dart';
import 'select_tendency.dart';

class Certification extends StatelessWidget {
  static const String userCode = 'imp30884633';

  const Certification({super.key});

  @override
  Widget build(BuildContext context) {
    CertificationData data = Get.arguments as CertificationData;

    return IamportCertification(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          '본인인증',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      initialChild: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/app_icon.png'),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
      ),
      userCode: userCode,
      data: data,
      callback: (Map<String, String> result) async {
        // Get.offNamed('/certification_result', arguments: result);
        if (kDebugMode) {
          print(result);
        }

        if (result['success'] == 'true') {
          final impUid = result['imp_uid'];

          try {
            dynamic res = await AuthProvider.requestGetToken();
            String token = res['access_token'] ?? '';
            if (token.isNotEmpty) {
              AuthProvider.accessToken = token;
            }

            res = await AuthProvider.requestCertifications(impUid!);

            CertificationInfo certInfo = CertificationInfo.fromJson(res);
            if (kDebugMode) {
              print(certInfo.toString());
            }

            SubscriberInfo si = SubscriberInfo();
            si.certInfo = certInfo;

            Get.off(() => const SelectTendency());
          } on Exception catch (e) {
            if (kDebugMode) {
              print(e);
            }

            if (e is DioError) {
              DioError de = e;
              if (kDebugMode) {
                print(de);
              }
            }

            Get.snackbar('error'.tr, '본인인증에 실패하였습니다.');

            Get.offAllNamed('/sign_in');
          }
        } else {
          final errorMsg = result['error_msg'] ?? '본인인증에 실패하였습니다.';
          Get.snackbar('error'.tr, errorMsg);
        }

        // SubscriberInfo info = SubscriberInfo();
        //             info.phoneNumber = widget.phoneNumber;

        //             Get.to(() => const SelectTendency());
      },
    );
  }
}
/*
{
    "code": 0,
    "message": null,
    "response": {
        "birth": 216140400,
        "birthday": "1976-11-07",
        "certified": true,
        "certified_at": 1685719311,
        "foreigner": false,
        "foreigner_v2": null,
        "gender": "male",
        "imp_uid": "imp_045262694732",
        "merchant_uid": "mid_1685719260995",
        "name": "유승민",
        "origin": "data:text/html,%20%20%20%20%3Chtml%3E%0A%20%20%20%20%20%20%3Chead%3E%0A%20%20%20%20%20%20%20%20%3Cmeta%20http-equiv=%22content-type%22%20content=%22text/html;%20charset=utf-8%22%3E%0A%20%20%20%20%20%20%20%20%3Cmeta%20name=%22viewport%22%20content=%22width=device-width,%20initial-scale=1.0,%20user-scalable=no%22%3E%0A%0A%20%20%20%20%20%20%20%20%3Cscript%20type=%22text/javascript%22%20src=%22https://cdn.iamport.kr/v1/iamport.js%22%3E%3C/script%3E%0A%20%20%20%20%20%20%3C/head%3E%0A%20%20%20%20%20%20%3Cbody%3E%3C/body%3E%0A%20%20%20%20%3C/html%3E%0A%20%20",
        "pg_provider": "danal",
        "pg_tid": "202306030021027306905010",
        "unique_in_site": "MC0GCCqGSIb3DQIJAyEA/AzAjgcGfSPoSTpVn+aihq1eaa8zx/EN2XBQZq7iVrs=",
        "unique_key": "ZDo+VKGzg9rUhqX8x4i1eyoUn2HMuW9KIcz7cqBsTvg4mefGRfjK616QN1dscS7VcNesLCieTYwOC5VVexYGgA=="
    }
}
 */