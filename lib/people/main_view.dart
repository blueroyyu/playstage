import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/chat/channel_list_view.dart';
import 'package:playstage/feed/add_feed.dart';
import 'package:playstage/feed/feed_view.dart';
import 'package:playstage/people/filter_view.dart';
import 'package:playstage/people/connection_view.dart';
import 'package:playstage/people/matched_view.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/people/people_detail.dart';
import 'package:playstage/people/profile_view.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/api_provider.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mysql1/mysql1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:playstage/const.dart';

class MainView extends StatefulWidget {
  const MainView({
    Key? key,
  }) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<MemberInfoEntity> _memberList = <MemberInfoEntity>[];
  final PageController _pageController = PageController();

  int _currentProfileIndex = 0;
  MemberInfoEntity? _currentMember;

  late final SendbirdSdk sendbird;

  @override
  void initState() {
    super.initState();

    sendbird = SendbirdSdk(appId: sendbirdApiId);
    ApiProvider.accessToken = accessToken;

    _loadMemberList();
    _initSendBird();
  }

  void _loadMemberList({bool reload = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(keyUserId) ?? '';

    final SharedData sd = SharedData();

    try {
      final responseData = reload == false
          ? await ApiProvider.requestMemberList(userId)
          : await ApiProvider.requestMemberList(
              userId,
              fromAge: sd.fromAge,
              toAge: sd.toAge > 70 ? 120 : sd.toAge,
              distance: sd.distance > 499 ? 9999 : sd.distance,
            );
      if (responseData['resultCode'] == '200') {
        final memberList = responseData['data'];
        if (memberList.length > 0) {
          _memberList.clear();

          for (dynamic map in memberList) {
            MemberInfoEntity info = MemberInfoEntity.fromMap(map);
            if (kDebugMode) {
              print(info.toString());
            }

            _memberList.add(info);
          }

          if (kDebugMode) {
            print(_memberList.toString());
          }
        }

        setState(() {
          _currentMember = _memberList[0];
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // var conn = await getConnection();
    // var results = await conn.query(
    //     'select a.member_id, a.member_seq, c.member_name, b.photo_path, b.photo_saved_file_name  from TB_MEMBER_INFO a, TB_MEMBER_PHOTO_INFO b, TB_MEMBER_DETAIL_INFO c where member_id = ? and a.member_seq = b.member_seq and a.member_seq = c.member_seq',
    //     [userId]);
    // var row = results.first;
  }

  void _initSendBird() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(keyUserId) ?? '';

    final SharedData sd = SharedData();

    try {
      final memberResponse = await ApiProvider.requestMemberById(userId);
      if (memberResponse['resultCode'] == '200') {
        final memberData = memberResponse['data'];

        sd.owner = MemberInfoEntity.fromMap(memberData);
        if (kDebugMode) {
          print(sd.owner.toString());
        }

        var profileUrl =
            '$s3Url/$userId/profile/${sd.owner!.tbMemberPhotoInfoList?.first.photoSavedFileName}';
        User sbUser =
            await _connect(userId, sd.owner!.nickName ?? sd.owner!.memberName!);
        if (kDebugMode) {
          print(sbUser.toJson());
        }

        sendbird.updateCurrentUserInfo(
            nickname: sd.owner!.nickName ?? sd.owner!.memberName,
            fileInfo: FileInfo.fromUrl(url: profileUrl));
      }

      String? token = prefs.getString(keyPushToken);
      if (token != null) {
        await sendbird.unregisterAllPushToken();
        await sendbird.registerPushToken(
          type: kIsWeb
              ? PushTokenType.none
              : Platform.isIOS
                  ? PushTokenType.apns
                  : PushTokenType.fcm,
          token: token,
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    }
  }

  Future<User> _connect(String memberId, String name) async {
    try {
      final user = await sendbird.connect(memberId, nickname: name);

      return user;
    } catch (e) {
      if (kDebugMode) {
        print('login_view: connect: ERROR: $e');
      }
      rethrow;
    }
  }

  // Future<MySqlConnection> getConnection() async {
  //   final conn = await MySqlConnection.connect(ConnectionSettings(
  //     host: '3.35.179.159',
  //     port: 3306,
  //     user: 'playstage_dev',
  //     password: 'playstage@2023!',
  //     db: 'playstage_new',
  //   ));
  //   return conn;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: colorContainerBg,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
          child: Text(
            'people'.tr,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const FilterView())!.then((value) {
                if (value == true) {
                  _loadMemberList(reload: value);
                }
              });
            },
            icon: Image.asset('assets/images/icon_menu.png'),
            iconSize: 26,
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
        color: colorContainerBg,
        child: Column(
          children: [
            Expanded(
              flex: 88,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _currentMember = _memberList[index];
                    setState(() {
                      _currentProfileIndex = 0;
                    });
                  },
                  itemCount: _memberList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final member = _memberList[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              layoutBuilder: (Widget? currentChild,
                                  List<Widget> previousChildren) {
                                return Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    ...previousChildren,
                                    if (currentChild != null) currentChild,
                                  ],
                                );
                              },
                              child: Image.network(
                                member.makeProfileImagePath(
                                    index: _currentProfileIndex),
                                key: ValueKey<int>(_currentProfileIndex),
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/default_profile.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.black),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Positioned(
                          //   left: 15,
                          //   top: 7,
                          //   child: Container(
                          //     width: 148,
                          //     height: 3,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(2),
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          member.tbMemberPhotoInfoList!.length > 1
                              ? Positioned(
                                  top: 7,
                                  left: 0,
                                  right: 0,
                                  child: DotsIndicator(
                                    dotsCount: member.tbMemberPhotoInfoList!
                                        .length, // 전체 페이지 수
                                    position:
                                        _currentProfileIndex, // 현재 페이지 인덱스
                                    decorator: DotsDecorator(
                                      activeColor:
                                          Colors.white, // 활성화된 페이지 인디케이터 색상
                                      size: const Size.square(5.0), // 인디케이터 크기
                                      activeSize: const Size(18.0, 5.0),
                                      activeShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            5.0), // 활성화된 인디케이터 모양
                                        side: const BorderSide(
                                            color: Color(0xFFB4B4B4),
                                            width: 0.1),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Positioned.fill(
                            child: GestureDetector(
                              onTapUp: (TapUpDetails details) {
                                _onTapUp(details, context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.25),
                                      Colors.black.withOpacity(0.50),
                                      Colors.black.withOpacity(1.0),
                                    ],
                                    stops: const [0.0, 0.5, 0.75, 1.0],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 20,
                                      bottom: 140,
                                      child: Text(
                                        member.nickName ?? member.memberName!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      bottom: 116,
                                      child: Text(
                                        member.memberTendency(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 8,
                                      bottom: 8,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                46,
                                        height: 50.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: colorBtnBg,
                                                ),
                                                onPressed: () async {
                                                  await _requestHate(
                                                      _currentMember!
                                                          .memberId!);
                                                  _pageController.nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.linear);
                                                },
                                                child: const Icon(Icons.close,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 6,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: colorBtnBg,
                                                ),
                                                onPressed: () async {
                                                  final matched =
                                                      await _requestLike(
                                                          _currentMember!
                                                              .memberId!);

                                                  if (matched) {
                                                    Get.to(() => MatchedView(
                                                        matchedMember:
                                                            _currentMember!));
                                                  } else {
                                                    _pageController.nextPage(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        curve: Curves.linear);
                                                  }
                                                },
                                                child: const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 2,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: colorBtnBg,
                                                ),
                                                onPressed: () {
                                                  Get.to(() => PeopleDetail(
                                                      memberInfoEntity:
                                                          _currentMember!));
                                                },
                                                child: const Icon(Icons.info,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 19),
            MainTab(index: 0),
          ],
        ),
      )),
    );
  }

  void _onTapUp(TapUpDetails details, BuildContext context) {
    final double x = details.globalPosition.dx;
    if (x < MediaQuery.of(context).size.width / 2) {
      _showPrevImage();
    } else {
      _showNextImage();
    }
  }

  void _showNextImage() {
    setState(() {
      if (_currentMember != null) {
        if (_currentMember!.tbMemberPhotoInfoList!.isNotEmpty) {
          _currentProfileIndex = (_currentProfileIndex + 1) %
              _currentMember!.tbMemberPhotoInfoList!.length;
        }
      }
    });
  }

  void _showPrevImage() {
    setState(() {
      if (_currentMember != null) {
        if (_currentMember!.tbMemberPhotoInfoList!.isNotEmpty) {
          _currentProfileIndex = (_currentProfileIndex - 1) %
              _currentMember!.tbMemberPhotoInfoList!.length;
        }
      }
    });
  }

  Future<bool> _requestLike(String targetMemeberId) async {
    try {
      var responseData = await ApiProvider.requestToggleMemberLike(
          SharedData().owner!.memberId!, targetMemeberId);
      if (responseData['resultCode'] == '200') {
        final data = responseData['data'];
        if (data != null) {
          final isLike = data['isLike'];
          final isLikeByTarget = data['isLikeByTarget'];

          if (isLike && isLikeByTarget) {
            return true;
          }
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    }

    return false;
  }

  Future<void> _requestHate(String targetMemeberId) async {
    try {
      await ApiProvider.requestAddHateMember(
          SharedData().owner!.memberId!, targetMemeberId);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    }
  }
}

class MainTab extends StatelessWidget {
  MainTab({
    super.key,
    required this.index,
  });

  final int index;
  final SharedData sd = SharedData();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                onPressed: () {
                  Get.to(() => const MainView());
                },
                icon: Icon(
                  index == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house,
                  color: index == 0 ? Colors.yellow : Colors.grey,
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
                onPressed: () {
                  Get.to(() => ConnectionView(memberId: sd.owner!.memberId!));
                },
                icon: Icon(index == 1
                    ? CupertinoIcons.star_fill
                    : CupertinoIcons.star),
                color: index == 1 ? Colors.yellow : Colors.grey,
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
                  index == 2
                      ? Get.to(() => const AddFeed())
                      : Get.to(() => FeedView(member: sd.owner!));
                },
                icon: index == 2
                    ? const Icon(CupertinoIcons.add_circled)
                    : const Icon(CupertinoIcons.globe),
                color: index == 2 ? Colors.yellow : Colors.grey,
                iconSize: index == 2 ? 40 : 32,
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
                icon: Icon(index == 3
                    ? CupertinoIcons.chat_bubble_fill
                    : CupertinoIcons.chat_bubble),
                color: index == 3 ? Colors.yellow : Colors.grey,
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
                  Get.to(() => const ProfileView());
                  // Get.to(() => MatchedView(matchedMember: SharedData().owner!));
                  // Get.to(() => const AppSettings());
                },
                icon: Icon(index == 4
                    ? CupertinoIcons.person_fill
                    : CupertinoIcons.person),
                color: index == 4 ? Colors.yellow : Colors.grey,
                iconSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
