import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tj_analysis/tools/crypto.dart';
import 'dart:convert';

var dio = Dio(BaseOptions(
  baseUrl: "http://127.0.0.1:8888",
  connectTimeout: 5000,
  receiveTimeout: 100000,
  // 5s
  headers: {
    HttpHeaders.userAgentHeader: "tj_app_analysis",
    "api": "1.0.0",
  },
  contentType: ContentType.json,
  responseType: ResponseType.plain,
));

class TjHttp {
  static Future<Response> get(String path,
      {Map<String, dynamic> data, Map<String, dynamic> headers}) async {
    var _headers = await generateHeaders(headers);
    Response response;
    _addInterceptor();
    response = await dio.get(
      path,
      queryParameters: data,
      options: Options(headers: _headers, responseType: ResponseType.json),
    );

    return handleResponse(response);
  }

  static Future<Response> post(String path,
      {Map<String, dynamic> data, Map<String, dynamic> headers}) async {
    var _headers = await generateHeaders(headers);
    Response response;
    _addInterceptor();
    response = await dio.post(
      path,
      data: data,
      queryParameters: data,
      options: Options(
        headers: _headers,
        contentType: ContentType.parse('application/json'),
      ),
    );
    return handleResponse(response);
  }

  static Future<Response> delete(String path,
      {Map<String, dynamic> data, Map<String, dynamic> headers}) async {
    var _headers = await generateHeaders(headers);
    Response response;
    _addInterceptor();
    response = await dio.delete(
      path,
      data: data,
      options: Options(
        headers: _headers,
        contentType: ContentType.parse('application/json'),
      ),
    );

    return handleResponse(response);
  }

  static Future<Response> handleResponse(Response response) async {
    int statusCode = response.statusCode;
    if (statusCode == 401) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("token", null);
    }

    if (response.data != null) {
      if (response.data is String) {
        Map data = json.decode(response.data);
        if (data['data'] != null) {
          String dataMap = AesCrypto.decrypted(data["data"].toString());
          final map = json.decode(dataMap);
          data["data"] = map;
        }
        response.data = data;
      } else if (response.data is Map) {
        if (response.data['data'] != null) {
          String dataMap =
              AesCrypto.decrypted(response.data["data"].toString());
          final map = json.decode(dataMap);
          response.data["data"] = map;
        }
      }
    }

    return response;
  }

  static Future<Map<String, dynamic>> generateHeaders(
      Map<String, dynamic> headers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt("token");
    if (headers == null) {
      headers = {};
    }
    if (uid != null) {
      String sessionId = prefs.getString('session_id');
      //headers['session_id'] = sessionId;
      headers['user_id'] = uid;
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      headers['timestamp'] = timestamp;
      String token = MD5Crypto.generate(sessionId + '&' + timestamp);
      headers['token'] = token;
    }
    return headers;
  }

  static void _addInterceptor() {
    _lockAll();
    dio.interceptors.clear(); // 此处一定要先清空，不然会累加。
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (req) {},
        onResponse: (resp) {},
        onError: (err) {
          // XsProgressHud.hide();
          _handleUnauthError(err);
          // print("interceptors - onError: $err");
        },
      ),
    );
    _unlockAll();
  }

  static _handleUnauthError(dynamic error) async {
    if (error != null && error is DioError) {
      // 如果后端直接返回 401，在这里处理。
      if (error?.response?.statusCode == 401) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("token", null);
      }
    }
    if (error != null && error is Response) {}

    return; // 跳出错误处理。
  }

  static _lockAll() {
    dio.lock();
    dio.interceptors.responseLock.lock();
    dio.interceptors.errorLock.lock();
  }

  static _unlockAll() {
    dio.unlock();
    dio.interceptors.responseLock.unlock();
    dio.interceptors.errorLock.unlock();
  }
}

class TokenInterceptor extends Interceptor {
  @override
  onError(DioError error) async {
    if (error.response != null && error.response.statusCode == 401) {
      //401代表token过期
    }
    super.onError(error);
  }

  Future<String> getToken() async {
    try {} on DioError catch (e) {
      if (e.response.statusCode == 401) {
        //401代表refresh_token过期

      }
    }
    return "";
  }
}
