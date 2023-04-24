import 'package:app_monitoring_transaction/model/creadention_model.dart';
import 'package:app_monitoring_transaction/utils/constant/urls.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio();
  final Urls _urls = Urls();

  AuthApi() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          if (e.response!.statusCode == 401) {
          } else {}
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> ping({
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        '${_urls.baseUrl}/ping',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      bool result = response.data['status'];
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> login({
    required CredentionsModel credentions,
  }) async {
    try {
      final response = await _dio.post(
        '${_urls.auth}/login',
        data: credentions.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      String token = response.data['token'];
      return token;
    } catch (e) {
      rethrow;
    }
  }
}
