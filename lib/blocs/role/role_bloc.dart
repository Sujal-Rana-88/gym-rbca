import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../constants/url_constants.dart';

part 'role_event.dart';
part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {

  final Dio dio = Dio();

  RoleBloc() : super(RoleInitial()){
    on<AddRoleRequested>((event, emit) async {
      emit(RoleLoading());
      try {
        String organizationId = "ZhYxgOB_BEnaCYjEwtAl8Q";

        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('access_token');
        print("token is $token");
        if (token == null){
          emit(RoleError("User is not authenticated."));
          return;
        }

        final response = await dio.post(
          "${APPConstants.BASE_URL}${URLConstants.add_role}?organizationId=${organizationId}&role=${event.role}",
          data: {
            "firstName": event.firstName,
            "lastName": event.lastName,
            "userMobileNumber": event.userMobileNumber,
            "address": event.address,
            "userCountryCode": event.userCountryCode,
            "role": event.role,
            "email": event.email,
            "password": "123456",
          },
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        // print("Response status code: ${response.statusCode}");
        // print("Response data: ${response.data}");

        if (response.statusCode == 201) {
          emit(RoleCreated(message: "Role Created Successfully"));
        } else {
          emit(RoleError("Failed to create role. Please try again."));
        }
      } catch (exception) {
        // print('Error occurred: $exception');
        emit(RoleError("An error occurred. Please try again."));
      }
    });
  }
}
