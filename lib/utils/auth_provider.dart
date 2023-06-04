import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String iamPortUrl = 'https://api.iamport.kr';
const String impKey = '5734764013884831';
const String impSecret =
    'bzFPQEh3z63ZYt6364tgG6lF8zn5ylwJ1Sx7SJvUaFM6F9p0SF4AT3bydEKFppVahecf9aqKyWN11Gh8';

const String getToken = '/users/getToken';
const String certifications = '/certifications';

class AuthProvider {
  static final Dio _dio = Dio();
  static Dio get dio {
    _dio.options.baseUrl = iamPortUrl;
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
        dynamic resData = response.data['response'];
        return resData;
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

        dynamic resData = response.data['response'];
        return resData;
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
    "code": 0,
    "message": null,
    "response": {
        "access_token": "cbaa8919652402ce50d9183334f81ad02b413818",
        "now": 1685789743,
        "expired_at": 1685791543
    }
  }
  */
  static Future<dynamic> requestGetToken() async {
    final data = {'imp_key': impKey, 'imp_secret': impSecret};

    try {
      return await postData(getToken, data);
    } catch (error) {
      rethrow;
    }
  }

/*
{
    "code": 0,
    "message": null,
    "response": {
        "birth": 216140400,
        "birthday": "1976-11-07",
        "certified": true,
        "certified_at": 1685719311,
        "foreigner": false,
        "foreigner_v2": null,
        "gender": "male",
        "imp_uid": "imp_045262694732",
        "merchant_uid": "mid_1685719260995",
        "name": "유승민",
        "origin": "data:text/html,%20%20%20%20%3Chtml%3E%0A%20%20%20%20%20%20%3Chead%3E%0A%20%20%20%20%20%20%20%20%3Cmeta%20http-equiv=%22content-type%22%20content=%22text/html;%20charset=utf-8%22%3E%0A%20%20%20%20%20%20%20%20%3Cmeta%20name=%22viewport%22%20content=%22width=device-width,%20initial-scale=1.0,%20user-scalable=no%22%3E%0A%0A%20%20%20%20%20%20%20%20%3Cscript%20type=%22text/javascript%22%20src=%22https://cdn.iamport.kr/v1/iamport.js%22%3E%3C/script%3E%0A%20%20%20%20%20%20%3C/head%3E%0A%20%20%20%20%20%20%3Cbody%3E%3C/body%3E%0A%20%20%20%20%3C/html%3E%0A%20%20",
        "pg_provider": "danal",
        "pg_tid": "202306030021027306905010",
        "unique_in_site": "MC0GCCqGSIb3DQIJAyEA/AzAjgcGfSPoSTpVn+aihq1eaa8zx/EN2XBQZq7iVrs=",
        "unique_key": "ZDo+VKGzg9rUhqX8x4i1eyoUn2HMuW9KIcz7cqBsTvg4mefGRfjK616QN1dscS7VcNesLCieTYwOC5VVexYGgA=="
    }
}
*/
  static Future<dynamic> requestCertifications(String impUid) async {
    try {
      return await getData('$certifications/$impUid');
    } catch (error) {
      rethrow;
    }
  }
}
