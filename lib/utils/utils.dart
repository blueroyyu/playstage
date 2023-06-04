import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

Future<dynamic> authenticate() async {
  final LocalAuthentication auth = LocalAuthentication();

  final bool canCheckBiometrics = await auth.canCheckBiometrics;
  final bool canAuthenticate =
      canCheckBiometrics || await auth.isDeviceSupported();

  var authenticated = false;

  try {
    if (canAuthenticate) {
      authenticated = await auth.authenticate(
        localizedReason: '서비스 사용을 위해 인증이 필요합니다.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
        ),
      );
    }

    return authenticated;
  } on PlatformException catch (pe) {
    if (pe.code == auth_error.notAvailable) {}
    return false;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    rethrow;
  }
}

Future<dynamic> showAlert(BuildContext context, String message,
    {bool showCancel = false}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('ok'.tr),
        ),
        showCancel
            ? TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('cancel'.tr),
              )
            : Container(),
      ],
    ),
  );
}
