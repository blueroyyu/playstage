import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/member_feed_entity/member_feed_entity.dart';
import 'package:playstage/people/member_feed_entity/tb_feed_like_member_info_list.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/utils/api_provider.dart';

class FeedDetail extends StatefulWidget {
  const FeedDetail({super.key, required this.member, required this.feed});

  final MemberInfoEntity member;
  final MemberFeedEntity feed;

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  List<MemberInfoEntity> likeList = <MemberInfoEntity>[];

  @override
  void initState() {
    super.initState();
    _loadLikeList();
  }

  Future<void> _loadLikeList() async {
    final likes = widget.feed.tbFeedLikeMemberInfoList;
    for (TbFeedLikeMemberInfoList like in likes!) {
      int seq = like.memberSeq!;

      final responseData = await ApiProvider.requestMember(seq);
      if (responseData['resultCode'] == '200') {
        final memberMap = responseData['data'];
        MemberInfoEntity info = MemberInfoEntity.fromMap(memberMap);
        if (kDebugMode) {
          print(info.toString());
        }

        setState(() {
          likeList.add(info);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    final MemberInfoEntity member = widget.member;
    final MemberFeedEntity feed = widget.feed;
    final images = feed.tbFeedPhotoInfoList;
    final likes = feed.tbFeedLikeMemberInfoList;
    final comments = feed.tbFeedCommentInfoList;

    final df = DateFormat('yyyy/MM/dd');
    final feedDt = df.format(feed.createDt!);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'feed_detail'.tr,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 20.0,
              ),
              child: Text(
                feed.feedContent ?? '',
                style: const TextStyle(
                  fontSize: 17.0,
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: images?.length,
              itemBuilder: (BuildContext context, int index) {
                final image = images![index];
                String photoPath = image.photoPath!;
                if (photoPath.startsWith('/') == false) {
                  photoPath = '/$photoPath';
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CachedNetworkImage(
                    imageUrl: '$s3Url$photoPath${image.photoSavedFileName}',
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        'assets/images/default_profile.png',
                        fit: BoxFit.cover,
                      );
                    },
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Row(
              children: [
                const SizedBox(width: 20.0),
                const Image(
                  image: AssetImage('assets/images/icon_time.png'),
                  width: 12.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  feedDt,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: colorTextGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 40.0,
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      width: 1.0,
                      color: colorTextGrey,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Spacer(),
                    const Image(
                      image: AssetImage('assets/images/icon_like.png'),
                      width: 20.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      feed.feedLikeCnt!.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: colorTextGrey,
                      ),
                    ),
                    const Spacer(),
                    const Image(
                      image: AssetImage('assets/images/icon_reply.png'),
                      width: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      feed.tbFeedCommentInfoList!.length.toString(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: colorTextGrey,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: safeAreaWidth,
              height: 30.0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: likeList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: likeList.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              likeList[index].makeProfileImagePath(),
                            ),
                          )
                        : Container(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: comments!.length,
              itemBuilder: (context, index) {
                final comment = comments[0];
                String photoPath = comment.memberPhotoPath!
                    .replaceFirst('playstage-upload', '');
                photoPath = photoPath.replaceFirst('profile', '');
                if (photoPath.startsWith('/') == false) {
                  photoPath = '/$photoPath';
                }
                if (photoPath.endsWith('/') == false) {
                  photoPath = '$photoPath/profile/';
                }
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: comment.memberName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 5.0),
                        ),
                        TextSpan(
                          text: df.format(comment.createDt!),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(comment.comment!),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      '$s3Url$photoPath${comment.memberPhotoSavedFileName!}',
                    ),
                  ),
                  onTap: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
