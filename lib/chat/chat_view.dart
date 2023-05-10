import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
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
        dateFormat: DateFormat("E, MMM d"),
        timeFormat: DateFormat.jm(),
        showUserAvatar: true,
        key: Key(widget.groupChannel.channelUrl),
        onSend: (ChatMessage message) async {
          var sentMessage =
              widget.groupChannel.sendUserMessageWithText(message.text!);
          setState(() {
            _messages.add(sentMessage);
          });
        },
        sendOnEnter: true,
        textInputAction: TextInputAction.send,
        user: user,
        messages: asDashChatMessages(_messages),
        inputDecoration:
            const InputDecoration.collapsed(hintText: "Type a message here..."),
        messageDecorationBuilder: (ChatMessage msg, bool? isUser) {
          return BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: isUser ?? false
                ? Theme.of(context).primaryColor
                : Colors.grey[200], // example
          );
        },
      ),
    );
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    // BaseMessage is a Sendbird class
    // ChatMessage is a DashChat class
    List<ChatMessage> result = [];
    for (var message in messages) {
      if (message.sender == null) {
        continue;
      }

      User user = message.sender as User;
      result.add(
        ChatMessage(
          createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
          text: message.message,
          user: asDashChatUser(user),
        ),
      );
    }
    return result;
  }

  ChatUser asDashChatUser(User user) {
    return ChatUser(
      name: user.nickname,
      uid: user.userId,
      avatar: user.profileUrl,
    );
  }
}
