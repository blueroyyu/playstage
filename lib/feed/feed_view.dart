import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/factory.dart';
import 'package:playstage/people/main_view.dart';
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
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
          child: Text(
            'feed'.tr,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 88,
              child: SingleChildScrollView(
                child: makeFeedList(_member, _feedList),
              ),
            ),
            MainTab(index: 2),
          ],
        ),
      ),
    );
  }
}
