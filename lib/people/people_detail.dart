import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/chat/chat_view.dart';
import 'package:playstage/const.dart';
import 'package:playstage/factory.dart';
import 'package:playstage/people/matched_view.dart';
import 'package:playstage/people/member_feed_entity/member_feed_entity.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/api_provider.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/utils/chat_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int _selectedIndex = 0;

  late final String userId;

  bool _following = false;

  @override
  void initState() {
    _currentMember = widget.memberInfoEntity;
    _loadMemberFeed();

    super.initState();
  }

  void _loadMemberFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(keyUserId)!;

    int memberSeq = _currentMember.memberSeq!;

    final responseData = await ApiProvider.requestMemberFeedList(memberSeq);
    if (responseData['resultCode'] == '200') {
      final feedList = responseData['data'];
      if (feedList.length > 0) {
        for (dynamic map in feedList) {
          MemberFeedEntity info = MemberFeedEntity.fromMap(map);
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
    if (_currentMember.tbMemberPhotoInfoList!.isEmpty) {
      return '';
    }
    return '$s3Url/${_currentMember.memberId}/profile/${_currentMember.tbMemberPhotoInfoList![_currentProfileIndex].photoSavedFileName}';
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: colorPeopleDetailBg,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 90,
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: safeAreaHeight * 0.9 * 0.7,
                                child: GestureDetector(
                                  onTapUp: (TapUpDetails details) {
                                    _onTapUp(details, context);
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 500),
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
                                          child: CachedNetworkImage(
                                            imageUrl: _makeCurrentImagePath(),
                                            key: ValueKey<int>(
                                                _currentProfileIndex),
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                'assets/images/default_profile.png',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            progressIndicatorBuilder: (context,
                                                url, downloadProgress) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
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
                                            borderRadius:
                                                BorderRadius.circular(2),
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
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: const Color(0x7fffffff),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 20),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: SizedBox(width: 20.0),
                                        ),
                                        TextSpan(
                                          text: _currentMember.name(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(width: 10.0),
                                        ),
                                        TextSpan(
                                          text: _currentMember.age().toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      _currentMember.memberTendency(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
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
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Text(
                                                  'detail'.tr,
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
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Text(
                                                  'feed'.tr,
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
                                  const SizedBox(height: 15.0),
                                  IndexedStack(
                                    index: _selectedIndex,
                                    children: [
                                      Visibility(
                                        visible: _selectedIndex == 0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _currentMember.memberIntro ??
                                                    '',
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${'find_tendency'.tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _currentMember
                                                          .searchTendency(),
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${'height'.tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _currentMember
                                                          .height(),
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${'body_type'.tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _currentMember
                                                          .bodyType(),
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${'language_spoken'.tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _currentMember
                                                          .spokenLanguage(),
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${'drinking'.tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _currentMember
                                                          .frequency(
                                                              code: _currentMember
                                                                  .drinkInfo),
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${'smoking'.tr}: ',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: _currentMember
                                                          .frequency(
                                                              code: _currentMember
                                                                  .smokingInfo),
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _selectedIndex == 1,
                                        child: makeFeedList(
                                            _currentMember, _feedList),
                                      ),
                                    ],
                                  ),
                                ],
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
                                        ChatProvider().createChannel([
                                          userId,
                                          _currentMember.memberId!
                                        ]).then((channel) {
                                          Get.to(() =>
                                              ChatView(groupChannel: channel));
                                        }).catchError((error) {
                                          if (kDebugMode) {
                                            print(
                                                'create_channel_view: navigationBar: createChannel: ERROR: $error');
                                          }
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/btn_chat.png',
                                        width: 60.0,
                                      )),
                                  const SizedBox(width: 10.0),
                                  InkWell(
                                      onTap: () {
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
                            onTap: () async {
                              final matched =
                                  await _requestLike(_currentMember.memberId!);

                              if (matched) {
                                Get.to(() =>
                                    MatchedView(matchedMember: _currentMember));
                              }
                            },
                            child: Image.asset(
                              _following
                                  ? 'assets/images/btn_like_red.png'
                                  : 'assets/images/btn_like_yellow.png',
                              width: 60.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
      if (_currentMember.tbMemberPhotoInfoList!.isNotEmpty) {
        _currentProfileIndex = (_currentProfileIndex + 1) %
            _currentMember.tbMemberPhotoInfoList!.length;
      }
    });
  }

  void _showPrevImage() {
    setState(() {
      if (_currentMember.tbMemberPhotoInfoList!.isNotEmpty) {
        _currentProfileIndex = (_currentProfileIndex - 1) %
            _currentMember.tbMemberPhotoInfoList!.length;
      }
    });
  }

  /*
  "data": {
    "isLike": true,
    "isLikeByTarget": true
  }
  */
  Future<bool> _requestLike(String targetMemeberId) async {
    try {
      var responseData = await ApiProvider.requestToggleMemberLike(
          SharedData().owner!.memberId!, targetMemeberId);
      if (responseData['resultCode'] == '200') {
        final data = responseData['data'];
        if (data != null) {
          final isLike = data['isLike'];
          final isLikeByTarget = data['isLikeByTarget'];

          setState(() {
            _following = isLike;
          });

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
}
