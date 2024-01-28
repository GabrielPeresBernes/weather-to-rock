import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_to_rock/core/infra/local_storage/core_local_storage.dart';

final class SharedPreferencesImpl implements CoreLocalStorage {
  SharedPreferencesImpl._();

  static late SharedPreferences _preferences;

  final Map<String, ValueNotifier> _notifiers = {};

  static Future<SharedPreferencesImpl> init({
    SharedPreferences? sharedPreferencesInstance,
  }) async {
    _preferences =
        sharedPreferencesInstance ?? await SharedPreferences.getInstance();

    return SharedPreferencesImpl._();
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    final value = _preferences.get(key);

    if (value == null) {
      return defaultValue;
    }

    return defaultValue is Map<String, dynamic>
        ? jsonDecode(value as String)
        : value as T;
  }

  @override
  Future<void> setValue(String key, dynamic value) async {
    if (value is Map<String, dynamic>) {
      await _preferences.setString(key, jsonEncode(value));
    } else {
      throw Exception('Invalid type');
    }

    _notifyListeners(key, value);
  }

  @override
  ValueNotifier<T> getNotifier<T>(String key, T defaultValue) {
    if (!_notifiers.containsKey(key)) {
      _notifiers[key] = ValueNotifier<T>(getValue<T>(key, defaultValue));
    }

    return _notifiers[key] as ValueNotifier<T>;
  }

  void _notifyListeners<T>(String key, T value) {
    if (_notifiers.containsKey(key)) {
      (_notifiers[key] as ValueNotifier<T>).value = value;
    }
  }
}
