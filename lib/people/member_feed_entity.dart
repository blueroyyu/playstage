import 'package:playstage/generated/json/base/json_field.dart';
import 'package:playstage/generated/json/member_feed_entity.g.dart';
import 'dart:convert';

import 'package:playstage/people/member_info_entity.dart';

@JsonSerializable()
class MemberFeedEntity {
	double? feedSeq;
	String? feedContent;
	double? memberSeq;
	double? feedLikeCnt;
	List<MemberFeedTbFeedPhotoInfoList>? tbFeedPhotoInfoList;
	List<MemberFeedTbFeedCommentInfoList>? tbFeedCommentInfoList;
	List<MemberFeedTbFeedLikeMemberInfoList>? tbFeedLikeMemberInfoList;
	List<MemberInfoEntity>? likeMemberInfoList;

	MemberFeedEntity();

	factory MemberFeedEntity.fromJson(Map<String, dynamic> json) => $MemberFeedEntityFromJson(json);

	Map<String, dynamic> toJson() => $MemberFeedEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberFeedTbFeedPhotoInfoList {
	double? feedPhotoSeq;
	double? feedSeq;
	String? photoFormat;
	String? photoPath;
	String? photoSavedFileName;
	String? photoOriginFileName;

	MemberFeedTbFeedPhotoInfoList();

	factory MemberFeedTbFeedPhotoInfoList.fromJson(Map<String, dynamic> json) => $MemberFeedTbFeedPhotoInfoListFromJson(json);

	Map<String, dynamic> toJson() => $MemberFeedTbFeedPhotoInfoListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberFeedTbFeedCommentInfoList {
	double? commentSeq;
	double? feedSeq;
	double? memberSeq;
	String? comment;

	MemberFeedTbFeedCommentInfoList();

	factory MemberFeedTbFeedCommentInfoList.fromJson(Map<String, dynamic> json) => $MemberFeedTbFeedCommentInfoListFromJson(json);

	Map<String, dynamic> toJson() => $MemberFeedTbFeedCommentInfoListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberFeedTbFeedLikeMemberInfoList {
	double? memberSeq;

	MemberFeedTbFeedLikeMemberInfoList();

	factory MemberFeedTbFeedLikeMemberInfoList.fromJson(Map<String, dynamic> json) => $MemberFeedTbFeedLikeMemberInfoListFromJson(json);

	Map<String, dynamic> toJson() => $MemberFeedTbFeedLikeMemberInfoListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}