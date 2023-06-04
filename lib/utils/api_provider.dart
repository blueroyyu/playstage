import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:playstage/const.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';

const String smsAuth = '/member/smsAuth';
const String memberList = '/member/getMemberList';
const String likeMemberList = '/member/getLikeMemberList';
const String receiveLikeMemberList = '/member/getReceiveLikeMemberList';
const String memberInfoBySeq =
    '/member/getMemberBySeq/'; // /member/getMemberBySeq/{memberSeq}
const String memberInfoById =
    '/member/getMemberById/'; // /member/getMemberById/{memberId}
const String likeToggleMember = '/member/likeToggleMember';
const String hateAddMember = '/member/hateAddMember';
const String updateMember = '/member/updateMember';

const String blockInfoList = '/common/getBlockInfoList';

const String feedList = '/feed/getFeedList';
const String memberFeedList = '/feed/getFeedListByMemberSeq';
const String handleFeedLike = '/feed/handleFeedLike';
const String handleFeedComment = '/feed/handleFeedComment';
const String addFeed = '/feed/addFeed';

const String setBlockInfo = '/common/setBlockInfo';
const String sendInquiry = '/common/sendInquiry';

class ApiProvider {
  static final Dio _dio = Dio();
  static Dio get dio {
    _dio.options.baseUrl = baseUrl;
    return _dio;
  }

  static String _accessToken = '';
  static set accessToken(String value) {
    _accessToken = value;
    _dio.options.headers['Authorization'] = _accessToken;
  }

