import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/chat/chat_view.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/chat_provider.dart';

class MatchedView extends StatelessWidget {
  const MatchedView({super.key, required this.matchedMember});

  final MemberInfoEntity matchedMember;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              colorTabBottom,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 180),
              const Center(
                child: Text(
                  '매치되었습니다!',
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Text(
                  '${matchedMember.nickName ?? matchedMember.memberName}님도 회원님에게 좋아요를 표시했어요!',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        SharedData().owner!.makeProfileImagePath()),
                    radius: 50,
                  ),
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        matchedMember.makeProfileImagePath()),
                    radius: 50,
                  ),
                ],
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  ChatProvider().createChannel([
                    SharedData().owner!.memberId!,
                    matchedMember.memberId!
                  ]).then((channel) {
                    Get.off(() => ChatView(groupChannel: channel));
                  }).catchError((error) {
                    if (kDebugMode) {
                      print(
                          'create_channel_view: navigationBar: createChannel: ERROR: $error');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: const Text(
                  '메시지 보내기',
                  style: TextStyle(
                    color: colorTabBottom,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  side: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: const Text(
                  '계속하기',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
