import 'dart:convert';

class TbFeedLikeMemberInfoList {
  int? memberSeq;

  TbFeedLikeMemberInfoList({this.memberSeq});

  @override
  String toString() => 'TbFeedLikeMemberInfoList(memberSeq: $memberSeq)';

  factory TbFeedLikeMemberInfoList.fromMap(Map<String, dynamic> data) {
    return TbFeedLikeMemberInfoList(
      memberSeq: data['memberSeq'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'memberSeq': memberSeq,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TbFeedLikeMemberInfoList].
  factory TbFeedLikeMemberInfoList.fromJson(String data) {
    return TbFeedLikeMemberInfoList.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TbFeedLikeMemberInfoList] to a JSON string.
  String toJson() => json.encode(toMap());

  TbFeedLikeMemberInfoList copyWith({
    int? memberSeq,
  }) {
    return TbFeedLikeMemberInfoList(
      memberSeq: memberSeq ?? this.memberSeq,
    );
  }
}
