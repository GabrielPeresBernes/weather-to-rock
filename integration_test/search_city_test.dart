import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_to_rock/app/components/card_tile.dart';
import 'package:weather_to_rock/main.dart' as app;

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('search city', (tester) async {
    app.main();

    await tester.pumpAndSettle();

    expect(find.byType(CardTile), findsNWidgets(4));

    await tester.tap(find.byKey(const Key('search_city_text_field')));

    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('search_city_text_field')), 'São Paulo');

    await tester.pumpAndSettle();

    expect(find.byType(CardTile), findsOne);

    expect(
      find.byWidgetPredicate(
          (widget) => widget is CardTile && widget.title == 'São Paulo'),
      findsOne,
    );
  });
}
