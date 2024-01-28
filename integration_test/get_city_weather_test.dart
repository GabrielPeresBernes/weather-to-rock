import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_to_rock/app/components/card_tile.dart';
import 'package:weather_to_rock/main.dart' as app;

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('get city weather with connection', (tester) async {
    app.main();

    await tester.pumpAndSettle();

    expect(find.byType(CardTile), findsNWidgets(4));

    await tester.tap(find.text('São Paulo'));

    await tester.pumpAndSettle();

    expect(find.byType(CardTile), findsNWidgets(41));
  });
}
