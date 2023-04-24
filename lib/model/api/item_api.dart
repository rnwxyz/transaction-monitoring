import 'package:app_monitoring_transaction/model/item_model.dart';
import 'package:app_monitoring_transaction/utils/constant/urls.dart';
import 'package:dio/dio.dart';

class ItemApi {
  final Dio _dio = Dio();
  final Urls _urls = Urls();

  ItemApi() {
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

  Future<List<ItemModel>> getItem({
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        '${_urls.baseUrl}/bahan',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      return List<ItemModel>.from(
        response.data["data"].map(
          (e) => ItemModel.fromJson(e),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
