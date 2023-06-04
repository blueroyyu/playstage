import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certification_info.g.dart';

@JsonSerializable()
class CertificationInfo {
  int? birth;
  String? birthday;
  bool? certified;
  @JsonKey(name: 'certified_at')
  int? certifiedAt;
  bool? foreigner;
  @JsonKey(name: 'foreigner_v2')
  dynamic foreignerV2;
  String? gender;
  @JsonKey(name: 'imp_uid')
  String? impUid;
  @JsonKey(name: 'merchant_uid')
  String? merchantUid;
  String? name;
  String? origin;
  @JsonKey(name: 'pg_provider')
  String? pgProvider;
  @JsonKey(name: 'pg_tid')
  String? pgTid;
  @JsonKey(name: 'unique_in_site')
  String? uniqueInSite;
  @JsonKey(name: 'unique_key')
  String? uniqueKey;

  CertificationInfo({
    this.birth,
    this.birthday,
    this.certified,
    this.certifiedAt,
    this.foreigner,
    this.foreignerV2,
    this.gender,
    this.impUid,
    this.merchantUid,
    this.name,
    this.origin,
    this.pgProvider,
    this.pgTid,
    this.uniqueInSite,
    this.uniqueKey,
  });

  @override
  String toString() {
    return 'CertificationInfo(birth: $birth, birthday: $birthday, certified: $certified, certifiedAt: $certifiedAt, foreigner: $foreigner, foreignerV2: $foreignerV2, gender: $gender, impUid: $impUid, merchantUid: $merchantUid, name: $name, origin: $origin, pgProvider: $pgProvider, pgTid: $pgTid, uniqueInSite: $uniqueInSite, uniqueKey: $uniqueKey)';
  }

  factory CertificationInfo.fromJson(Map<String, dynamic> json) {
    return _$CertificationInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CertificationInfoToJson(this);

  CertificationInfo copyWith({
    int? birth,
    String? birthday,
    bool? certified,
    int? certifiedAt,
    bool? foreigner,
    dynamic foreignerV2,
    String? gender,
    String? impUid,
    String? merchantUid,
    String? name,
    String? origin,
    String? pgProvider,
    String? pgTid,
    String? uniqueInSite,
    String? uniqueKey,
  }) {
    return CertificationInfo(
      birth: birth ?? this.birth,
      birthday: birthday ?? this.birthday,
      certified: certified ?? this.certified,
      certifiedAt: certifiedAt ?? this.certifiedAt,
      foreigner: foreigner ?? this.foreigner,
      foreignerV2: foreignerV2 ?? this.foreignerV2,
      gender: gender ?? this.gender,
      impUid: impUid ?? this.impUid,
      merchantUid: merchantUid ?? this.merchantUid,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      pgProvider: pgProvider ?? this.pgProvider,
      pgTid: pgTid ?? this.pgTid,
      uniqueInSite: uniqueInSite ?? this.uniqueInSite,
      uniqueKey: uniqueKey ?? this.uniqueKey,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CertificationInfo) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      birth.hashCode ^
      birthday.hashCode ^
      certified.hashCode ^
      certifiedAt.hashCode ^
      foreigner.hashCode ^
      foreignerV2.hashCode ^
      gender.hashCode ^
      impUid.hashCode ^
      merchantUid.hashCode ^
      name.hashCode ^
      origin.hashCode ^
      pgProvider.hashCode ^
      pgTid.hashCode ^
      uniqueInSite.hashCode ^
      uniqueKey.hashCode;
}
