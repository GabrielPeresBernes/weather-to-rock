import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/core/infra/network/network.dart';

import '../../mocks/network_mocks.dart';

main() {
  late http.Client client;
  late HttpNetworkImpl httpNetwork;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    client = MockHttp();

    httpNetwork = HttpNetworkImpl(
      baseUrl: 'http://localhost:3000',
      clientInstance: client,
    );
  });

  group('http_network', () {
    test('should return a map with the response body when status is 200',
        () async {
      // arrange
      when(() => client.get(
            any(),
            headers: null,
          )).thenAnswer((_) async => http.Response('{"key": "value"}', 200));

      // act
      final response = await httpNetwork.get('/');

      // assert
      expect(response, {'key': 'value'});

      verify(() => client.get(
            Uri.parse('http://localhost:3000/'),
            headers: null,
          )).called(1);
    });

    test('should return a map with the response body when status is 201',
        () async {
      // arrange
      when(() => client.get(
            any(),
            headers: null,
          )).thenAnswer((_) async => http.Response('{"key": "value"}', 201));

      // act
      final response = await httpNetwork.get('/');

      // assert
      expect(response, {'key': 'value'});

      verify(() => client.get(
            Uri.parse('http://localhost:3000/'),
            headers: null,
          )).called(1);
    });

    test('should return empty map when status is 204', () async {
      // arrange
      when(() => client.get(
            any(),
            headers: null,
          )).thenAnswer((_) async => http.Response('', 204));

      // act
      final response = await httpNetwork.get('/');

      // assert
      expect(response, {});

      verify(() => client.get(
            Uri.parse('http://localhost:3000/'),
            headers: null,
          )).called(1);
    });

    test('should make request with query parameters', () async {
      // arrange
      when(() => client.get(
            any(),
            headers: null,
          )).thenAnswer((_) async => http.Response('{"key": "value"}', 200));

      // act
      final response = await httpNetwork.get('/path', queryParams: {
        'key': 'value',
      });

      // assert
      expect(response, {'key': 'value'});

      verify(() => client.get(
            Uri.parse('http://localhost:3000/path?key=value'),
            headers: null,
          )).called(1);
    });

    test('should throw a Exception when the status code is not 2xx', () async {
      // arrange
      when(() => client.get(
            any(),
            headers: null,
          )).thenAnswer((_) async => http.Response('{"key": "value"}', 400));

      // act && assert
      expect(() => httpNetwork.get('/'), throwsA(isA<Exception>()));

      verify(() => client.get(
            Uri.parse('http://localhost:3000/'),
            headers: null,
          )).called(1);
    });
  });
}
