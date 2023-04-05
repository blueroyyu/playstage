import 'package:playstage/generated/json/base/json_convert_content.dart';
import 'package:playstage/people/member_info_entity.dart';

MemberInfoEntity $MemberInfoEntityFromJson(Map<String, dynamic> json) {
	final MemberInfoEntity memberInfoEntity = MemberInfoEntity();
	final String? memberId = jsonConvert.convert<String>(json['memberId']);
	if (memberId != null) {
		memberInfoEntity.memberId = memberId;
	}
	final String? memberName = jsonConvert.convert<String>(json['memberName']);
	if (memberName != null) {
		memberInfoEntity.memberName = memberName;
	}
	final String? memberBirthday = jsonConvert.convert<String>(json['memberBirthday']);
	if (memberBirthday != null) {
		memberInfoEntity.memberBirthday = memberBirthday;
	}
	final String? memberIntro = jsonConvert.convert<String>(json['memberIntro']);
	if (memberIntro != null) {
		memberInfoEntity.memberIntro = memberIntro;
	}
	final String? memberHeight = jsonConvert.convert<String>(json['memberHeight']);
	if (memberHeight != null) {
		memberInfoEntity.memberHeight = memberHeight;
	}
	final String? language = jsonConvert.convert<String>(json['language']);
	if (language != null) {
		memberInfoEntity.language = language;
	}
	final String? bodyInfo = jsonConvert.convert<String>(json['bodyInfo']);
	if (bodyInfo != null) {
		memberInfoEntity.bodyInfo = bodyInfo;
	}
	final String? drinkInfo = jsonConvert.convert<String>(json['drinkInfo']);
	if (drinkInfo != null) {
		memberInfoEntity.drinkInfo = drinkInfo;
	}
	final String? smokingInfo = jsonConvert.convert<String>(json['smokingInfo']);
	if (smokingInfo != null) {
		memberInfoEntity.smokingInfo = smokingInfo;
	}
	final String? memberTendencyCd = jsonConvert.convert<String>(json['memberTendencyCd']);
	if (memberTendencyCd != null) {
		memberInfoEntity.memberTendencyCd = memberTendencyCd;
	}
	final String? searchTendencyCd1 = jsonConvert.convert<String>(json['searchTendencyCd1']);
	if (searchTendencyCd1 != null) {
		memberInfoEntity.searchTendencyCd1 = searchTendencyCd1;
	}
	final String? searchTendencyCd2 = jsonConvert.convert<String>(json['searchTendencyCd2']);
	if (searchTendencyCd2 != null) {
		memberInfoEntity.searchTendencyCd2 = searchTendencyCd2;
	}
	final String? searchTendencyCd3 = jsonConvert.convert<String>(json['searchTendencyCd3']);
	if (searchTendencyCd3 != null) {
		memberInfoEntity.searchTendencyCd3 = searchTendencyCd3;
	}
	final List<MemberInfoTbMemberPhotoInfoList>? tbMemberPhotoInfoList = jsonConvert.convertListNotNull<MemberInfoTbMemberPhotoInfoList>(json['tbMemberPhotoInfoList']);
	if (tbMemberPhotoInfoList != null) {
		memberInfoEntity.tbMemberPhotoInfoList = tbMemberPhotoInfoList;
	}
	return memberInfoEntity;
}

Map<String, dynamic> $MemberInfoEntityToJson(MemberInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['memberId'] = entity.memberId;
	data['memberName'] = entity.memberName;
	data['memberBirthday'] = entity.memberBirthday;
	data['memberIntro'] = entity.memberIntro;
	data['memberHeight'] = entity.memberHeight;
	data['language'] = entity.language;
	data['bodyInfo'] = entity.bodyInfo;
	data['drinkInfo'] = entity.drinkInfo;
	data['smokingInfo'] = entity.smokingInfo;
	data['memberTendencyCd'] = entity.memberTendencyCd;
	data['searchTendencyCd1'] = entity.searchTendencyCd1;
	data['searchTendencyCd2'] = entity.searchTendencyCd2;
	data['searchTendencyCd3'] = entity.searchTendencyCd3;
	data['tbMemberPhotoInfoList'] =  entity.tbMemberPhotoInfoList.map((v) => v.toJson()).toList();
	return data;
}

MemberInfoTbMemberPhotoInfoList $MemberInfoTbMemberPhotoInfoListFromJson(Map<String, dynamic> json) {
	final MemberInfoTbMemberPhotoInfoList memberInfoTbMemberPhotoInfoList = MemberInfoTbMemberPhotoInfoList();
	final int? photoSeq = jsonConvert.convert<int>(json['photoSeq']);
	if (photoSeq != null) {
		memberInfoTbMemberPhotoInfoList.photoSeq = photoSeq;
	}
	final String? photoSavedFileName = jsonConvert.convert<String>(json['photoSavedFileName']);
	if (photoSavedFileName != null) {
		memberInfoTbMemberPhotoInfoList.photoSavedFileName = photoSavedFileName;
	}
	return memberInfoTbMemberPhotoInfoList;
}

Map<String, dynamic> $MemberInfoTbMemberPhotoInfoListToJson(MemberInfoTbMemberPhotoInfoList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['photoSeq'] = entity.photoSeq;
	data['photoSavedFileName'] = entity.photoSavedFileName;
	return data;
}