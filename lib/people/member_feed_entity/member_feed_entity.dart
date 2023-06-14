import 'dart:convert';

import 'package:playstage/people/member_info_entity/member_info_entity.dart';

import 'tb_feed_comment_info_list.dart';
import 'tb_feed_like_member_info_list.dart';
import 'tb_feed_photo_info_list.dart';

class MemberFeedEntity {
  int? feedSeq;
  String? feedContent;
  int? memberSeq;
  String? memberName;
  String? nickName;
  String? memberPhotoPath;
  String? memberPhotoSavedFileName;
  int? feedLikeCnt;
  DateTime? createDt;
  List<TbFeedPhotoInfoList>? tbFeedPhotoInfoList;
  List<TbFeedCommentInfoList>? tbFeedCommentInfoList;
  List<TbFeedLikeMemberInfoList>? tbFeedLikeMemberInfoList;
  List<MemberInfoEntity>? likeMemberInfoList;

  MemberFeedEntity({
    this.feedSeq,
    this.feedContent,
    this.memberSeq,
    this.memberName,
    this.nickName,
    this.memberPhotoPath,
    this.memberPhotoSavedFileName,
    this.feedLikeCnt,
    this.createDt,
    this.tbFeedPhotoInfoList,
    this.tbFeedCommentInfoList,
    this.tbFeedLikeMemberInfoList,
    this.likeMemberInfoList,
  });

  @override
  String toString() {
    return 'MemberFeedEntity(feedSeq: $feedSeq, feedContent: $feedContent, memberSeq: $memberSeq, memberName: $memberName, nickName: $nickName, memberPhotoPath: $memberPhotoPath, memberPhotoSavedFileName: $memberPhotoSavedFileName, feedLikeCnt: $feedLikeCnt, createDt: $createDt, tbFeedPhotoInfoList: $tbFeedPhotoInfoList, tbFeedCommentInfoList: $tbFeedCommentInfoList, tbFeedLikeMemberInfoList: $tbFeedLikeMemberInfoList, likeMemberInfoList: $likeMemberInfoList)';
  }

  factory MemberFeedEntity.fromMap(Map<String, dynamic> data) {
    return MemberFeedEntity(
      feedSeq: data['feedSeq'] as int?,
      feedContent: data['feedContent'] as String?,
      memberSeq: data['memberSeq'] as int?,
      memberName: data['memberName'] as String?,
      nickName: data['nickName'] as String?,
      memberPhotoPath: data['memberPhotoPath'] as String?,
      memberPhotoSavedFileName: data['memberPhotoSavedFileName'] as String?,
      feedLikeCnt: data['feedLikeCnt'] as int?,
      createDt: data['createDt'] == null
          ? null
          : DateTime.parse(data['createDt'] as String),
      tbFeedPhotoInfoList: (data['tbFeedPhotoInfoList'] as List<dynamic>?)
          ?.map((e) => TbFeedPhotoInfoList.fromMap(e as Map<String, dynamic>))
          .toList(),
      tbFeedCommentInfoList: (data['tbFeedCommentInfoList'] as List<dynamic>?)
          ?.map((e) => TbFeedCommentInfoList.fromMap(e as Map<String, dynamic>))
          .toList(),
      tbFeedLikeMemberInfoList:
          (data['tbFeedLikeMemberInfoList'] as List<dynamic>?)
              ?.map((e) =>
                  TbFeedLikeMemberInfoList.fromMap(e as Map<String, dynamic>))
              .toList(),
      likeMemberInfoList: (data['likeMemberInfoList'] as List<dynamic>?)
          ?.map((e) => MemberInfoEntity.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'feedSeq': feedSeq,
        'feedContent': feedContent,
        'memberSeq': memberSeq,
        'memberName': memberName,
        'nickName': nickName,
        'memberPhotoPath': memberPhotoPath,
        'memberPhotoSavedFileName': memberPhotoSavedFileName,
        'feedLikeCnt': feedLikeCnt,
        'createDt': createDt?.toIso8601String(),
        'tbFeedPhotoInfoList':
            tbFeedPhotoInfoList?.map((e) => e.toMap()).toList(),
        'tbFeedCommentInfoList':
            tbFeedCommentInfoList?.map((e) => e.toMap()).toList(),
        'tbFeedLikeMemberInfoList':
            tbFeedLikeMemberInfoList?.map((e) => e.toMap()).toList(),
        'likeMemberInfoList':
            likeMemberInfoList?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MemberFeedEntity].
  factory MemberFeedEntity.fromJson(String data) {
    return MemberFeedEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MemberFeedEntity] to a JSON string.
  String toJson() => json.encode(toMap());

  MemberFeedEntity copyWith({
    int? feedSeq,
    String? feedContent,
    int? memberSeq,
    String? memberName,
    String? nickName,
    String? memberPhotoPath,
    String? memberPhotoSavedFileName,
    int? feedLikeCnt,
    DateTime? createDt,
    List<TbFeedPhotoInfoList>? tbFeedPhotoInfoList,
    List<TbFeedCommentInfoList>? tbFeedCommentInfoList,
    List<TbFeedLikeMemberInfoList>? tbFeedLikeMemberInfoList,
    List<MemberInfoEntity>? likeMemberInfoList,
  }) {
    return MemberFeedEntity(
      feedSeq: feedSeq ?? this.feedSeq,
      feedContent: feedContent ?? this.feedContent,
      memberSeq: memberSeq ?? this.memberSeq,
      memberName: memberName ?? this.memberName,
      nickName: nickName ?? this.nickName,
      memberPhotoPath: memberPhotoPath ?? this.memberPhotoPath,
      memberPhotoSavedFileName:
          memberPhotoSavedFileName ?? this.memberPhotoSavedFileName,
      feedLikeCnt: feedLikeCnt ?? this.feedLikeCnt,
      createDt: createDt ?? this.createDt,
      tbFeedPhotoInfoList: tbFeedPhotoInfoList ?? this.tbFeedPhotoInfoList,
      tbFeedCommentInfoList:
          tbFeedCommentInfoList ?? this.tbFeedCommentInfoList,
      tbFeedLikeMemberInfoList:
          tbFeedLikeMemberInfoList ?? this.tbFeedLikeMemberInfoList,
      likeMemberInfoList: likeMemberInfoList ?? this.likeMemberInfoList,
    );
  }
}
