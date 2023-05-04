import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
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
      final memberMap = responseData['data'];
      MemberInfoEntity info = MemberInfoEntity.fromMap(memberMap);
      if (kDebugMode) {
        print(info.toString());
      }

      setState(() {
        _followings.add(info);
      });
    }

    responseData =
        await ApiProvider.requestReceiveLikeMemberList(widget.memberId);
    if (responseData['resultCode'] == '200') {
      final memberMap = responseData['data'];
      MemberInfoEntity info = MemberInfoEntity.fromMap(memberMap);
      if (kDebugMode) {
        print(info.toString());
      }

      setState(() {
        _followers.add(info);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
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
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
          GridView.builder(
              shrinkWrap: true,
              itemCount: _followings.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container();
              }),
        ],
      )),
    );
  }
}
