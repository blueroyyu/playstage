import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playstage/shared_data.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'dart:async';

class ChatView extends StatefulWidget {
  final GroupChannel groupChannel;
  const ChatView({Key? key, required this.groupChannel}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with ChannelEventHandler {
  List<BaseMessage> _messages = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    getMessages(widget.groupChannel);
    SendbirdSdk().addChannelEventHandler(widget.groupChannel.channelUrl, this);
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler(widget.groupChannel.channelUrl);
    super.dispose();
  }

  @override
  onMessageReceived(channel, message) {
    setState(() {
      _messages.add(message);
    });
  }

  Future<void> getMessages(GroupChannel channel) async {
    try {
      List<BaseMessage> messages = await channel.getMessagesByTimestamp(
          DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      if (kDebugMode) {
        print('group_channel_view.dart: getMessages: ERROR: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    GroupChannel channel = widget.groupChannel;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: BackButton(color: Theme.of(context).buttonColor),
        title: SizedBox(
          width: 250,
          child: Text(
            [for (final member in channel.members) member.nickname].join(", "),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: Platform.isIOS,
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.arrow_outward),
                        title: Text('채팅방 나가기'.tr),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('exit_channel'.tr),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('cancel'.tr),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('ok'.tr),
                                    onPressed: () {
                                      widget.groupChannel.leave();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.person_off),
                        title: Text('block'.tr),
                        onTap: () {
                          String blockUserId = '';
                          if (channel.members.first.userId ==
                              SharedData().owner!.memberId!) {
                            blockUserId = channel.members.last.userId;
                          } else {
                            blockUserId = channel.members.first.userId;
                          }
                          // await sendbird.blockUser(USER_ID);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('block_user'.tr),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('cancel'.tr),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('ok'.tr),
                                    onPressed: () async {
                                      await SendbirdSdk()
                                          .blockUser(blockUserId);
                                      Get.back();
                                      Get.back();
                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      // ListTile(
                      //   leading:
                      //       const Icon(CupertinoIcons.exclamationmark_triangle),
                      //   title: Text(
                      //     '신고'.tr,
                      //     style: const TextStyle(color: Colors.red),
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //   },
                      // ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey[400],
            ),
            iconSize: 26,
          ),
        ],
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    ChatUser user = asDashChatUser(SendbirdSdk().currentUser!);
    return Padding(
      // A little breathing room for devices with no home button.
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 40),
      child: DashChat(
        currentUser: user,
        // dateFormat: DateFormat("E, MMM d"),
        // timeFormat: DateFormat.jm(),
        // showUserAvatar: true,
        key: Key(widget.groupChannel.channelUrl),
        onSend: (ChatMessage message) async {
          var sentMessage =
              widget.groupChannel.sendUserMessageWithText(message.text);
          setState(() {
            _messages.add(sentMessage);
          });
        },
        // sendOnEnter: true,
        // textInputAction: TextInputAction.send,
        messages: asDashChatMessages(_messages),
        inputOptions: InputOptions(
          inputDecoration:
              InputDecoration.collapsed(hintText: 'type_message'.tr),
          leading: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.grey[400]),
              onPressed: () async {
                showModalBottomSheet(
                  useSafeArea: Platform.isIOS,
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: Text('album'.tr),
                          onTap: () {
                            _pickImage();
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: Text('camera'.tr),
                          onTap: () {
                            _takePhoto();
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.video_file),
                          title: Text('album_video'.tr),
                          onTap: () {
                            _pickVideo();
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.video_camera_front),
                          title: Text('camera_video'.tr),
                          onTap: () {
                            _takeVideo();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
          alwaysShowSend: true,
        ),
      ),
    );
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    // BaseMessage is a Sendbird class
    // ChatMessage is a DashChat class
    List<ChatMessage> result = [];
    for (var message in messages.reversed) {
      if (message.sender == null) {
        continue;
      }

      List<ChatMedia> medias = [];
      if (message is FileMessage) {
        ChatMedia media = ChatMedia(
          url: message.secureUrl!,
          fileName: message.name!,
          type: message.type!.contains('image')
              ? MediaType.image
              : MediaType.video,
        );

        medias.add(media);
      }

      User user = message.sender as User;
      result.add(
        ChatMessage(
          createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
          text: message.message,
          user: asDashChatUser(user),
          medias: medias,
        ),
      );
    }
    return result;
  }

  ChatUser asDashChatUser(User user) {
    return ChatUser(
      firstName: user.nickname,
      id: user.userId,
      profileImage: user.profileUrl,
    );
  }

  void _processPickedFile(XFile? pickedFile) async {
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final params = FileMessageParams.withFile(
        file,
        name: pickedFile.name,
      )
        ..thumbnailSizes = const [Size(100, 100), Size(40, 40)]
        ..pushOption = PushNotificationDeliveryOption.normal;

      try {
        final preMessage = widget.groupChannel.sendFileMessage(params,
            onCompleted: (message, error) {
          if (error != null) {
            // Handle error.
          }
          // A file message with detailed configuration is successfully sent to the channel.
          // By using fileMessage.messageId, fileMessage.fileName, fileMessage.customType, and so on,
          // you can access the result object from the Sendbird server to check your FileMessageParams configuration.
          // The current user can receive messages from other users through the onMessageReceived method of an channel event handler.
        });

        setState(() {
          _messages.add(preMessage);
        });
      } catch (e) {
        // Handle error.
      }
    }
  }

  void _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    _processPickedFile(pickedFile);
  }

  void _takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    _processPickedFile(pickedFile);
  }

  void _pickVideo() async {
    final pickedFile =
        await _imagePicker.pickVideo(source: ImageSource.gallery);

    _processPickedFile(pickedFile);
  }

  void _takeVideo() async {
    final pickedFile = await _imagePicker.pickVideo(source: ImageSource.camera);

    _processPickedFile(pickedFile);
  }
}
