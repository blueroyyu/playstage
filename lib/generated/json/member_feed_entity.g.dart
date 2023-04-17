import 'package:playstage/generated/json/base/json_convert_content.dart';
import 'package:playstage/people/member_feed_entity.dart';
import 'package:playstage/people/member_info_entity.dart';

MemberFeedEntity $MemberFeedEntityFromJson(Map<String, dynamic> json) {
	final MemberFeedEntity memberFeedEntity = MemberFeedEntity();
	final double? feedSeq = jsonConvert.convert<double>(json['feedSeq']);
	if (feedSeq != null) {
		memberFeedEntity.feedSeq = feedSeq;
	}
	final String? feedContent = jsonConvert.convert<String>(json['feedContent']);
	if (feedContent != null) {
		memberFeedEntity.feedContent = feedContent;
	}
	final double? memberSeq = jsonConvert.convert<double>(json['memberSeq']);
	if (memberSeq != null) {
		memberFeedEntity.memberSeq = memberSeq;
	}
	final double? feedLikeCnt = jsonConvert.convert<double>(json['feedLikeCnt']);
	if (feedLikeCnt != null) {
		memberFeedEntity.feedLikeCnt = feedLikeCnt;
	}
	final List<MemberFeedTbFeedPhotoInfoList>? tbFeedPhotoInfoList = jsonConvert.convertListNotNull<MemberFeedTbFeedPhotoInfoList>(json['tbFeedPhotoInfoList']);
	if (tbFeedPhotoInfoList != null) {
		memberFeedEntity.tbFeedPhotoInfoList = tbFeedPhotoInfoList;
	}
	final List<MemberFeedTbFeedCommentInfoList>? tbFeedCommentInfoList = jsonConvert.convertListNotNull<MemberFeedTbFeedCommentInfoList>(json['tbFeedCommentInfoList']);
	if (tbFeedCommentInfoList != null) {
		memberFeedEntity.tbFeedCommentInfoList = tbFeedCommentInfoList;
	}
	final List<MemberFeedTbFeedLikeMemberInfoList>? tbFeedLikeMemberInfoList = jsonConvert.convertListNotNull<MemberFeedTbFeedLikeMemberInfoList>(json['tbFeedLikeMemberInfoList']);
	if (tbFeedLikeMemberInfoList != null) {
		memberFeedEntity.tbFeedLikeMemberInfoList = tbFeedLikeMemberInfoList;
	}
	final List<MemberInfoEntity>? likeMemberInfoList = jsonConvert.convertListNotNull<MemberInfoEntity>(json['likeMemberInfoList']);
	if (likeMemberInfoList != null) {
		memberFeedEntity.likeMemberInfoList = likeMemberInfoList;
	}
	return memberFeedEntity;
}

Map<String, dynamic> $MemberFeedEntityToJson(MemberFeedEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['feedSeq'] = entity.feedSeq;
	data['feedContent'] = entity.feedContent;
	data['memberSeq'] = entity.memberSeq;
	data['feedLikeCnt'] = entity.feedLikeCnt;
	data['tbFeedPhotoInfoList'] =  entity.tbFeedPhotoInfoList?.map((v) => v.toJson()).toList();
	data['tbFeedCommentInfoList'] =  entity.tbFeedCommentInfoList?.map((v) => v.toJson()).toList();
	data['tbFeedLikeMemberInfoList'] =  entity.tbFeedLikeMemberInfoList?.map((v) => v.toJson()).toList();
	data['likeMemberInfoList'] =  entity.likeMemberInfoList?.map((v) => v.toJson()).toList();
	return data;
}

