import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/people/channel_list_view.dart';
import 'package:playstage/people/connection_view.dart';
import 'package:playstage/people/feed_view.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/people/people_detail.dart';
import 'package:playstage/sign_up/subscriber_info.dart';
import 'package:playstage/utils/api_provider.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart';

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

  int _currentProfileIndex = 0;
  final int _currentMemberIndex = 0;
  MemberInfoEntity? _currentMember;
  MemberInfoEntity? _owner;

  late final SendbirdSdk sendbird;

  @override
  void initState() {
    super.initState();

    sendbird = SendbirdSdk(appId: sendbirdApiId);

    _loadMemberList();
  }

  void _loadMemberList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId =
        prefs.getString(keyUserId) ?? 'ab946ff4-ee4a-4e9c-ab9d-41efb3914218';

    final responseData = await ApiProvider.requestMemberList(userId);
    if (responseData['resultCode'] == '200') {
      final memberList = responseData['data'];
      if (memberList.length > 0) {
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

    // TODO: member info 서버 요청
    var conn = await getConnection();
    var results = await conn.query(
        'select a.member_id, a.member_seq, c.member_name, b.photo_path, b.photo_saved_file_name  from TB_MEMBER_INFO a, TB_MEMBER_PHOTO_INFO b, TB_MEMBER_DETAIL_INFO c where member_id = ? and a.member_seq = b.member_seq and a.member_seq = c.member_seq',
        [userId]);

    var row = results.first;
    var profileUrl = '$s3Url/$userId/profile/${row['photo_saved_file_name']}';
    User sbUser = await _connect(userId, row['member_name']);
    if (kDebugMode) {
      print(sbUser.toJson());
    }

    sendbird.updateCurrentUserInfo(
        nickname: row['member_name'],
        fileInfo: FileInfo.fromUrl(url: profileUrl));

    final memberResponse = await ApiProvider.requestMember(row['member_seq']);
    if (memberResponse['resultCode'] == '200') {
      final memberData = memberResponse['data'];

      _owner = MemberInfoEntity.fromMap(memberData);
      if (kDebugMode) {
        print(_owner.toString());
      }
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

  Future<MySqlConnection> getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '3.35.179.159',
      port: 3306,
      user: 'playstage_dev',
      password: 'playstage@2023!',
      db: 'playstage_new',
    ));
    return conn;
  }

  String _makeCurrentImagePath() {
    if (_currentMember!.tbMemberPhotoInfoList!.isEmpty) {
      return '';
    }
    return '$s3Url/${_currentMember!.memberId}/profile/${_currentMember!.tbMemberPhotoInfoList![_currentProfileIndex].photoSavedFileName}';
  }

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
              // do something when button is pressed
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
                    onPageChanged: (index) {
                      setState(() {
                        _currentMember = _memberList[index];
                        _currentProfileIndex = 0;
                      });
                    },
                    itemCount: _memberList.length,
                    itemBuilder: (BuildContext context, int index) {
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
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
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
                                child: _currentMember != null
                                    ? Image.network(
                                        _makeCurrentImagePath(),
                                        key:
                                            ValueKey<int>(_currentProfileIndex),
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
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
                                      )
                                    : Image.asset(
                                        'assets/images/default_profile.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              left: 15,
                              top: 7,
                              child: Container(
                                width: 148,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 167,
                              top: 7,
                              child: Container(
                                width: 148,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: const Color(0x7fffffff),
                                ),
                              ),
                            ),
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
                                          _memberName(),
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
                                          '${_memberTendency()} · 1km',
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              46,
                                          height: 50.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: colorBtnBg,
                                                  ),
                                                  onPressed: () {
                                                    // 버튼1 클릭 시 수행할 동작
                                                  },
                                                  child: const Icon(Icons.close,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                flex: 6,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: colorBtnBg,
                                                  ),
                                                  onPressed: () {
                                                    // 버튼2 클릭 시 수행할 동작
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
                                                  style:
                                                      ElevatedButton.styleFrom(
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
                    }),
              ),
            ),
            const SizedBox(height: 19),
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
                        onPressed: () {
                          Get.to(() =>
                              ConnectionView(memberId: _owner!.memberId!));
                        },
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
                          Get.to(() => FeedView(member: _owner!));
                        },
                        icon: const Icon(CupertinoIcons.globe),
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
      )),
    );
  }

  String _memberName() => _currentMember?.memberName ?? '';

  String _memberTendency() {
    String? td = tendencies.firstWhere((element) =>
        element["code"] == _currentMember?.memberTendencyCd)["label"];
    return td ?? '';
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
}
