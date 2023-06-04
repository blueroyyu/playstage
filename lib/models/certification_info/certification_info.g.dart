// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certification_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificationInfo _$CertificationInfoFromJson(Map<String, dynamic> json) =>
    CertificationInfo(
      birth: json['birth'] as int?,
      birthday: json['birthday'] as String?,
      certified: json['certified'] as bool?,
      certifiedAt: json['certified_at'] as int?,
      foreigner: json['foreigner'] as bool?,
      foreignerV2: json['foreigner_v2'],
      gender: json['gender'] as String?,
      impUid: json['imp_uid'] as String?,
      merchantUid: json['merchant_uid'] as String?,
      name: json['name'] as String?,
      origin: json['origin'] as String?,
      pgProvider: json['pg_provider'] as String?,
      pgTid: json['pg_tid'] as String?,
      uniqueInSite: json['unique_in_site'] as String?,
      uniqueKey: json['unique_key'] as String?,
    );

Map<String, dynamic> _$CertificationInfoToJson(CertificationInfo instance) =>
    <String, dynamic>{
      'birth': instance.birth,
      'birthday': instance.birthday,
      'certified': instance.certified,
      'certified_at': instance.certifiedAt,
      'foreigner': instance.foreigner,
      'foreigner_v2': instance.foreignerV2,
      'gender': instance.gender,
      'imp_uid': instance.impUid,
      'merchant_uid': instance.merchantUid,
      'name': instance.name,
      'origin': instance.origin,
      'pg_provider': instance.pgProvider,
      'pg_tid': instance.pgTid,
      'unique_in_site': instance.uniqueInSite,
      'unique_key': instance.uniqueKey,
    };