MemberFeedTbFeedPhotoInfoList $MemberFeedTbFeedPhotoInfoListFromJson(Map<String, dynamic> json) {
	final MemberFeedTbFeedPhotoInfoList memberFeedTbFeedPhotoInfoList = MemberFeedTbFeedPhotoInfoList();
	final double? feedPhotoSeq = jsonConvert.convert<double>(json['feedPhotoSeq']);
	if (feedPhotoSeq != null) {
		memberFeedTbFeedPhotoInfoList.feedPhotoSeq = feedPhotoSeq;
	}
	final double? feedSeq = jsonConvert.convert<double>(json['feedSeq']);
	if (feedSeq != null) {
		memberFeedTbFeedPhotoInfoList.feedSeq = feedSeq;
	}
	final String? photoFormat = jsonConvert.convert<String>(json['photoFormat']);
	if (photoFormat != null) {
		memberFeedTbFeedPhotoInfoList.photoFormat = photoFormat;
	}
	final String? photoPath = jsonConvert.convert<String>(json['photoPath']);
	if (photoPath != null) {
		memberFeedTbFeedPhotoInfoList.photoPath = photoPath;
	}
	final String? photoSavedFileName = jsonConvert.convert<String>(json['photoSavedFileName']);
	if (photoSavedFileName != null) {
		memberFeedTbFeedPhotoInfoList.photoSavedFileName = photoSavedFileName;
	}
	final String? photoOriginFileName = jsonConvert.convert<String>(json['photoOriginFileName']);
	if (photoOriginFileName != null) {
		memberFeedTbFeedPhotoInfoList.photoOriginFileName = photoOriginFileName;
	}
	return memberFeedTbFeedPhotoInfoList;
}

Map<String, dynamic> $MemberFeedTbFeedPhotoInfoListToJson(MemberFeedTbFeedPhotoInfoList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['feedPhotoSeq'] = entity.feedPhotoSeq;
	data['feedSeq'] = entity.feedSeq;
	data['photoFormat'] = entity.photoFormat;
	data['photoPath'] = entity.photoPath;
	data['photoSavedFileName'] = entity.photoSavedFileName;
	data['photoOriginFileName'] = entity.photoOriginFileName;
	return data;
}

MemberFeedTbFeedCommentInfoList $MemberFeedTbFeedCommentInfoListFromJson(Map<String, dynamic> json) {
	final MemberFeedTbFeedCommentInfoList memberFeedTbFeedCommentInfoList = MemberFeedTbFeedCommentInfoList();
	final double? commentSeq = jsonConvert.convert<double>(json['commentSeq']);
	if (commentSeq != null) {
		memberFeedTbFeedCommentInfoList.commentSeq = commentSeq;
	}
	final double? feedSeq = jsonConvert.convert<double>(json['feedSeq']);
	if (feedSeq != null) {
		memberFeedTbFeedCommentInfoList.feedSeq = feedSeq;
	}
	final double? memberSeq = jsonConvert.convert<double>(json['memberSeq']);
	if (memberSeq != null) {
		memberFeedTbFeedCommentInfoList.memberSeq = memberSeq;
	}
	final String? comment = jsonConvert.convert<String>(json['comment']);
	if (comment != null) {
		memberFeedTbFeedCommentInfoList.comment = comment;
	}
	return memberFeedTbFeedCommentInfoList;
}

Map<String, dynamic> $MemberFeedTbFeedCommentInfoListToJson(MemberFeedTbFeedCommentInfoList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['commentSeq'] = entity.commentSeq;
	data['feedSeq'] = entity.feedSeq;
	data['memberSeq'] = entity.memberSeq;
	data['comment'] = entity.comment;
	return data;
}

MemberFeedTbFeedLikeMemberInfoList $MemberFeedTbFeedLikeMemberInfoListFromJson(Map<String, dynamic> json) {
	final MemberFeedTbFeedLikeMemberInfoList memberFeedTbFeedLikeMemberInfoList = MemberFeedTbFeedLikeMemberInfoList();
	final double? memberSeq = jsonConvert.convert<double>(json['memberSeq']);
	if (memberSeq != null) {
		memberFeedTbFeedLikeMemberInfoList.memberSeq = memberSeq;
	}
	return memberFeedTbFeedLikeMemberInfoList;
}

Map<String, dynamic> $MemberFeedTbFeedLikeMemberInfoListToJson(MemberFeedTbFeedLikeMemberInfoList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['memberSeq'] = entity.memberSeq;
	return data;
}