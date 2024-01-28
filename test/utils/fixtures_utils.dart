import 'dart:convert';
import 'dart:io';

abstract final class FixturesUtils {
  static String readFixture(String name) =>
      File('test/fixtures/$name').readAsStringSync();

  static Map<String, dynamic> readFixtureAsMap(String name) =>
      jsonDecode(FixturesUtils.readFixture(name));
}
