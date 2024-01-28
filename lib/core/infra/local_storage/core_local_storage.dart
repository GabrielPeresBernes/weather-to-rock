import 'package:flutter/material.dart';

/// Store and retrieve data from local storage.
abstract interface class CoreLocalStorage {
  /// Gets a value from local storage.
  ///
  /// Generic type [T] can not be nullable.
  T getValue<T>(String key, T defaultValue);

  /// Sets a value to local storage.
  ///
  /// Throws an [Exception] if [value] type is not supported.
  Future<void> setValue(String key, dynamic value);

  /// Gets a [ValueNotifier] from local storage.
  ValueNotifier<T> getNotifier<T>(String key, T defaultValue);
}
