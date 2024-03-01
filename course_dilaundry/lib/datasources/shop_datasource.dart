import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../config/app_constants.dart';
import '../config/app_request.dart';
import '../config/app_response.dart';
import '../config/app_session.dart';
import '../config/failure.dart';

class ShopDatasource {
  static Future<Either<Failure, Map>> readRecommendationLimit() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop/recommendation/limit');
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

  static Future<Either<Failure, Map>> getAll() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop');
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

  static Future<Either<Failure, Map>> searchByCity(String name) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop/search/city/$name');
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

  static Future<Either<Failure, Map>> delete(int id) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop/$id');
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

  static Future<Either<Failure, Map>> create(
      String name,
      String location,
      String city,
      int whatsapp,
      String category,
      String description,
      double priceCuciKomplit,
      double priceDryClean,
      double priceCuciSatuan) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop');
    final token = await AppSession.getBearerToken();

    Map<String, dynamic> payload = {
      "name": name,
      "location": location,
      "city": city,
      "whatsapp": whatsapp,
      "category": category,
      "price_cuci_komplit": priceCuciKomplit,
      "description": description,
      "price_dry_clean": priceDryClean,
      "price_cuci_satuan": priceCuciSatuan
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
}
