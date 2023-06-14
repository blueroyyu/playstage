import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/factory.dart';
import 'package:playstage/people/main_view.dart';
import 'package:playstage/people/member_feed_entity/member_feed_entity.dart';
import 'package:playstage/settings/app_settings.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/api_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final List<MemberFeedEntity> _feedList = <MemberFeedEntity>[];

  int _currentProfileIndex = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _loadMemberFeed();
  }

  void _loadMemberFeed() async {
    int memberSeq = SharedData().owner!.memberSeq!;

    final responseData =
        await ApiProvider.requestMemberFeedList(memberSeq, 1, 1000);
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

  String _makeCurrentImagePath() {
    if (SharedData().owner!.tbMemberPhotoInfoList!.isEmpty) {
      return '';
    }
    return '$s3Url/${SharedData().owner!.memberId}/profile/${SharedData().owner!.tbMemberPhotoInfoList![_currentProfileIndex].photoSavedFileName}';
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
          child: Column(
            children: [
              Expanded(
                flex: 88,
                child: Stack(
                  children: [
                    SingleChildScrollView(
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
                                      SharedData()
                                                  .owner!
                                                  .tbMemberPhotoInfoList!
                                                  .length >
                                              1
                                          ? Positioned(
                                              top: 7,
                                              left: 0,
                                              right: 0,
                                              child: DotsIndicator(
                                                dotsCount: SharedData()
                                                    .owner!
                                                    .tbMemberPhotoInfoList!
                                                    .length, // 전체 페이지 수
                                                position:
                                                    _currentProfileIndex, // 현재 페이지 인덱스
                                                decorator: DotsDecorator(
                                                  activeColor: Colors
                                                      .white, // 활성화된 페이지 인디케이터 색상
                                                  size: const Size.square(
                                                      5.0), // 인디케이터 크기
                                                  activeSize:
                                                      const Size(18.0, 5.0),
                                                  activeShape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0), // 활성화된 인디케이터 모양
                                                    side: const BorderSide(
                                                        color:
                                                            Color(0xFFB4B4B4),
                                                        width: 0.1),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
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
                                          text: SharedData().owner!.nickName ??
                                              SharedData().owner!.memberName,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(width: 10.0),
                                        ),
                                        TextSpan(
                                          text: SharedData()
                                              .owner!
                                              .age()
                                              .toString(),
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
                                      SharedData().owner!.memberTendency(),
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
                                                SharedData()
                                                    .owner!
                                                    .memberIntro!,
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
                                                      text: SharedData()
                                                          .owner!
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
                                                      text: SharedData()
                                                          .owner!
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
                                                      text: SharedData()
                                                          .owner!
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
                                                      text: SharedData()
                                                          .owner!
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
                                                      text: SharedData()
                                                          .owner!
                                                          .frequency(
                                                              code: SharedData()
                                                                  .owner!
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
                                                      text: SharedData()
                                                          .owner!
                                                          .frequency(
                                                              code: SharedData()
                                                                  .owner!
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
                                            SharedData().owner!, _feedList),
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
                                        Get.to(() => const AppSettings());
                                      },
                                      child: Image.asset(
                                        'assets/images/btn_setting.png',
                                        width: 60.0,
                                      )),
                                  // const SizedBox(width: 10.0),
                                  // InkWell(
                                  //     onTap: () {},
                                  //     child: Image.asset(
                                  //       'assets/images/btn_edit.png',
                                  //       width: 60.0,
                                  //     )),
                                  const SizedBox(width: 20.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              MainTab(index: 4),
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
      if (SharedData().owner!.tbMemberPhotoInfoList!.isNotEmpty) {
        _currentProfileIndex = (_currentProfileIndex + 1) %
            SharedData().owner!.tbMemberPhotoInfoList!.length;
      }
    });
  }

  void _showPrevImage() {
    setState(() {
      if (SharedData().owner!.tbMemberPhotoInfoList!.isNotEmpty) {
        _currentProfileIndex = (_currentProfileIndex - 1) %
            SharedData().owner!.tbMemberPhotoInfoList!.length;
      }
    });
  }
}
