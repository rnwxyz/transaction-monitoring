import 'package:app_monitoring_transaction/model/mutasi_model.dart';
import 'package:app_monitoring_transaction/model/resume_model.dart';
import 'package:app_monitoring_transaction/utils/constant/urls.dart';
import 'package:dio/dio.dart';

class MutasiApi {
  final Dio _dio = Dio();
  final Urls _urls = Urls();

  MutasiApi() {
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

  Future<List<MutasiModel>> getMutasi({
    required String token,
    required int page,
    required int perPage,
    required String q,
    FilterMutasiModel? filter,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
        "per_page": perPage,
        "q": q,
      };
      if (filter != null) {
        if (filter.tanggalAwal != "") {
          queryParameters["tanggal_mutasi_mulai"] = filter.tanggalAwal;
        }
        if (filter.tanggalSelesai != "") {
          queryParameters["tanggal_mutasi_selesai"] = filter.tanggalSelesai;
        }
        if (filter.idGudang != "") {
          queryParameters["id_gudang"] = filter.idGudang;
        }
        if (filter.idItem != "") {
          queryParameters["id_barang"] = filter.idItem;
        }
      }

      final response = await _dio.get(
        '${_urls.baseUrl}/mutasi',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        queryParameters: queryParameters,
      );

      final data = List<MutasiModel>.from(response.data["data"].map(
        (e) => MutasiModel.fromJson(e),
      ));
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<MutasiModel> getMutasiDetail({
    required String token,
    required int id,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {"id_mutasi_barang": id};

      final response = await _dio.get(
        '${_urls.baseUrl}/mutasi_single',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        queryParameters: queryParameters,
      );

      final data = MutasiModel.fromJson(response.data["data"]);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ResumeModel>> getResume({
    required String token,
    required int tahun,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {"tahun": tahun};

      final response = await _dio.get(
        '${_urls.baseUrl}/resume_mutasi',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        queryParameters: queryParameters,
      );
      final data = List<ResumeModel>.from(response.data["data"].map(
        (e) => ResumeModel.fromJson(e),
      ));
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
