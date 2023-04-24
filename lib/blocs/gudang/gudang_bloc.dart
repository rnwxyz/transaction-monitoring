import 'package:app_monitoring_transaction/model/api/gudang_api.dart';
import 'package:app_monitoring_transaction/model/gudang_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'gudang_event.dart';
part 'gudang_state.dart';

class GudangBloc extends Bloc<GudangEvent, GudangState> {
  final GudangApi gudangApi = GudangApi();
  late SharedPreferences loginData;

  GudangBloc() : super(GudangInitial()) {
    on<GudangGetEvent>(
      (event, emit) async {
        try {
          loginData = await SharedPreferences.getInstance();
          final token = loginData.getString('token') ?? '';
          final List<GudangModel> gudang = await gudangApi.getGudang(
            token: token,
          );
          emit(GudangLoaded(gudang: gudang));
        } catch (e) {
          emit(
            GudangError(message: e.toString()),
          );
        }
      },
    );
  }
}
