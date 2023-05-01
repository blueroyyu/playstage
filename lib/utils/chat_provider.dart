import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class CharProvider {
  static final CharProvider _instance = CharProvider._internal();

  factory CharProvider() {
    return _instance;
  }

  late final SendbirdSdk _sendbird;
  CharProvider._internal() {
    _sendbird = SendbirdSdk(appId: '2A9E213D-FD3F-40E3-9AC4-29F7527F09CD');
  }

  Future<User> login({
    required String userId,
    String? nickName,
  }) async {
    try {
      final user = await _sendbird.connect(
        userId,
        nickname: nickName,
      );
      // final token = appState.token;
      //
      // // [Push Notification Set Up]
      // // register push notification token for sendbird notification
      // if (token != null) {
      //   if (kDebugMode) {
      //     print('registering push token through sendbird server...');
      //   }
      //   var result = await _sendbird.registerPushToken(
      //     type: kIsWeb
      //         ? PushTokenType.none
      //         : Platform.isIOS
      //         ? PushTokenType.apns
      //         : PushTokenType.fcm,
      //     token: token,
      //   );
      //   // Result for register Push Token
      //   // [success, pending, error]
      //   if (kDebugMode) {
      //     print(result);
      //   }
      // }

      return user;
    } catch (e) {
      throw Exception([e, 'Connecting with Sendbird Server has failed']);
    }
  }
}
