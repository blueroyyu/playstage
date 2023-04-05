import 'package:playstage/generated/json/base/json_field.dart';
import 'package:playstage/generated/json/member_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MemberInfoEntity {
	late String memberId;
	late String memberName;
	late String memberBirthday;
	late String memberIntro;
	late String memberHeight;
	late String language;
	late String bodyInfo;
	late String drinkInfo;
	late String smokingInfo;
	late String memberTendencyCd;
	late String searchTendencyCd1;
	late String searchTendencyCd2;
	late String searchTendencyCd3;
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