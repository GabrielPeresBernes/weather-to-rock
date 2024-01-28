import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final ThemeData theme = ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
  );
}
