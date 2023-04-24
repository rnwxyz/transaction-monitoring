import 'package:app_monitoring_transaction/model/api/mutasi_api.dart';
import 'package:app_monitoring_transaction/model/mutasi_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mutasi_detail_event.dart';
part 'mutasi_detail_state.dart';

class MutasiDetailBloc extends Bloc<MutasiDetailEvent, MutasiDetailState> {
  MutasiDetailBloc() : super(MutasiDetailInitial()) {
    late SharedPreferences loginData;
    final mutasiApi = MutasiApi();
    on<MutasiDetailGetEvent>((event, emit) async {
      try {
        emit(MutasiDetailLoading());
        loginData = await SharedPreferences.getInstance();
        final token = loginData.getString('token') ?? '';
        final MutasiModel mutasi = await mutasiApi.getMutasiDetail(
          token: token,
          id: event.id,
        );
        emit(MutasiDetailLoaded(data: mutasi));
      } catch (e) {
        emit(
          MutasiDetailError(message: e.toString()),
        );
      }
    });
  }
}
