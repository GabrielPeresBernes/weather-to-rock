import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_to_rock/app/app.dart';
import 'package:weather_to_rock/app/infra/router/app_router.dart';

import 'app/infra/app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await const AppModule().init();

  final appRouter = GetIt.I.get<AppRouter>();

  runApp(
    App(
      routerConfig: appRouter.router(),
    ),
  );
}
