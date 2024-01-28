import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class FakeUri extends Fake implements Uri {}

class MockHttp extends Mock implements http.Client {}
