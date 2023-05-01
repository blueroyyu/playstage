import 'dart:convert';

class TbFeedPhotoInfoList {
  int? feedPhotoSeq;
  int? feedSeq;
  String? photoFormat;
  String? photoPath;
  String? photoSavedFileName;
  String? photoOriginFileName;

  TbFeedPhotoInfoList({
    this.feedPhotoSeq,
    this.feedSeq,
    this.photoFormat,
    this.photoPath,
    this.photoSavedFileName,
    this.photoOriginFileName,
  });

  @override
  String toString() {
    return 'TbFeedPhotoInfoList(feedPhotoSeq: $feedPhotoSeq, feedSeq: $feedSeq, photoFormat: $photoFormat, photoPath: $photoPath, photoSavedFileName: $photoSavedFileName, photoOriginFileName: $photoOriginFileName)';
  }

  factory TbFeedPhotoInfoList.fromMap(Map<String, dynamic> data) {
    return TbFeedPhotoInfoList(
      feedPhotoSeq: data['feedPhotoSeq'] as int?,
      feedSeq: data['feedSeq'] as int?,
      photoFormat: data['photoFormat'] as String?,
      photoPath: data['photoPath'] as String?,
      photoSavedFileName: data['photoSavedFileName'] as String?,
      photoOriginFileName: data['photoOriginFileName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'feedPhotoSeq': feedPhotoSeq,
        'feedSeq': feedSeq,
        'photoFormat': photoFormat,
        'photoPath': photoPath,
        'photoSavedFileName': photoSavedFileName,
        'photoOriginFileName': photoOriginFileName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TbFeedPhotoInfoList].
  factory TbFeedPhotoInfoList.fromJson(String data) {
    return TbFeedPhotoInfoList.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TbFeedPhotoInfoList] to a JSON string.
  String toJson() => json.encode(toMap());

  TbFeedPhotoInfoList copyWith({
    int? feedPhotoSeq,
    int? feedSeq,
    String? photoFormat,
    String? photoPath,
    String? photoSavedFileName,
    String? photoOriginFileName,
  }) {
    return TbFeedPhotoInfoList(
      feedPhotoSeq: feedPhotoSeq ?? this.feedPhotoSeq,
      feedSeq: feedSeq ?? this.feedSeq,
      photoFormat: photoFormat ?? this.photoFormat,
      photoPath: photoPath ?? this.photoPath,
      photoSavedFileName: photoSavedFileName ?? this.photoSavedFileName,
      photoOriginFileName: photoOriginFileName ?? this.photoOriginFileName,
    );
  }
}
