import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:playstage/const.dart';

const String signUp = '/signup';
const String logIn = '/login';
const String logOut = '/logout';
const String issueCard = '/issue-card';
const String chargeCard = '/charge-card';
const String refundCard = '/refund-dard';
const String payCard = '/pay-card';
const String inquireBalance = '/inquire-balance';
const String inquireTran = '/inquire-tran';
const String cancelCard = '/cancel-card';
const String cancelMembership = '/cancel-membership';
const String changePassword = '/change-password';

const String memberList = '/member/getMemberList';
const String likeMemberList = '/member/getLikeMemberList';
const String receiveLikeMemberList = '/member/getReceiveLikeMemberList';
const String memberInfo = '/member/getMember/'; // /member/getMember/{memberSeq}
const String likeToggleMember = '/member/likeToggleMember';
const String hateAddMember = '/member/hateAddMember';
const String updateMember = '/member/updateMember';

const String feedList = '/feed/getFeedList/'; // /feed/getFeedList/{memberSeq}
const String memberFeedList =
    '/feed/getFeedListByMemberSeq/'; // /feed/getFeedListByMemberSeq/{memberSeq}
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
    _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
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
      int toAge = 0,
      double distance = 0.0}) async {
    final data = {
      'memberId': memberId,
      'location': location,
      'fromAge': fromAge,
      'toAge': toAge,
      'distance': distance,
    };

    try {
      return await postData(memberList, data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestMember(int memberSeq) async {
    try {
      return await postData('$memberInfo$memberSeq', null);
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestLikeMemberList(String memberId,
      {String location = '',
      int fromAge = 0,
      int toAge = 0,
      double distance = 0.0}) async {
    final data = {
      'memberId': memberId,
      'location': location,
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
      {String location = '',
      int fromAge = 0,
      int toAge = 0,
      double distance = 0.0}) async {
    final data = {
      'memberId': memberId,
      'location': location,
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
      'targetId': targetId,
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

  static Future<dynamic> requestFeedList(int memberSeq) async {
    try {
      return await getData('$feedList$memberSeq');
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> requestMemberFeedList(int memberSeq) async {
    try {
      return await getData('$memberFeedList$memberSeq');
    } catch (error) {
      rethrow;
    }
  }
}
