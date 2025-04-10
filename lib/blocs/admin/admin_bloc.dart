import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final Dio _dio = Dio();

  AdminBloc() : super(AdminInitial());

  @override
  Stream<AdminState> mapEventToState(AdminEvent event) async* {
    if (event is AddOrganizationEvent) {
      yield AdminLoading();
      try {
        final response = await _dio.post(
          "https://api.example.com/addOrg",
          options: Options(headers: {"Content-Type": "application/json"}),
          data: jsonEncode(event.toJson()),
        );
        if (response.statusCode == 200) {
          yield AdminSuccess("Organization added successfully");
        } else {
          yield AdminFailure("Failed to add organization");
        }
      } catch (e) {
        yield AdminFailure(e.toString());
      }
    }
  }
}