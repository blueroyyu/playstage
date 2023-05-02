import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/factory.dart';
import 'package:playstage/people/add_feed.dart';
import 'package:playstage/people/channel_list_view.dart';
import 'package:playstage/people/member_feed_entity/member_feed_entity.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/utils/api_provider.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key, required this.member}) : super(key: key);

  final MemberInfoEntity member;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late final MemberInfoEntity _member;
  final List<MemberFeedEntity> _feedList = <MemberFeedEntity>[];

  @override
  void initState() {
    _member = widget.member;
    _loadFeeds();

    super.initState();
  }

  Future<void> _loadFeeds() async {
    final responseData =
        await ApiProvider.requestMemberFeedList(_member.memberSeq!);
    if (responseData['resultCode'] == '200') {
      final feedList = responseData['data'];
      if (feedList.length > 0) {
        for (dynamic map in feedList) {
          MemberFeedEntity info = MemberFeedEntity.fromMap(map);
          if (kDebugMode) {
            print(info.toString());
          }

          setState(() {
            _feedList.add(info);
          });
        }

        if (kDebugMode) {
          print(_feedList.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          '피드',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 88,
              child: makeFeedList(_member, _feedList),
            ),
            Expanded(
              flex: 12,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.house_fill,
                          color: Colors.yellow,
                          size: 32,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.star),
                        color: Colors.grey,
                        iconSize: 32,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => const AddFeed());
                        },
                        icon: const Icon(CupertinoIcons.add_circled),
                        color: Colors.yellow,
                        iconSize: 40,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => const ChannelListView());
                        },
                        icon: const Icon(CupertinoIcons.chat_bubble),
                        color: Colors.grey,
                        iconSize: 32,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.person),
                        color: Colors.grey,
                        iconSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
