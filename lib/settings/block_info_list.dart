import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';

import '../shared_data.dart';
import '../utils/api_provider.dart';

class BlockInfoList extends StatefulWidget {
  const BlockInfoList({super.key});

  @override
  State<BlockInfoList> createState() => _BlockInfoListState();
}

class _BlockInfoListState extends State<BlockInfoList> {
  final List<MemberInfoEntity> _blockList = <MemberInfoEntity>[];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedData sd = SharedData();
    String userId = sd.owner!.memberId!;
    try {
      dynamic res = await ApiProvider.requestGetBlockInfoList(userId);

      if (res['resultCode'] == '200') {
        final memberList = res['data'];
        for (dynamic map in memberList) {
          MemberInfoEntity info = MemberInfoEntity.fromMap(map);
          if (kDebugMode) {
            print(info.toString());
          }

          setState(() {
            _blockList.add(info);
          });
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text('차단 목록'.tr,
            style: const TextStyle(
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: _blockList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _blockList.length,
                itemBuilder: (context, index) {
                  var member = _blockList[index];
                  return ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: member.nickName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 5.0),
                          ),
                          TextSpan(
                            text: member.age().toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(member.memberTendency()),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          member.makeProfileImagePath()),
                    ),
                    onTap: () {
                      // Get.to(() => PeopleDetail(memberInfoEntity: member));
                    },
                  );
                },
              )
            : Container(),
      ),
    );
  }
}
