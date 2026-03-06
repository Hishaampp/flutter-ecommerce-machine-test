import 'package:dio/dio.dart';
import '../utils/constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Map<String, dynamic>> login({
    required String emailPhone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email_phone': emailPhone,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getHome({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '/home/${AppConstants.language}',
        queryParameters: {
          'id': userId,
          'token': token,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProducts({
    required String userId,
    required String token,
    String by = 'category',
    String? value,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'id': userId,
        'token': token,
        'by': by,
        'page': page,
        if (value != null) 'value': value,
      };

      final response = await _dio.post(
        '/products/${AppConstants.language}',
        queryParameters: queryParams,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please try again.';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection.';
    }

    if (e.response?.data is Map) {
      return (e.response?.data['message'] ?? 'Something went wrong').toString();
    }

    return 'Unexpected error occurred.';
  }
}