import 'dart:convert';

import 'package:course_dilaundry/models/laundry_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../config/app_constants.dart';
import '../config/app_request.dart';
import '../config/app_response.dart';
import '../config/app_session.dart';
import '../config/failure.dart';
import '../models/user_model.dart';

class LaundryDatasource {
  static Future<Either<Failure, Map>> readAll() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/laundry');
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

  static Future<Either<Failure, Map>> readByUser(int userId) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/laundry/user/$userId');
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

  static Future<Either<Failure, Map>> claim(String id, String claimCode) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/laundry/claim');
    UserModel? user = await AppSession.getUser();
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'id': id,
          'claim_code': claimCode,
          'user_id': user!.id.toString(),
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

  static Future<Either<Failure, Map>> create(
      int userID,
      int shopId,
      double weight,
      double price,
      String pickupAddress,
      String deliveryAddress,
      String description) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/laundry');
    final token = await AppSession.getBearerToken();

    Map<String, dynamic> payload = {
      "user_id": userID,
      "shop_id": shopId,
      "weight": weight,
      "pickup_address": pickupAddress,
      "delivery_address": deliveryAddress,
      "total": price,
      "description": description
    };

    try {
      final response = await http.post(url,
          headers: AppRequestJson.header(token), body: jsonEncode(payload));
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> updateStatus(
      int id, String status) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/laundry/$id/$status');
    final token = await AppSession.getBearerToken();

    try {
      final response =
          await http.get(url, headers: AppRequestJson.header(token));
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
