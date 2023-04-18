import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/member_feed_entity.dart';
import 'package:playstage/sign_up/subscriber_info.dart';
import 'package:playstage/utils/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'member_info_entity.dart';

class PeopleDetail extends StatefulWidget {
  final MemberInfoEntity memberInfoEntity;

  const PeopleDetail({Key? key, required this.memberInfoEntity})
      : super(key: key);

  @override
  State<PeopleDetail> createState() => _PeopleDetailState();
}

class _PeopleDetailState extends State<PeopleDetail> {
  final List<MemberFeedEntity> _feedList = <MemberFeedEntity>[];

  late final MemberInfoEntity _currentMember;

  int _currentProfileIndex = 0;
  int _currentMemberIndex = 0;

  @override
  void initState() {
    super.initState();

    _loadMemberFeed();
  }

  void _loadMemberFeed() async {
    setState(() {
      _currentMember = widget.memberInfoEntity;
    });

    String userId = _currentMember.memberId;

    final responseData = await ApiProvider.requestFeedList(userId);
    if (responseData['resultCode'] == '200') {
      final feedList = responseData['data'];
      if (feedList.length > 0) {
        for (dynamic json in feedList) {
          MemberFeedEntity info = MemberFeedEntity.fromJson(json);
          if (kDebugMode) {
            print(info.toString());
          }

          _feedList.add(info);
        }

        if (kDebugMode) {
          print(_feedList.toString());
        }
      }
    }
  }

  String _makeCurrentImagePath() {
    if (_currentMember!.tbMemberPhotoInfoList.isEmpty) {
      return '';
    }
    return '$s3Url${_currentMember!.memberId}/profile/${_currentMember!.tbMemberPhotoInfoList[_currentProfileIndex].photoSavedFileName}';
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: colorContainerBg,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 90,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 70,
                          child: GestureDetector(
                            onTapUp: (TapUpDetails details) {
                              _onTapUp(details, context);
                            },
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
                                          if (currentChild != null)
                                            currentChild,
                                        ],
                                      );
                                    },
                                    child: _currentMember != null
                                        ? Image.network(
                                            _makeCurrentImagePath(),
                                            key: ValueKey<int>(
                                                _currentProfileIndex),
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                'assets/default_profile.png',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            'assets/default_profile.png',
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
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 30,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                              onTap: () {
                                // TODO: Dislike
                                Get.back();
                              },
                              child: Image.asset(
                                'assets/images/btn_dislike_red.png',
                                width: 60.0,
                              )),
                          InkWell(
                            onTap: () {
                              // TODO: Like
                              Get.back();
                            },
                            child: Image.asset(
                              'assets/images/btn_like_yellow.png',
                              width: 60.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: safeAreaHeight * 0.6,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            // TODO: chat
                            Get.back();
                          },
                          child: Image.asset(
                            'assets/images/btn_chat.png',
                            width: 60.0,
                          )),
                      const SizedBox(width: 10.0),
                      InkWell(
                          onTap: () {
                            // TODO: ?
                            Get.back();
                          },
                          child: Image.asset(
                            'assets/images/btn_under_arrow.png',
                            width: 60.0,
                          )),
                      const SizedBox(width: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      if (_currentMember!.tbMemberPhotoInfoList.isNotEmpty) {
        _currentProfileIndex = (_currentProfileIndex + 1) %
            _currentMember!.tbMemberPhotoInfoList.length;
      }
    });
  }

  void _showPrevImage() {
    setState(() {
      if (_currentMember!.tbMemberPhotoInfoList.isNotEmpty) {
        _currentProfileIndex = (_currentProfileIndex - 1) %
            _currentMember!.tbMemberPhotoInfoList.length;
      }
    });
  }
}