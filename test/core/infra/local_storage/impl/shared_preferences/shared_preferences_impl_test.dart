import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_to_rock/core/infra/local_storage/local_storage.dart';

import '../../mocks/local_storage_mocks.dart';

main() {
  late SharedPreferences sharedPreferences;
  late SharedPreferencesImpl sharedPreferencesImpl;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();

    sharedPreferencesImpl = await SharedPreferencesImpl.init(
      sharedPreferencesInstance: sharedPreferences,
    );
  });

  group('local_storage_shared_preferences', () {
    group('getValue', () {
      test('should return a value when it exists', () async {
        when(() => sharedPreferences.get(any())).thenReturn('value');

        final value = sharedPreferencesImpl.getValue('key', 'default');

        expect(value, 'value');

        verify(() => sharedPreferences.get('key')).called(1);
      });

      test('should return a default value when it does not exist', () async {
        when(() => sharedPreferences.get(any())).thenReturn(null);

        final value = sharedPreferencesImpl.getValue('key', 'default');

        expect(value, 'default');

        verify(() => sharedPreferences.get('key')).called(1);
      });
    });

    group('setValue', () {
      test('should set a value', () async {
        // arrange
        when(() => sharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => true);

        // act
        await sharedPreferencesImpl.setValue('key', {'key': 'value'});

        // assert
        verify(() => sharedPreferences.setString('key', '{"key":"value"}'))
            .called(1);
      });

      test('should throw an exception when the value is not supported',
          () async {
        // arrange
        when(() => sharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => false);

        // act & assert
        expect(
          () async => await sharedPreferencesImpl.setValue('key', 'value'),
          throwsA(isA<Exception>()),
        );

        verifyNever(() => sharedPreferences.setString('key', 'value'));
      });
    });

    group('getNotifier', () {
      test('should return a notifier', () async {
        // arrange
        when(() => sharedPreferences.get(any())).thenReturn('value');

        // act
        final notifier = sharedPreferencesImpl.getNotifier('key', 'default');

        // assert
        expect(notifier.value, 'value');

        verify(() => sharedPreferences.get('key')).called(1);
      });

      test('should return a default value when it does not exist', () async {
        // arrange
        when(() => sharedPreferences.get(any())).thenReturn(null);

        // act
        final notifier = sharedPreferencesImpl.getNotifier('key', 'default');

        // assert
        expect(notifier.value, 'default');

        verify(() => sharedPreferences.get('key')).called(1);
      });
    });

    group('notifyListeners', () {
      test('should notify listeners', () async {
        when(() => sharedPreferences.get(any())).thenReturn('{"key":"value"}');

        when(() => sharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => true);

        final notifier =
            sharedPreferencesImpl.getNotifier<Map<String, dynamic>>('key', {});

        expect(notifier.value, {'key': 'value'});

        await sharedPreferencesImpl.setValue('key', {'key': 'new_value'});

        expect(notifier.value, {'key': 'new_value'});
      });
    });
  });
}
