import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart'; // Certifique-se de ajustar o caminho correto.

void main() {
  testWidgets('Teste inicial do Jogo da Velha', (WidgetTester tester) async {
    // Inicializa o aplicativo.
    await tester.pumpWidget(const TicTacToeApp());

    // Verifica se o título aparece corretamente.
    expect(find.text('Jogo da Velha'), findsOneWidget);

    // Verifica o estado inicial do tabuleiro (todos os espaços vazios).
    for (int i = 0; i < 9; i++) {
      expect(find.text(''), findsNWidgets(9));
    }

    // Simula um toque no primeiro espaço do tabuleiro.
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Verifica se o "X" foi inserido no primeiro espaço.
    expect(find.text('X'), findsOneWidget);

    // Simula o botão "Reiniciar".
    await tester.tap(find.text('Reiniciar'));
    await tester.pump();

    // Verifica se o tabuleiro foi reiniciado (todos os espaços vazios novamente).
    for (int i = 0; i < 9; i++) {
      expect(find.text(''), findsNWidgets(9));
    }
  });
}
