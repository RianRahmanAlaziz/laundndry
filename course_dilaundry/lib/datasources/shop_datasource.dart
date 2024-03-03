import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
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
      PlatformFile? image,
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

    // Map<String, dynamic> payload = {
    //   "name": name,
    //   "location": location,
    //   "city": city,
    //   "whatsapp": whatsapp,
    //   "category": category,
    //   "price_cuci_komplit": priceCuciKomplit,
    //   "description": description,
    //   "price_dry_clean": priceDryClean,
    //   "price_cuci_satuan": priceCuciSatuan
    // };

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    final req = http.MultipartRequest('POST', url)..headers.addAll(headers);

    req.fields["name"] = name;
    req.fields["location"] = location;
    req.fields["city"] = city;
    req.fields["whatsapp"] = whatsapp.toString();
    req.fields["category"] = category;
    req.fields["price_cuci_komplit"] = priceCuciKomplit.toString();
    req.fields["description"] = description;
    req.fields["price_dry_clean"] = priceDryClean.toString();
    req.fields["price_cuci_satuan"] = priceCuciSatuan.toString();

    if (image != null) {
      req.files.add(http.MultipartFile("image", image!.readStream!, image.size,
          filename: image.name));
    }
    final response = await req.send();

    if (response.statusCode == 200) {
      return Right(response.headers);
    } else {
      return Left(FetchFailure('err'));
    }
  }

  static Future<Either<Failure, Map>> update(
      int id,
      PlatformFile? image,
      String name,
      String location,
      String city,
      int whatsapp,
      String category,
      String description,
      double priceCuciKomplit,
      double priceDryClean,
      double priceCuciSatuan) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/shop/$id');
    final token = await AppSession.getBearerToken();

    // Map<String, dynamic> payload = {
    //   "name": name,
    //   "location": location,
    //   "city": city,
    //   "whatsapp": whatsapp,
    //   "category": category,
    //   "price_cuci_komplit": priceCuciKomplit,
    //   "description": description,
    //   "price_dry_clean": priceDryClean,
    //   "price_cuci_satuan": priceCuciSatuan
    // };

    // print(payload);

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    final req = http.MultipartRequest('POST', url)..headers.addAll(headers);

    req.fields["name"] = name;
    req.fields["location"] = location;
    req.fields["city"] = city;
    req.fields["whatsapp"] = whatsapp.toString();
    req.fields["category"] = category;
    req.fields["price_cuci_komplit"] = priceCuciKomplit.toString();
    req.fields["description"] = description;
    req.fields["price_dry_clean"] = priceDryClean.toString();
    req.fields["price_cuci_satuan"] = priceCuciSatuan.toString();

    if (image != null) {
      req.files.add(http.MultipartFile("image", image!.readStream!, image.size,
          filename: image.name));
    }

    final response = await req.send();

    var jsonResp = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Right(jsonDecode(jsonResp));
    } else {
      return Left(FetchFailure('err'));
    }
  }
}
