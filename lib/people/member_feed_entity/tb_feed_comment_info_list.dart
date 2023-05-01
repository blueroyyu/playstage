import 'dart:convert';

class TbFeedCommentInfoList {
  int? commentSeq;
  int? feedSeq;
  int? memberSeq;
  String? comment;
  String? memberName;
  String? memberPhotoPath;
  String? memberPhotoSavedFileName;
  DateTime? createDt;

  TbFeedCommentInfoList({
    this.commentSeq,
    this.feedSeq,
    this.memberSeq,
    this.comment,
    this.memberName,
    this.memberPhotoPath,
    this.memberPhotoSavedFileName,
    this.createDt,
  });

  @override
  String toString() {
    return 'TbFeedCommentInfoList(commentSeq: $commentSeq, feedSeq: $feedSeq, memberSeq: $memberSeq, comment: $comment, memberName: $memberName, memberPhotoPath: $memberPhotoPath, memberPhotoSavedFileName: $memberPhotoSavedFileName, createDt: $createDt)';
  }

  factory TbFeedCommentInfoList.fromMap(Map<String, dynamic> data) {
    return TbFeedCommentInfoList(
      commentSeq: data['commentSeq'] as int?,
      feedSeq: data['feedSeq'] as int?,
      memberSeq: data['memberSeq'] as int?,
      comment: data['comment'] as String?,
      memberName: data['memberName'] as String?,
      memberPhotoPath: data['memberPhotoPath'] as String?,
      memberPhotoSavedFileName: data['memberPhotoSavedFileName'] as String?,
      createDt: data['createDt'] == null
          ? null
          : DateTime.parse(data['createDt'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'commentSeq': commentSeq,
        'feedSeq': feedSeq,
        'memberSeq': memberSeq,
        'comment': comment,
        'memberName': memberName,
        'memberPhotoPath': memberPhotoPath,
        'memberPhotoSavedFileName': memberPhotoSavedFileName,
        'createDt': createDt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TbFeedCommentInfoList].
  factory TbFeedCommentInfoList.fromJson(String data) {
    return TbFeedCommentInfoList.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TbFeedCommentInfoList] to a JSON string.
  String toJson() => json.encode(toMap());

  TbFeedCommentInfoList copyWith({
    int? commentSeq,
    int? feedSeq,
    int? memberSeq,
    String? comment,
    String? memberName,
    String? memberPhotoPath,
    String? memberPhotoSavedFileName,
    DateTime? createDt,
  }) {
    return TbFeedCommentInfoList(
      commentSeq: commentSeq ?? this.commentSeq,
      feedSeq: feedSeq ?? this.feedSeq,
      memberSeq: memberSeq ?? this.memberSeq,
      comment: comment ?? this.comment,
      memberName: memberName ?? this.memberName,
      memberPhotoPath: memberPhotoPath ?? this.memberPhotoPath,
      memberPhotoSavedFileName:
          memberPhotoSavedFileName ?? this.memberPhotoSavedFileName,
      createDt: createDt ?? this.createDt,
    );
  }
}
