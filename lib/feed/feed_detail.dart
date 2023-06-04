import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:mysql1/mysql1.dart';
import 'package:playstage/const.dart';
import 'package:playstage/feed/like_feed_view.dart';
import 'package:playstage/people/member_feed_entity/member_feed_entity.dart';
import 'package:playstage/people/member_feed_entity/tb_feed_comment_info_list.dart';
import 'package:playstage/people/member_feed_entity/tb_feed_like_member_info_list.dart';
import 'package:playstage/people/member_feed_entity/tb_feed_photo_info_list.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/people/people_detail.dart';
import 'package:playstage/shared_data.dart';
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

  MemberInfoEntity? member;
  MemberFeedEntity? feed;
  List<TbFeedPhotoInfoList>? images;
  List<TbFeedLikeMemberInfoList>? likes;
  List<TbFeedCommentInfoList>? comments;
  List<MemberInfoEntity> commentWriters = <MemberInfoEntity>[];

  bool liked = false;

  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    member = widget.member;
    feed = widget.feed;
    images = feed?.tbFeedPhotoInfoList;
    likes = feed?.tbFeedLikeMemberInfoList;
    comments = feed?.tbFeedCommentInfoList;

    liked = likes?.firstWhereOrNull(
            (element) => element.memberSeq == SharedData().owner!.memberSeq) !=
        null;

    _loadLikeList();
    _loadCommentWriterList();
  }

  Future<void> _loadLikeList() async {
    likeList.clear();

    for (TbFeedLikeMemberInfoList like in likes!) {
      int seq = like.memberSeq!;

      final responseData = await ApiProvider.requestMemberBySeq(seq);
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

  // Future<MySqlConnection> getConnection() async {
  //   final conn = await MySqlConnection.connect(ConnectionSettings(
  //     host: '3.35.179.159',
  //     port: 3306,
  //     user: 'playstage_dev',
  //     password: 'playstage@2023!',
  //     db: 'playstage_new',
  //   ));
  //   return conn;
  // }

  Future<void> _loadCommentWriterList() async {
    commentWriters.clear();

    // MySqlConnection conn = await getConnection();

    for (TbFeedCommentInfoList comment in comments!) {
      // TODO: request member_seq should be in commentList
      // var results = await conn.query(
      //     'select member_seq from TB_FEED_COMMENT_INFO where comment_seq = ?',
      //     [comment.commentSeq]);
      // var row = results.first;
      // comment.memberSeq = row['member_seq'];

      int seq = comment.memberSeq!;

      final responseData = await ApiProvider.requestMemberBySeq(seq);
      if (responseData['resultCode'] == '200') {
        final memberMap = responseData['data'];
        MemberInfoEntity info = MemberInfoEntity.fromMap(memberMap);
        if (kDebugMode) {
          print(info.toString());
        }

        setState(() {
          commentWriters.add(info);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    final df = DateFormat('yyyy/MM/dd');
    final feedDt = df.format(feed!.createDt!);

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 88,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: member!.name(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 5.0),
                            ),
                            TextSpan(
                              text: member!.age().toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(member!.memberTendency()),
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            member!.makeProfileImagePath()),
                      ),
                      onTap: () {},
                    ),
                    feed?.feedContent == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              feed!.feedContent ?? '',
                              style: const TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          )
                        : Container(),
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
                        if (photoPath.endsWith('/') == false) {
                          photoPath = '$photoPath/';
                        }
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                '$s3Url$photoPath${image.photoSavedFileName}',
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                'assets/images/default_profile.png',
                                fit: BoxFit.cover,
                              );
                            },
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) {
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
                            InkWell(
                              onTap: () async {
                                try {
                                  dynamic responseData =
                                      await ApiProvider.requestHandleFeedLike(
                                          SharedData().owner!.memberId!,
                                          feed!.feedSeq!);

                                  if (kDebugMode) {
                                    print(responseData);
                                  }

                                  setState(() {
                                    liked = !liked;
                                  });

                                  if (liked) {
                                    likes!.add(TbFeedLikeMemberInfoList(
                                        memberSeq:
                                            SharedData().owner!.memberSeq));
                                  } else {
                                    likes!.removeWhere((element) =>
                                        element.memberSeq ==
                                        SharedData().owner!.memberSeq);
                                  }

                                  _loadLikeList();
                                } on Exception catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                }
                              },
                              child: Image(
                                image: const AssetImage(
                                    'assets/images/icon_like.png'),
                                width: 20.0,
                                color: liked ? Colors.red : Colors.grey,
                              ),
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
                              comments!.length.toString(),
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
                    GestureDetector(
                      onTap: () {
                        Get.to(() => LikeFeedView(likeList: likeList));
                      },
                      child: SizedBox(
                        width: safeAreaWidth,
                        height: 30.0,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: likeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(() => LikeFeedView(likeList: likeList));
                                setState(() {
                                  liked = !liked;
                                });
                              },
                              child: likeList.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        likeList[index].makeProfileImagePath(),
                                      ),
                                    )
                                  : Container(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: comments!.length,
                      itemBuilder: (context, index) {
                        final comment = comments![index];
                        String photoPath = comment.memberPhotoPath!;
                        if (photoPath.startsWith('https://')) {
                        } else {
                          if (photoPath.startsWith('/') == false) {
                            photoPath = '/$photoPath';
                          }
                          if (photoPath.endsWith('/') == false) {
                            photoPath = '$photoPath/';
                          }
                          photoPath =
                              '$s3Url$photoPath${comment.memberPhotoSavedFileName!}';
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
                              photoPath,
                            ),
                          ),
                          onTap: () {
                            Get.to(() => PeopleDetail(
                                memberInfoEntity: commentWriters[index]));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: SizedBox(
                          height: 50.0,
                          child: TextFormField(
                            controller: _commentController,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              hintText: '댓글을 입력하세요.',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(25.0),
                                  right: Radius.circular(25.0),
                                ),
                              ),
                              filled: true,
                              fillColor: colorTextFieldBg,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Container(
                        width: 70.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorTextFieldBg,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final comment = _commentController.text;
                            if (comment.isEmpty) {
                              return;
                            }

                            try {
                              final responseData =
                                  await ApiProvider.requestHandleComment(
                                      SharedData().owner!.memberId!,
                                      feed!.feedSeq!,
                                      comment);

                              if (kDebugMode) {
                                print(responseData);
                              }

                              final newComment = TbFeedCommentInfoList(
                                feedSeq: feed!.feedSeq,
                                comment: comment,
                                memberName: SharedData().owner!.name(),
                                memberPhotoPath:
                                    SharedData().owner!.makeProfileImagePath(),
                                createDt: DateTime.now(),
                              );
                              setState(() {
                                comments!.add(newComment);
                                _commentController.text = '';
                              });
                            } on Exception catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
                          icon: Image.asset(
                            'assets/images/icon_send.png',
                            height: 25.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
