import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockRouter extends Mock implements GoRouter {}

class MockRouterProvider extends StatelessWidget {
  const MockRouterProvider({
    required this.child,
    this.router,
    Key? key,
  }) : super(key: key);

  final Widget child;

  final MockRouter? router;

  @override
  Widget build(BuildContext context) => InheritedGoRouter(
        goRouter: router ?? MockRouter(),
        child: child,
      );
}
