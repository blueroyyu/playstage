import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:playstage/const.dart';
import 'package:playstage/feed/feed_detail.dart';
import 'package:playstage/people/member_feed_entity/member_feed_entity.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/shared_data.dart';

Widget iconButton(
    {required Icon icon, required Text label, Function()? onPressed}) {
  return SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 80.0,
              child: icon,
            ),
            Expanded(
              child: Center(child: label),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
    ),
  );
}

ListView makeFeedList(MemberInfoEntity member, List<MemberFeedEntity> feedList,
    {bool shrinkWrap = true}) {
  final df = DateFormat('yyyy/MM/dd');

  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: shrinkWrap,
    itemCount: feedList.length,
    itemBuilder: (BuildContext context, int index) {
      final feed = feedList[index];
      final images = feed.tbFeedPhotoInfoList;

      var likes = feed.tbFeedLikeMemberInfoList;
      bool liked = likes?.firstWhereOrNull((element) =>
              element.memberSeq == SharedData().owner!.memberSeq) !=
          null;

      final feedDt = df.format(feed.createDt!);
      return GestureDetector(
        onTap: () {
          Get.to(() => FeedDetail(member: member, feed: feed));
        },
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
              itemBuilder: (BuildContext innerContext, int innerIndex) {
                final image = images![innerIndex];
                String photoPath = image.photoPath!;
                if (photoPath.startsWith('/') == false) {
                  photoPath = '/$photoPath';
                }
                if (photoPath.endsWith('/') == false) {
                  photoPath = '$photoPath/';
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
                    Image(
                      image: const AssetImage('assets/images/icon_like.png'),
                      width: 20.0,
                      color: liked ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      likes!.length.toString(),
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
            const SizedBox(height: 20.0),
          ],
        ),
      );
    },
  );
}
