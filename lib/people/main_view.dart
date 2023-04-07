import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:playstage/people/member_info_entity.dart';
import 'package:playstage/utils/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();

    _loadMemberList();
  }

  void _loadMemberList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(keyUserId) ?? '75fb08b3-e2f9-4a25-b58b-bc6fbfe5c09f';

    final responseData = await ApiProvider.requestMemberList(userId);
    if (responseData['resultCode'] == '200') {
      final memberList = responseData['data'];
      if (memberList.length > 0) {
        for (dynamic json in memberList) {
          MemberInfoEntity info = MemberInfoEntity.fromJson(json);
          if (kDebugMode) {
            print(info.toString());
          }

          _memberList.add(info);
        }

        if (kDebugMode) {
          print(_memberList.toString());
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
          padding: const EdgeInsets.only(left: 15),
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
        child: Center(
          child: Container(
            width: 330,
            height: 582,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Container(
                  width: 330,
                  height: 582,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x00000000), Colors.black], ),
                  ),
                  child: Stack(
                    children:[
                      Positioned(
                        left: 71,
                        top: 533,
                        child: Container(
                          width: 188,
                          height: 41,
                          child: Stack(
                            children:[Container(
                              width: 188,
                              height: 41,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xff2a2a2a),
                              ),
                            ),],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 7,
                        top: 533,
                        child: Container(
                          width: 57,
                          height: 41,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Container(
                                width: 57,
                                height: 41,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xff2a2a2a),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12, ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                    Container(
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 266,
                        top: 533,
                        child: Container(
                          width: 57,
                          height: 41,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Container(
                                width: 57,
                                height: 41,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xff2a2a2a),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 11, ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                    Container(
                                      width: 19,
                                      height: 19,
                                      child: Stack(
                                        children:[Container(
                                          width: 19,
                                          height: 19,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 442,
                        child: SizedBox(
                          width: 310,
                          height: 24,
                          child: Text(
                            "Daniel Kim 36",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 476,
                        child: SizedBox(
                          width: 310,
                          height: 14,
                          child: Text(
                            "남성 싱글 · 3 km",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
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
                            color: Color(0x7fffffff),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 165,
                            height: 523,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(15), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(15), ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
