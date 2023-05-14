import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/people/main_view.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'chat_view.dart';

class ChannelListView extends StatefulWidget {
  const ChannelListView({super.key});

  @override
  State<ChannelListView> createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView>
    with ChannelEventHandler {
  Future<List<GroupChannel>> getGroupChannels() async {
    try {
      final query = GroupChannelListQuery()
        ..includeEmptyChannel = true
        ..order = GroupChannelListOrder.latestLastMessage
        ..limit = 15;
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
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 88,
            child: FutureBuilder(
              future: getGroupChannels(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false || snapshot.data == null) {
                  // Nothing to display yet - good place for a loading indicator
                  return Container();
                }
                List<GroupChannel>? channels = snapshot.data;
                return ListView.builder(
                  itemCount: channels?.length,
                  itemBuilder: (context, index) {
                    GroupChannel channel = channels![index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          channel.inviter?.profileUrl ?? '',
                        ),
                      ),
                      // Display all channel members as the title
                      title: Text(
                        [for (final member in channel.members) member.nickname]
                            .join(", "),
                      ),
                      // Display the last message presented
                      subtitle: Text(channel.lastMessage?.message ?? ''),
                      onTap: () {
                        gotoChannel(channel.channelUrl);
                      },
                      trailing: channel.members.firstWhereOrNull(
                                  (element) => element.isBlockedByMe) !=
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
          ),
          MainTab(index: 3),
        ],
      ),
    );
  }

  void gotoChannel(String channelUrl) {
    GroupChannel.getChannel(channelUrl).then((channel) {
      Get.to(() => ChatView(groupChannel: channel));
    }).catchError((e) {
      //handle error
      if (kDebugMode) {
        print('channel_list_view: gotoChannel: ERROR: $e');
      }
    });
  }
}
