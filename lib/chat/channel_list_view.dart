import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/main_view.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/people/people_detail.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/api_provider.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'chat_view.dart';
import 'package:badges/badges.dart' as badges;

class ChannelListView extends StatefulWidget {
  const ChannelListView({super.key});

  @override
  State<ChannelListView> createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView>
    with ChannelEventHandler {
  int _selectedIndex = 0;

  Future<List<GroupChannel>> getGroupChannels() async {
    try {
      final query = GroupChannelListQuery()
        ..includeEmptyChannel = false
        ..order = GroupChannelListOrder.latestLastMessage
        ..limit = 100;
      return await query.loadNext();
    } catch (e) {
      if (kDebugMode) {
        print('channel_list_view: getGroupChannel: ERROR: $e');
      }
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    SendbirdSdk().addChannelEventHandler('channel_list_view', this);
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler("channel_list_view");
    super.dispose();
  }

  @override
  void onChannelChanged(BaseChannel channel) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onChannelDeleted(String channelUrl, ChannelType channelType) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserJoined(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserLeaved(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
    super.onUserLeaved(channel, user);
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
            'message'.tr,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 100,
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    final userId = SharedData().owner!.memberId;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 88,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45.0,
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
                              padding: const EdgeInsets.only(top: 11.0),
                              child: Text(
                                'sent_message'.tr,
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
                        height: 45.0,
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
                              padding: const EdgeInsets.only(top: 11.0),
                              child: Text(
                                'received_message'.tr,
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
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      FutureBuilder(
                        future: getGroupChannels(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            // Nothing to display yet - good place for a loading indicator
                            return Center(
                              child: Text(
                                'no_message'.tr,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            );
                          }
                          List<GroupChannel>? channels = snapshot.data;
                          List<GroupChannel> filtered = channels!
                              .where((element) =>
                                  element.inviter!.userId == userId)
                              .toList();
                          return ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              GroupChannel channel = filtered[index];
                              Member otherMember = channel.members.first;
                              return ListTile(
                                leading: InkWell(
                                  onTap: () async {
                                    if (channel.inviter == null) {
                                      return;
                                    }

                                    final responseMember =
                                        await ApiProvider.requestMemberById(
                                            otherMember.userId);
                                    if (responseMember['resultCode'] == '200') {
                                      final memberMap = responseMember['data'];
                                      MemberInfoEntity info =
                                          MemberInfoEntity.fromMap(memberMap);

                                      if (kDebugMode) {
                                        print(info.toString());
                                      }

                                      Get.to(() =>
                                          PeopleDetail(memberInfoEntity: info));
                                    }
                                  },
                                  child: badges.Badge(
                                    showBadge: channel.unreadMessageCount > 0,
                                    badgeContent: Text(
                                      channel.unreadMessageCount.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    position: badges.BadgePosition.bottomEnd(),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        otherMember.profileUrl ?? '',
                                      ),
                                    ),
                                  ),
                                ),
                                // Display all channel members as the title
                                title: Text(
                                  otherMember.nickname,
                                ),
                                // Display the last message presented
                                subtitle:
                                    Text(channel.lastMessage?.message ?? ''),
                                onTap: () {
                                  gotoChannel(channel.channelUrl);
                                },
                                trailing: otherMember.isBlockedByMe
                                    ? Text(
                                        'blocked'.tr,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      )
                                    : null,
                              );
                            },
                          );
                        },
                      ),
                      FutureBuilder(
                        future: getGroupChannels(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            // Nothing to display yet - good place for a loading indicator
                            return Center(
                              child: Text(
                                'no_message'.tr,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            );
                          }
                          List<GroupChannel>? channels = snapshot.data;
                          List<GroupChannel> filtered = channels!
                              .where((element) =>
                                  element.inviter!.userId != userId)
                              .toList();
                          return ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              GroupChannel channel = filtered[index];
                              return ListTile(
                                leading: InkWell(
                                  onTap: () async {
                                    if (channel.inviter == null) {
                                      return;
                                    }

                                    final responseMember =
                                        await ApiProvider.requestMemberById(
                                            channel.inviter!.userId);
                                    if (responseMember['resultCode'] == '200') {
                                      final memberMap = responseMember['data'];
                                      MemberInfoEntity info =
                                          MemberInfoEntity.fromMap(memberMap);

                                      if (kDebugMode) {
                                        print(info.toString());
                                      }

                                      Get.to(() =>
                                          PeopleDetail(memberInfoEntity: info));
                                    }
                                  },
                                  child: badges.Badge(
                                    showBadge: channel.unreadMessageCount > 0,
                                    badgeContent: Text(
                                      channel.unreadMessageCount.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    position: badges.BadgePosition.bottomEnd(),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        channel.inviter?.profileUrl ?? '',
                                      ),
                                    ),
                                  ),
                                ),
                                // Display all channel members as the title
                                title: Text(
                                  channel.inviter?.nickname ?? 'Unknown',
                                ),
                                // Display the last message presented
                                subtitle:
                                    Text(channel.lastMessage?.message ?? ''),
                                onTap: () {
                                  gotoChannel(channel.channelUrl);
                                },
                                trailing: channel.members.firstWhereOrNull(
                                            (element) =>
                                                element.isBlockedByMe) !=
                                        null
                                    ? Text(
                                        'blocked'.tr,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      )
                                    : null,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MainTab(index: 3),
        ],
      ),
    );
  }

  void gotoChannel(String channelUrl) {
    GroupChannel.getChannel(channelUrl).then((channel) {
      Get.to(() => ChatView(groupChannel: channel))?.then((value) {
        setState(() {
          if (kDebugMode) {
            print(value);
          }
        });
      });
    }).catchError((e) {
      //handle error
      if (kDebugMode) {
        print('channel_list_view: gotoChannel: ERROR: $e');
      }
    });
  }
}
