import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newscan/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construire l'application sans dépendances de cache
    await tester.pumpWidget(MyApp()); // Passer `null` ou une version simplifiée de cacheService

    // Vérifier l'initialisation et l'interaction avec l'UI
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap sur le bouton '+' et simuler une mise à jour de l'UI
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Vérifier que le compteur a été incrémenté
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
