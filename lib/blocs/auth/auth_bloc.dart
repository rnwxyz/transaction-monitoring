import 'package:app_monitoring_transaction/model/api/auth_api.dart';
import 'package:app_monitoring_transaction/model/creadention_model.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    final AuthApi authApi = AuthApi();
    late SharedPreferences loginData;

    on<Logout>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          loginData = await SharedPreferences.getInstance();
          loginData.remove('token');
          emit(AuthInitial());
        } catch (e) {
          emit(
            AuthError(e.toString()),
          );
        }
      },
    );

    on<CheckLogin>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          loginData = await SharedPreferences.getInstance();
          final token = loginData.getString('token') ?? '';
          if (token.isEmpty) {
            emit(AuthLogout());
          } else {
            emit(AuthSuccess());
          }
        } catch (e) {
          emit(
            AuthError(e.toString()),
          );
        }
      },
    );

    on<Login>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final credentions = event.credentions;
          final String token = await authApi.login(credentions: credentions);
          final bool result = await authApi.ping(token: token);
          if (result) {
            loginData = await SharedPreferences.getInstance();
            loginData.setString('token', token);
            emit(AuthSuccess());
          } else {
            emit(AuthInitial());
          }
        } catch (e) {
          emit(
            AuthError(e.toString()),
          );
        }
      },
    );
  }
}
