import 'package:app_monitoring_transaction/model/api/mutasi_api.dart';
import 'package:app_monitoring_transaction/model/mutasi_model.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mutasi_event.dart';
part 'mutasi_state.dart';

class MutasiBloc extends Bloc<MutasiEvent, MutasiState> {
  MutasiBloc() : super(MutasiInitial()) {
    int currentPage = 1;
    const int perPage = 10;
    FilterMutasiModel? filter;
    late SharedPreferences loginData;
    final mutasiApi = MutasiApi();
    List<MutasiModel> dataMutasi = [];

    on<MutasiGetEvent>(
      (event, emit) async {
        try {
          loginData = await SharedPreferences.getInstance();
          final token = loginData.getString('token') ?? '';
          if (event.loadMore) {
            emit(MutasiLoading());
            currentPage++;
          } else {
            emit(MutasiInitial());
            currentPage = 1;
            dataMutasi = [];
          }
          final List<MutasiModel> mutasi = await mutasiApi.getMutasi(
            token: token,
            page: currentPage,
            perPage: perPage,
            q: event.q,
            filter: event.filter,
          );
          dataMutasi = [...dataMutasi, ...mutasi];
          emit(MutasiLoadeMore(mutasi: dataMutasi));
        } catch (e) {
          emit(
            MutasiError(message: e.toString()),
          );
        }
      },
    );
  }
}
