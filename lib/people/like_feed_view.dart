import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';

class LikeFeedView extends StatefulWidget {
  const LikeFeedView({super.key, required this.likeList});

  final List<MemberInfoEntity> likeList;

  @override
  State<LikeFeedView> createState() => _LikeFeedViewState();
}

class _LikeFeedViewState extends State<LikeFeedView> {
  late final List<MemberInfoEntity> _likeList;

  @override
  void initState() {
    _likeList = widget.likeList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _likeList.length,
          itemBuilder: (context, index) {
            var member = _likeList[index];

            return ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: member.name(),
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
                backgroundImage:
                    CachedNetworkImageProvider(member.makeProfileImagePath()),
              ),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
