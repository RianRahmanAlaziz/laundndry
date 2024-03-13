import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../config/app_constants.dart';
import '../config/app_request.dart';
import '../config/app_response.dart';
import '../config/failure.dart';
import '../config/app_session.dart';

class UserDatasource {
  static Future<Either<Failure, Map>> getAll() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/users');
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> login(
    String email,
    String password,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/login');
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'email': email,
          'password': password,
        },
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> register(
    String username,
    String email,
    String password,
    String address,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/register');
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'username': username,
          'email': email,
          'password': password,
          'address': address
        },
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> create(String username, String email,
      String password, String address, String role) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/users');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'username': username,
          'email': email,
          'password': password,
          'address': address,
          'role': role
        },
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> update(int id, String username,
      String email, String password, String address, String role) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/users/$id');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'username': username,
          'email': email,
          'password': password,
          'address': address,
          'role': role
        },
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> delete(int id) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/users/$id');
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.delete(
        url,
        headers: AppRequest.header(token),
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> Uaccount(
    String username,
    String email,
    String password,
    String address,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/user/edit');
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'username': username,
          'email': email,
          'password': password,
          'address': address,
        },
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }
}
