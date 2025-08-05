import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspiro/core/network/remote/api_endpoints.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    if (dio != null) {
      return;
    }

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );
  }

  static Dio getDio() {
    if (dio != null) {
      return dio!;
    }
    init();
    return dio!;
  }

  static Future<Either<String, Response>> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    try {
      final Response response = await getDio().get(
        url,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Api-Key': accessKey,
          },
        ),
      );
      return Right(response);
    } on DioException catch (error) {
      return Left(
        error.response?.data['errors']?.first ?? 'Something went wrong',
      );
    } catch (e) {
      debugPrint('DioHelper.get error: $e');
      return const Left('something went wrong, please try again later');
    }
  }
}
