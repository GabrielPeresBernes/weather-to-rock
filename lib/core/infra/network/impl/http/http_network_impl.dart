import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core_network.dart';

final class HttpNetworkImpl implements CoreNetwork {
  HttpNetworkImpl({
    required this.baseUrl,
    http.Client? clientInstance,
  }) : _client = clientInstance ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final params = _getParams(queryParams);

    final response = await _client.get(
      Uri.parse('$baseUrl$path$params'),
      headers: headers,
    );

    return _getResponse(
      response: response,
      path: path,
      headers: headers,
    );
  }
}

String _getParams(Map<String, String>? params) {
  if (params == null) {
    return '';
  }

  final query = params.entries.map((entry) {
    final key = entry.key;
    final value = entry.value;

    return '$key=$value';
  }).join('&');

  return '?$query';
}

Map<String, dynamic> _getResponse({
  required http.Response response,
  required String path,
  required Map<String, String>? headers,
}) {
  if (response.statusCode == HttpStatus.ok ||
      response.statusCode == HttpStatus.created ||
      response.statusCode == HttpStatus.noContent) {
    return response.body.isEmpty
        ? {}
        : jsonDecode(response.body) as Map<String, dynamic>;
  }

  final message = '''
        Error on request \n
        Path: \n $path \n
        Headers: \n $headers \n
        Status Code: \n ${response.statusCode} \n
        Body: \n ${response.body} \n
      ''';

  debugPrint(message);

  throw Exception(message);
}
