import 'dart:convert';

import 'package:get/get.dart';
import 'package:playstage/const.dart';
import 'package:playstage/sign_up/subscriber_info.dart';

import 'tb_member_photo_info_list.dart';

class MemberInfoEntity {
  int? memberSeq;
  String? memberId;
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
  List<TbMemberPhotoInfoList>? tbMemberPhotoInfoList;

  MemberInfoEntity({
    this.memberSeq,
    this.memberId,
    this.memberName,
    this.memberBirthday,
    this.memberIntro,
    this.memberHeight,
    this.language,
    this.bodyInfo,
    this.drinkInfo,
    this.smokingInfo,
    this.memberTendencyCd,
    this.searchTendencyCd1,
    this.searchTendencyCd2,
    this.searchTendencyCd3,
    this.tbMemberPhotoInfoList,
  });

  @override
  String toString() {
    return 'MemberInfoEntity(memberSeq: $memberSeq, memberId: $memberId, memberName: $memberName, memberBirthday: $memberBirthday, memberIntro: $memberIntro, memberHeight: $memberHeight, language: $language, bodyInfo: $bodyInfo, drinkInfo: $drinkInfo, smokingInfo: $smokingInfo, memberTendencyCd: $memberTendencyCd, searchTendencyCd1: $searchTendencyCd1, searchTendencyCd2: $searchTendencyCd2, searchTendencyCd3: $searchTendencyCd3, tbMemberPhotoInfoList: $tbMemberPhotoInfoList)';
  }

  factory MemberInfoEntity.fromMap(Map<String, dynamic> data) {
    return MemberInfoEntity(
      memberSeq: data['memberSeq'] as int?,
      memberId: data['memberId'] as String?,
      memberName: data['memberName'] as String?,
      memberBirthday: data['memberBirthday'] as String?,
      memberIntro: data['memberIntro'] as String?,
      memberHeight: data['memberHeight'] as String?,
      language: data['language'] as String?,
      bodyInfo: data['bodyInfo'] as String?,
      drinkInfo: data['drinkInfo'] as String?,
      smokingInfo: data['smokingInfo'] as String?,
      memberTendencyCd: data['memberTendencyCd'] as String?,
      searchTendencyCd1: data['searchTendencyCd1'] as String?,
      searchTendencyCd2: data['searchTendencyCd2'] as String?,
      searchTendencyCd3: data['searchTendencyCd3'] as String?,
      tbMemberPhotoInfoList: (data['tbMemberPhotoInfoList'] as List<dynamic>?)
          ?.map((e) => TbMemberPhotoInfoList.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'memberSeq': memberSeq,
        'memberId': memberId,
        'memberName': memberName,
        'memberBirthday': memberBirthday,
        'memberIntro': memberIntro,
        'memberHeight': memberHeight,
        'language': language,
        'bodyInfo': bodyInfo,
        'drinkInfo': drinkInfo,
        'smokingInfo': smokingInfo,
        'memberTendencyCd': memberTendencyCd,
        'searchTendencyCd1': searchTendencyCd1,
        'searchTendencyCd2': searchTendencyCd2,
        'searchTendencyCd3': searchTendencyCd3,
        'tbMemberPhotoInfoList':
            tbMemberPhotoInfoList?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MemberInfoEntity].
  factory MemberInfoEntity.fromJson(String data) {
    return MemberInfoEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MemberInfoEntity] to a JSON string.
  String toJson() => json.encode(toMap());

  MemberInfoEntity copyWith({
    int? memberSeq,
    String? memberId,
    String? memberName,
    String? memberBirthday,
    String? memberIntro,
    String? memberHeight,
    String? language,
    String? bodyInfo,
    String? drinkInfo,
    String? smokingInfo,
    String? memberTendencyCd,
    String? searchTendencyCd1,
    String? searchTendencyCd2,
    String? searchTendencyCd3,
    List<TbMemberPhotoInfoList>? tbMemberPhotoInfoList,
  }) {
    return MemberInfoEntity(
      memberSeq: memberSeq ?? this.memberSeq,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      memberBirthday: memberBirthday ?? this.memberBirthday,
      memberIntro: memberIntro ?? this.memberIntro,
      memberHeight: memberHeight ?? this.memberHeight,
      language: language ?? this.language,
      bodyInfo: bodyInfo ?? this.bodyInfo,
      drinkInfo: drinkInfo ?? this.drinkInfo,
      smokingInfo: smokingInfo ?? this.smokingInfo,
      memberTendencyCd: memberTendencyCd ?? this.memberTendencyCd,
      searchTendencyCd1: searchTendencyCd1 ?? this.searchTendencyCd1,
      searchTendencyCd2: searchTendencyCd2 ?? this.searchTendencyCd2,
      searchTendencyCd3: searchTendencyCd3 ?? this.searchTendencyCd3,
      tbMemberPhotoInfoList:
          tbMemberPhotoInfoList ?? this.tbMemberPhotoInfoList,
    );
  }

  String name() => memberName ?? '';

  String memberTendency() {
    String? td = tendencies
        .firstWhere((element) => element["code"] == memberTendencyCd)["label"];
    return td ?? '';
  }

  String searchTendency() {
    String? td1 = tendencies
        .firstWhere((element) => element["code"] == searchTendencyCd1)["label"];
    String? td2 = tendencies
        .firstWhere((element) => element["code"] == searchTendencyCd2)["label"];
    String? td3 = tendencies
        .firstWhere((element) => element["code"] == searchTendencyCd3)["label"];

    String td = '';
    if (td1 != null && td1.isNotEmpty) {
      td = td1;
    }
    if (td2 != null && td2.isNotEmpty) {
      td += ', $td2';
    }
    if (td3 != null && td3.isNotEmpty) {
      td += ', $td3';
    }

    return td;
  }

  String height() {
    String height = memberHeight ?? '';
    if (height.isNotEmpty) {
      height = '${height}cm';
    } else {
      height = '-';
    }

    return height;
  }

  String bodyType() {
    Map? data =
        bodyTypes.firstWhereOrNull((element) => element["code"] == bodyInfo);

    String label = '-';
    if (data != null) {
      label = data['label'];
    }

    return label;
  }

  String spokenLanguage() {
    Map? data =
        languages.firstWhereOrNull((element) => element["code"] == language);

    String label = '-';
    if (data != null) {
      label = data['label'];
    }

    return label;
  }

  String frequency({required code}) {
    Map? data =
        frequencies.firstWhereOrNull((element) => element["code"] == code);

    String label = '-';
    if (data != null) {
      label = data['label'];
    }

    return label;
  }

  int age() {
    int year = int.parse(memberBirthday!.substring(0, 4));
    int month = int.parse(memberBirthday!.substring(4, 6));
    int day = int.parse(memberBirthday!.substring(6, 8));

    DateTime birthDate = DateTime(year, month, day);
    DateTime now = DateTime.now();

    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  String makeProfileImagePath() {
    if (tbMemberPhotoInfoList == null || tbMemberPhotoInfoList!.isEmpty) {
      return '';
    }
    return '$s3Url/$memberId/profile/${tbMemberPhotoInfoList![0].photoSavedFileName}';
  }
}
