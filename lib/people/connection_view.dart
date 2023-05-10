import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/main_view.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/people/people_detail.dart';
import 'package:playstage/utils/api_provider.dart';

class ConnectionView extends StatefulWidget {
  const ConnectionView({super.key, required this.memberId});

  final String memberId; // TODO: change to memberSeq

  @override
  State<ConnectionView> createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  final List<MemberInfoEntity> _followings = <MemberInfoEntity>[];
  final List<MemberInfoEntity> _followers = <MemberInfoEntity>[];

  int _selectedIndex = 0;

  @override
  void initState() {
    _loadFollow();

    super.initState();
  }

  Future<void> _loadFollow() async {
    var responseData = await ApiProvider.requestLikeMemberList(widget.memberId);
    if (responseData['resultCode'] == '200') {
      final memberList = responseData['data'];
      if (memberList != null) {
        for (Map<String, dynamic> datum in memberList) {
          MemberInfoEntity info = MemberInfoEntity.fromMap(datum);

          if (kDebugMode) {
            print(info.toString());
          }

          setState(() {
            _followings.add(info);
          });
        }
      }
    }

    responseData =
        await ApiProvider.requestReceiveLikeMemberList(widget.memberId);
    if (responseData['resultCode'] == '200') {
      final memberList = responseData['data'];
      if (memberList != null) {
        for (Map<String, dynamic> datum in memberList) {
          MemberInfoEntity info = MemberInfoEntity.fromMap(datum);
          if (kDebugMode) {
            print(info.toString());
          }

          setState(() {
            _followers.add(info);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
          child: Text(
            'connection'.tr,
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
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 3,
                                color: _selectedIndex == 0
                                    ? colorTabBottom
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '좋아요',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: _selectedIndex == 0
                                        ? colorTabBottom
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 3,
                                color: _selectedIndex == 1
                                    ? colorTabBottom
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '받은 좋아요',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: _selectedIndex == 1
                                        ? colorTabBottom
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  IndexedStack(
                    index: _selectedIndex,
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        itemCount: _followings.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          MemberInfoEntity member = _followings[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  () => PeopleDetail(memberInfoEntity: member));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: CachedNetworkImage(
                                      imageUrl: member.makeProfileImagePath(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: SizedBox(width: 8.0),
                                            ),
                                            TextSpan(
                                              text: member.name(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const WidgetSpan(
                                              child: SizedBox(width: 10.0),
                                            ),
                                            TextSpan(
                                              text: member.age().toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          member.memberTendency(),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: _followers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          MemberInfoEntity member = _followers[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  () => PeopleDetail(memberInfoEntity: member));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: CachedNetworkImage(
                                      imageUrl: member.makeProfileImagePath(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: SizedBox(width: 8.0),
                                            ),
                                            TextSpan(
                                              text: member.name(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const WidgetSpan(
                                              child: SizedBox(width: 10.0),
                                            ),
                                            TextSpan(
                                              text: member.age().toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          member.memberTendency(),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MainTab(index: 1),
          ],
        ),
      ),
    );
  }
}
