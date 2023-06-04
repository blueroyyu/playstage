import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:mysql1/mysql1.dart';
import 'package:playstage/const.dart';
import 'package:playstage/feed/feed_detail.dart';
import 'package:playstage/feed/like_feed_view.dart';
import 'package:playstage/people/main_view.dart';
import 'package:playstage/people/member_feed_entity/member_feed_entity.dart';
import 'package:playstage/people/member_feed_entity/tb_feed_like_member_info_list.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/api_provider.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key, required this.member}) : super(key: key);

  final MemberInfoEntity member;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late final MemberInfoEntity _member;
  final List<MemberFeedEntity> _feedList = <MemberFeedEntity>[];
  final List<dynamic> _feedLikeList = <dynamic>[];
  final List<MemberInfoEntity> _feedWriters = <MemberInfoEntity>[];

  int _pageNumber = 0;
  final _pageSize = 10;

  int _totalPage = 1;
  int _totalCount = 0;

  final _scrollController = ScrollController();

  final df = DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    _member = widget.member;
    _loadFeeds();

    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadFeeds();
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

  Future<void> _loadFeeds() async {
    // var conn = await getConnection();

    if (_totalPage > _pageNumber) {
      _pageNumber++;
    } else {
      return;
    }

    final responseData = await ApiProvider.requestFeedList(
        _member.memberSeq!, _pageNumber, _pageSize);
    if (responseData['resultCode'] == '200') {
      _totalPage = responseData['totalPage'];
      _totalCount = responseData['totalCount'];

      final feedList = responseData['data'];
      if (feedList.length > 0) {
        for (dynamic map in feedList.reversed) {
          MemberFeedEntity info = MemberFeedEntity.fromMap(map);
          if (kDebugMode) {
            print(info.toString());
          }

          // TODO: request member_seq should be in feedList
          // TODO: paging
          // var results = await conn.query(
          //     'select member_seq from TB_FEED_INFO where feed_seq = ?',
          //     [info.feedSeq]);
          // var row = results.first;
          // info.memberSeq = row['member_seq'];
          setState(() {
            _feedList.add(info);
          });

          final responseMember =
              await ApiProvider.requestMemberBySeq(info.memberSeq!);
          if (responseMember['resultCode'] == '200') {
            final memberMap = responseMember['data'];
            MemberInfoEntity info = MemberInfoEntity.fromMap(memberMap);
            if (kDebugMode) {
              print(info.toString());
            }

            setState(() {
              _feedWriters.add(info);
            });
          }

          await _loadLikeList(info.tbFeedLikeMemberInfoList!);
        }

        if (kDebugMode) {
          print(_feedList.toString());
        }
      }
    }
  }

  Future<void> _loadLikeList(List<TbFeedLikeMemberInfoList> likes) async {
    List<MemberInfoEntity> likeList = <MemberInfoEntity>[];

    for (TbFeedLikeMemberInfoList like in likes) {
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

    _feedLikeList.add(likeList);
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
          child: Text(
            'feed'.tr,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 88,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _feedList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final feed = _feedList[index];
                    final member = _feedWriters.length > index
                        ? _feedWriters[index]
                        : MemberInfoEntity();
                    final images = feed.tbFeedPhotoInfoList;

                    var likes = feed.tbFeedLikeMemberInfoList;
                    bool liked = likes?.firstWhereOrNull((element) =>
                            element.memberSeq ==
                            SharedData().owner!.memberSeq) !=
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
                              backgroundImage: CachedNetworkImageProvider(
                                  member.makeProfileImagePath()),
                            ),
                          ),
                          feed.feedContent == null
                              ? Padding(
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
                                )
                              : Container(),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  _calculateColumnCount(images!.length),
                              // 다른 속성 설정 가능
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: images.length,
                            padding: const EdgeInsets.all(20.0),
                            itemBuilder:
                                (BuildContext innerContext, int innerIndex) {
                              final image = images[innerIndex];
                              String photoPath = image.photoPath!;
                              if (photoPath.startsWith('/') == false) {
                                photoPath = '/$photoPath';
                              }
                              if (photoPath.endsWith('/') == false) {
                                photoPath = '$photoPath/';
                              }
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: AspectRatio(
                                  aspectRatio: 1.0,
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 20.0),
                              const Image(
                                image:
                                    AssetImage('assets/images/icon_time.png'),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Spacer(),
                                  Image(
                                    image: const AssetImage(
                                        'assets/images/icon_like.png'),
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
                                    image: AssetImage(
                                        'assets/images/icon_reply.png'),
                                    width: 16.0,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    feed.tbFeedCommentInfoList!.length
                                        .toString(),
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
                          SizedBox(
                              height: _feedLikeList.length > index &&
                                      _feedLikeList[index].isNotEmpty
                                  ? 10.0
                                  : 0.0),
                          _feedLikeList.length > index &&
                                  _feedLikeList[index].isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    Get.to(() => LikeFeedView(
                                        likeList: _feedLikeList[index]));
                                  },
                                  child: SizedBox(
                                    width: safeAreaWidth,
                                    height: 30.0,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: _feedLikeList[index].length,
                                      itemBuilder: (context, innerIndex) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => LikeFeedView(
                                                likeList:
                                                    _feedLikeList[index]));
                                            setState(() {
                                              liked = !liked;
                                            });
                                          },
                                          child: _feedLikeList[index].isNotEmpty
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    _feedLikeList[index]
                                                            [innerIndex]
                                                        .makeProfileImagePath(),
                                                  ),
                                                )
                                              : Container(),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            MainTab(index: 2),
          ],
        ),
      ),
    );
  }

  int _calculateColumnCount(int imageCount) {
    if (imageCount < 2) {
      return 1;
    } else {
      return 2;
    }
  }
}
