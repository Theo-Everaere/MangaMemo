import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newscan/main.dart';
import 'package:newscan/service/manga_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Créer une instance de SharedPreferences en mémoire pour le test
    final prefs = await SharedPreferences.getInstance();
    final cacheService = MangaCacheService(prefs);

    // Construire notre app avec le cacheService simulé
    await tester.pumpWidget(MyApp(cacheService: cacheService));

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
