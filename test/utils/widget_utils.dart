import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/router_mock.dart';

abstract final class WidgetUtils {
  static Future<void> pumpWidget(
    WidgetTester tester, {
    required Widget widget,
    MockRouter? router,
    List<BlocProvider>? providers,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MockRouterProvider(
          router: router,
          child: MultiBlocProvider(
            providers: providers ?? [],
            child: widget,
          ),
        ),
      ),
    );

    await tester.pump();
  }
}