  static Future<dynamic> getData(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await dio.get(endpoint, queryParameters: queryParams);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> postData(
      String endpoint, Map<String, dynamic>? data) async {
    try {
      if (kDebugMode) {
        print(dio.options.headers);
      }
      Response response = await dio.post(endpoint, data: data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (kDebugMode) {
          print(response.data);
        }
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> deleteData(String endpoint) async {
    try {
      Response response = await dio.delete(endpoint);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  /*
  {
    "memberId": "string",
    "location": "string",
    "fromAge": 0,
    "toAge": 0,
    "distance": 0
  }
  */
  static Future<dynamic> requestMemberList(String memberId,
      {String location = '',
      int fromAge = 0,
      int toAge = 100,
      int distance = 9999,
      int pageNumber = 1,
      int pageSize = 0}) async {
    final data = {
      'memberId': memberId,
      'location': location,
      'fromAge': fromAge,
      'toAge': toAge,
      'distance': distance,
      'pageNumber': 1,
      'pageSize': 0,
    };

    try {
      return await postData(memberList, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestMemberBySeq(int memberSeq) async {
    try {
      return await postData('$memberInfoBySeq$memberSeq', null);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestMemberById(String memberId) async {
    try {
      return await postData('$memberInfoById$memberId', null);
    } catch (error) {
      rethrow;
    }
  }

  // 삭제는 removePhotoSeqList 이 이름으로 넘기시면되구요 30,34 이런식으로 삭제할 시퀀스를 넘기면되구요
  static Future<dynamic> requestUpdateMember(MemberInfoEntity member,
      {String removePhotoSeqList = ''}) async {
    final jsonData = jsonEncode({
      'memberId': member.memberId,
      'memberName': member.name(),
      'memberHeight': member.memberHeight.toString(),
      'memberIntro': member.memberIntro,
      'bodyInfo': member.bodyInfo,
      'language': member.language,
      'drinkInfo': member.drinkInfo,
      'smokingInfo': member.smokingInfo,
      'memberTendencyCd': member.memberTendencyCd,
      'searchTendencyCd1': member.searchTendencyCd1,
      'searchTendencyCd2': member.searchTendencyCd2,
      'searchTendencyCd3': member.searchTendencyCd3,
      'removePhotoSeqList': removePhotoSeqList,
    });

    final formData = FormData();
    formData.fields.add(MapEntry('updateMemberReqDto', jsonData));

    try {
      final response = await dio.post(
        updateMember,
        data: formData,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (kDebugMode) {
          print(response.data);
        }
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

/*
{
  "pageNumber": 0,
  "pageSize": 0,
  "memberId": "string",
  "fromAge": 0,
  "toAge": 0,
  "distance": 0
}
*/
  static Future<dynamic> requestLikeMemberList(String memberId,
      {int pageNumber = 1,
      int pageSize = 25,
      int fromAge = 19,
      int toAge = 120,
      double distance = 9999.0}) async {
    final data = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'memberId': memberId,
      'fromAge': fromAge,
      'toAge': toAge,
      'distance': distance,
    };

    try {
      return await postData(likeMemberList, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestReceiveLikeMemberList(String memberId,
      {int pageNumber = 1,
      int pageSize = 25,
      int fromAge = 19,
      int toAge = 120,
      double distance = 9999.0}) async {
    final data = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'memberId': memberId,
      'fromAge': fromAge,
      'toAge': toAge,
      'distance': distance,
    };

    try {
      return await postData(receiveLikeMemberList, data);
    } catch (error) {
      rethrow;
    }
  }

  /*
  {
    "memberId": "string",
    "targetMemberId": "string"
  }
   */
  static Future<dynamic> requestToggleMemberLike(
      String memberId, String targetId) async {
    final data = {
      'memberId': memberId,
      'targetMemberId': targetId,
    };

    try {
      return await postData(likeToggleMember, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestAddHateMember(
      String memberId, String targetId) async {
    final data = {
      'memberId': memberId,
      'targetId': targetId,
    };

    try {
      return await postData(hateAddMember, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestFeedList(
      int memberSeq, int pageNumber, int pageSize) async {
    final data = {
      'memberSeq': memberSeq,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    try {
      return await postData(feedList, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestMemberFeedList(
      int memberSeq, int pageNumber, int pageSize) async {
    final data = {
      'memberSeq': memberSeq,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    try {
      return await postData(memberFeedList, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestSmsAuth(String mobile) async {
    final data = {
      'authValue': mobile,
    };

    try {
      return await postData(smsAuth, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestAddFeed(
      String memberId, String content, List<String> images) async {
    final jsonData = jsonEncode({
      "memberId": memberId,
      "feedContent": content,
    });

    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = _accessToken;
      final formData = FormData();

      final files = images;
      for (final file in files) {
        if (file.isEmpty) {
          continue;
        }

        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file),
        ));
      }

      formData.fields.add(MapEntry('addFeedReqDto', jsonData));

      final response = await dio.post(
        '$baseUrl$addFeed',
        data: formData,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (kDebugMode) {
          print(response.data);
        }
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      rethrow;
    }
  }

  static Future<dynamic> requestHandleComment(
      String memberId, int feedSeq, String comment) async {
    final data = {
      'memberId': memberId,
      'feedSeq': feedSeq,
      'comment': comment,
    };

    try {
      return await postData(handleFeedComment, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestHandleFeedLike(
      String memberId, int feedSeq) async {
    final data = {
      'memberId': memberId,
      'feedSeq': feedSeq,
    };

    try {
      return await postData(handleFeedLike, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestGetBlockInfoList(String memberId) async {
    try {
      return await postData('$blockInfoList/$memberId', null);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestSendInquiry(
      String memberId, String content, List<String> images) async {
    final jsonData = jsonEncode({
      "memberId": memberId,
      "inquiry": content,
    });

    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = _accessToken;
      final formData = FormData();

      final files = images;
      for (final file in files) {
        if (file.isEmpty) {
          continue;
        }

        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file),
        ));
      }

      formData.fields.add(MapEntry('inquiryReqDto', jsonData));

      final response = await dio.post(
        '$baseUrl$sendInquiry',
        data: formData,
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (kDebugMode) {
          print(response.data);
        }
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      rethrow;
    }
  }
}
