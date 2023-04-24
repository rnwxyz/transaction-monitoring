import 'package:app_monitoring_transaction/model/gudang_model.dart';
import 'package:app_monitoring_transaction/utils/constant/urls.dart';
import 'package:dio/dio.dart';

class GudangApi {
  final Dio _dio = Dio();
  final Urls _urls = Urls();

  GudangApi() {
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

  Future<List<GudangModel>> getGudang({
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        '${_urls.baseUrl}/gudang',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      return List<GudangModel>.from(
        response.data["data"].map(
          (e) => GudangModel.fromJson(e),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
