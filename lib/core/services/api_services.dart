import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import '../../config/api_paths.dart';
import 'header_provider.dart';
import 'package:retry/retry.dart';

import '../../main.dart';

class RestApiService {
  static Future<Map<String, String>> get getHeaders async {
    final headersProvider = Get.find<HeadersProvider>();
    return await headersProvider.getHeaders();
  }

  static http.Response _normalizeResponse(http.Response response) {
    try {
      final contentType = response.headers['content-type'] ?? '';
      final body = response.body;
      final trimmed = body.trimLeft();

      final isHtml =
          contentType.contains('text/html') ||
          trimmed.startsWith('<!DOCTYPE html') ||
          trimmed.startsWith('<html') ||
          trimmed.startsWith('<');

      if (isHtml) {
        final safeBody = jsonEncode({
          'error': 'server_error',
          'message': 'Server returned HTML instead of JSON',
          'status': 500,
        });
        return http.Response(
          safeBody,
          500,
          headers: response.headers,
          request: response.request,
          reasonPhrase: response.reasonPhrase,
        );
      }

      // If body is not valid JSON but content-type claims JSON, still pass through.
      return response;
    } catch (_) {
      return response;
    }
  }

  static void _logRequest({
    required String method,

    required Uri url,

    required Map<String, String> headers,
    required Map<String, dynamic> queryParams,

    dynamic body,

    required http.Response? response,
  }) {
    final stack = StackTrace.current.toString().split('\n');

    dynamic responseBodyForLog;
    if (response == null) {
      responseBodyForLog = null;
    } else {
      final raw = response.body;
      try {
        responseBodyForLog = jsonDecode(raw);
      } catch (_) {
        responseBodyForLog = raw; // log as plain text if not JSON
      }
    }

    logger.i('''New Http Request 
    Stack: $stack
    $method Request =>
    URL: $url
    Headers: ${jsonEncode(headers)}
    queryParams: ${jsonEncode(queryParams)}
    Body: ${jsonEncode(body)}
    Response Code: ${response?.statusCode}
    Response Body: $responseBodyForLog
      ''');
  }

