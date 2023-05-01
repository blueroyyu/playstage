import 'dart:convert';

class TbMemberPhotoInfoList {
  int? photoSeq;
  String? photoSavedFileName;

  TbMemberPhotoInfoList({this.photoSeq, this.photoSavedFileName});

  @override
  String toString() {
    return 'TbMemberPhotoInfoList(photoSeq: $photoSeq, photoSavedFileName: $photoSavedFileName)';
  }

  factory TbMemberPhotoInfoList.fromMap(Map<String, dynamic> data) {
    return TbMemberPhotoInfoList(
      photoSeq: data['photoSeq'] as int?,
      photoSavedFileName: data['photoSavedFileName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'photoSeq': photoSeq,
        'photoSavedFileName': photoSavedFileName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TbMemberPhotoInfoList].
  factory TbMemberPhotoInfoList.fromJson(String data) {
    return TbMemberPhotoInfoList.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TbMemberPhotoInfoList] to a JSON string.
  String toJson() => json.encode(toMap());

  TbMemberPhotoInfoList copyWith({
    int? photoSeq,
    String? photoSavedFileName,
  }) {
    return TbMemberPhotoInfoList(
      photoSeq: photoSeq ?? this.photoSeq,
      photoSavedFileName: photoSavedFileName ?? this.photoSavedFileName,
    );
  }
}
