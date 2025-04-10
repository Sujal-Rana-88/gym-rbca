import 'package:dio/dio.dart';

class APIConstants {
  static const String statusCode = "statusCode";
  static const String statusMessage = "message";
  static const String validationFailures = "validationFailures";
  static const String resetToken = "resetToken";
  static const String typeHeader="type";
  static const String tokenHeader="token";

  static const int initialDelayForAccessToken = 1000;

  static const int apiInternetErrorCode = 1000;

  static const int ApiRefreshToken = 401;

  static const int ApiCodeMutipleDevice = 409;

  static const int apiBadRequestError = 400;

  static const int apiRefreshTokenAlreadyInitiate = 1001;

  static Options contentTypeApplicationJsonOptions =
  Options(headers: {"Content-Type": "application/json"});

  static Options deviceTokenWithLoginTypeOptions(
      {required String deviceToken, required String loginType}) {
    return Options(
        headers: {"token": deviceToken, "type": loginType}
    );
  }



  static Options authorizationHeaderoptions(
      {required String token}) {
    return Options(
        headers: {"Content-Type": "application/json",
          "Authorization":'Bearer $token'
        }
    );
  }

  static Options homeAuthorizationHeaderoptions(
      {required String token,required String language,required int page,
        required int limit}) {
    return Options(
        headers: {"Content-Type": "application/json",
          "Authorization":'Bearer $token',
          "Accept-Language":language,
          "page":page,
          "limit":limit
        }
    );
  }

  static Options loginTypeoptions(
      {required String loginType}) {
    return Options(
        headers: { "type": loginType}
    );
  }
}
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        headers: {"Content-Type": "application/json"},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<Response> post(String url, {Map<String, dynamic>? data, Options? options}) async {
    return await _dio.post(url, data: data, options: options);
  }
}
