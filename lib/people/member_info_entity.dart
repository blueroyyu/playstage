import 'package:playstage/generated/json/base/json_field.dart';
import 'package:playstage/generated/json/member_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MemberInfoEntity {
	late String memberId;
	String? memberName;
	String? memberBirthday;
	String? memberIntro;
	String? memberHeight;
	String? language;
	String? bodyInfo;
	String? drinkInfo;
	String? smokingInfo;
	String? memberTendencyCd;
	String? searchTendencyCd1;
	String? searchTendencyCd2;
	String? searchTendencyCd3;
	late List<MemberInfoTbMemberPhotoInfoList> tbMemberPhotoInfoList;

	MemberInfoEntity();

	factory MemberInfoEntity.fromJson(Map<String, dynamic> json) => $MemberInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $MemberInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberInfoTbMemberPhotoInfoList {
	late int photoSeq;
	late String photoSavedFileName;

	MemberInfoTbMemberPhotoInfoList();

	factory MemberInfoTbMemberPhotoInfoList.fromJson(Map<String, dynamic> json) => $MemberInfoTbMemberPhotoInfoListFromJson(json);

	Map<String, dynamic> toJson() => $MemberInfoTbMemberPhotoInfoListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}