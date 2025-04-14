import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../constants/api_constants.dart';
import '../../constants/app_constants.dart';
import '../../constants/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService = ApiService();

  AuthBloc() : super(AuthInitial()){
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await apiService.post(
          "${APPConstants.BASE_URL}${URLConstants.login}",
          data: {
            "userEmail": event.email,
            "password": event.password,
          },
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> decodedToken = {};
          try {
            decodedToken = JwtDecoder.decode(response.data['data']);
          } catch (e) {
            emit(AuthError("Invalid token format."));
            return;
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', response.data['data']);
          await prefs.setString('role', decodedToken['authorities'] ?? "");
          await prefs.setString('exp', decodedToken['exp'].toString());
          emit(Authenticated(email: event.email));
        } else {
          emit(AuthError("Login failed. Please try again."));
        }
      } catch (exception){
        String errorMessage = "An unknown error occurred.";
        if (exception is DioException) {
          if (exception.response != null &&
              exception.response?.data != null &&
              exception.response?.data['message'] != null) {
            errorMessage = exception.response?.data['message'];
          } else {
            errorMessage = exception.message ?? errorMessage;
          }
        } else {
          errorMessage = exception.toString();
        }

        emit(AuthError(errorMessage));
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthInitial());
    });
  }
}
