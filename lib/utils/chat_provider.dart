import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatProvider {
  static final ChatProvider _instance = ChatProvider._internal();

  factory ChatProvider() {
    return _instance;
  }

  late final SendbirdSdk _sendbird;
  ChatProvider._internal() {
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

      return user;
    } catch (e) {
      throw Exception([e, 'Connecting with Sendbird Server has failed']);
    }
  }

  Future<GroupChannel> createChannel(List<String> userIds) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String channelUrl =
      //     prefs.getString('$keyChatChannel${userIds.last}') ?? '';

      GroupChannel channel;
      // if (channelUrl.isNotEmpty) {
      //   channel = await GroupChannel.getChannel(channelUrl);
      // } else {
      final params = GroupChannelParams()
        ..isDistinct = true
        ..userIds = userIds;
      channel = await GroupChannel.createChannel(params);

      // bool bRet = await prefs.setString(
      //     '$keyChatChannel${userIds.last}', channel.channelUrl);
      // if (kDebugMode) {
      //   print(bRet);
      // }
      // }

      return channel;
    } catch (e) {
      if (kDebugMode) {
        print('createChannel: ERROR: $e');
      }
      rethrow;
    }
  }
}