  static Future<http.Response> get(
    String path, [
    Map<String, dynamic> queryParams = const {},
    Map<String, String>? headersParams,
  ]) async {
    final url = Uri.parse(
      '${ApiPaths.baseUrl}$path',
    ).replace(queryParameters: queryParams);
    final headers = headersParams ?? await getHeaders;

    final rawResponse = await retry(
      () =>
          http.get(url, headers: headers).timeout(const Duration(seconds: 60)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
      maxAttempts: 4,
    );
    final response = _normalizeResponse(rawResponse);
    _logRequest(
      queryParams: queryParams,
      method: "Get",
      url: url,
      headers: headers,
      body: [],
      response: response,
    );

    return response;
  }

  static Future<http.Response> post(
    String path, [
    Object? requestBody,
    Map<String, dynamic> queryParams = const {},
  ]) async {
    final url = Uri.parse('${ApiPaths.baseUrl}$path');
    final headers = await getHeaders;

    final rawResponse = await retry(
      () => http
          .post(url, headers: headers, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 60)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
      maxAttempts: 4,
    );
    final response = _normalizeResponse(rawResponse);
    _logRequest(
      queryParams: queryParams,

      method: "POST",
      url: url,
      headers: headers,
      body: requestBody,
      response: response,
    );

    return response;
  }

  static Future<http.Response> put(
    String path, [
    Object? requestBody,
    Map<String, dynamic> queryParams = const {},
  ]) async {
    final url = Uri.parse('${ApiPaths.baseUrl}$path');
    final headers = await getHeaders;

    final rawResponse = await retry(
      () => http
          .put(url, headers: headers, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 60)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
      maxAttempts: 4,
    );
    final response = _normalizeResponse(rawResponse);
    _logRequest(
      queryParams: queryParams,

      method: "PUT",
      url: url,
      headers: headers,
      body: requestBody,
      response: response,
    );

    return response;
  }

  static Future<http.Response> patch(
    String path, [
    Object? requestBody,
    Map<String, dynamic> queryParams = const {},
  ]) async {
    final url = Uri.parse('${ApiPaths.baseUrl}$path');
    final headers = await getHeaders;
    final rawResponse = await retry(
      () => http
          .patch(url, headers: headers, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 4)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
      maxAttempts: 4,
    );
    final response = _normalizeResponse(rawResponse);
    _logRequest(
      queryParams: queryParams,

      method: "PATCH",
      url: url,
      headers: headers,
      body: requestBody,
      response: response,
    );

    return response;
  }

  static Future<http.Response> delete(
    String path, [
    Object? requestBody,
    Map<String, dynamic> queryParams = const {},
  ]) async {
    final url = Uri.parse('${ApiPaths.baseUrl}$path');
    final headers = await getHeaders;

    final rawResponse = await retry(
      () => http
          .delete(url, headers: headers, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 60)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
      maxAttempts: 4,
    );
    final response = _normalizeResponse(rawResponse);
    _logRequest(
      queryParams: queryParams,

      method: "DELETE",
      url: url,
      headers: headers,
      body: requestBody,
      response: response,
    );

    return response;
  }

  static Future<http.Response> multipartPost(
    String path, {
    Map<String, String> fields = const {},
    Map<String, String> queryParams = const {},
    File? file,
    String fileKey = 'file',
  }) async {
    final uri = Uri.parse(
      '${ApiPaths.baseUrl}$path',
    ).replace(queryParameters: queryParams);
    final headers = await getHeaders;

    final request =
        http.MultipartRequest('POST', uri)
          ..headers.addAll(headers)
          ..fields.addAll(fields);

    // Add file if provided
    if (file != null) {
      final fileStream = http.ByteStream(file.openRead());
      final length = await file.length();
      final multipartFile = http.MultipartFile(
        fileKey, // Use provided file key
        fileStream,
        length,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    logger.d(
      "Multipart request to: $uri"
      "Fields: $fields"
      "Headers: $headers",
    );

    final streamedResponse = await retry(
      () => request.send().timeout(const Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
      maxAttempts: 4,
    );
    final converted = await http.Response.fromStream(streamedResponse);
    final response = _normalizeResponse(converted);
    _logRequest(
      queryParams: queryParams,
      method: "POST",
      url: uri,
      headers: headers,
      body: fields,
      response: response,
    );
    return response;
  }

  static Future<http.Response> multipartListPost(
    String path, {
    Map<String, String> fields = const {},
    Map<String, String> queryParams = const {},
    File? file,
    String fileKey = 'file',
    List<http.MultipartFile>? files,
  }) async {
    final uri = Uri.parse(
      '${ApiPaths.baseUrl}$path',
    ).replace(queryParameters: queryParams);
    final headers = await getHeaders;

    final request =
        http.MultipartRequest('POST', uri)
          ..headers.addAll(headers)
          ..fields.addAll(fields);

    // Add files if provided
    if (files != null) {
      // final fileStream = http.ByteStream(file.openRead());
      // final length = await file.length();
      // final multipartFile = http.MultipartFile(
      //   fileKey, // Use provided file key
      //   fileStream,
      //   length,
      //   filename: file.path.split('/').last,
      // );
      request.files.addAll(files);
    }

    logger.d(
      "Multipart request POST: $uri"
      "Fields: $fields"
      "Headers: $headers",
    );

    final streamedResponse = await retry(
      () => request.send().timeout(const Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
      maxAttempts: 4,
    );
    final converted = await http.Response.fromStream(streamedResponse);
    final response = _normalizeResponse(converted);
    _logRequest(
      queryParams: queryParams,
      method: "POST",
      url: uri,
      headers: headers,
      body: fields,
      response: response,
    );
    return response;
  }
}
