import 'package:app_monitoring_transaction/model/api/mutasi_api.dart';
import 'package:app_monitoring_transaction/model/resume_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'resume_event.dart';
part 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  ResumeBloc() : super(ResumeInitial()) {
    late SharedPreferences loginData;
    final mutasiApi = MutasiApi();

    on<ResumeGetEvent>(
      (event, emit) async {
        try {
          emit(ResumeLoading());
          loginData = await SharedPreferences.getInstance();
          final token = loginData.getString('token') ?? '';
          final List<ResumeModel> data = await mutasiApi.getResume(
            token: token,
            tahun: event.tahun,
          );
          emit(ResumeLoaded(data: data));
        } catch (e) {
          emit(
            ResumeError(message: e.toString()),
          );
        }
      },
    );
  }
}
