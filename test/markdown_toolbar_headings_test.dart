import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:material_ui/material_ui.dart';

import 'support/editor.dart';

void main() {
  for (final heading in [
    (level: 1, expectedText: '# Heading', cursorOffset: 9),
    (level: 2, expectedText: '## Heading', cursorOffset: 10),
    (level: 3, expectedText: '### Heading', cursorOffset: 11),
    (level: 4, expectedText: '#### Heading', cursorOffset: 12),
    (level: 5, expectedText: '##### Heading', cursorOffset: 13),
    (level: 6, expectedText: '###### Heading', cursorOffset: 14),
  ]) {
    testWidgets('choosing H${heading.level} formats the selected text', (tester) async {
      final controller = TextEditingController(text: 'Heading');
      final focusNode = FocusNode();
      await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [MarkdownType.title]);
      controller.selection = const TextSelection(baseOffset: 0, extentOffset: 7);

      await tester.tap(find.text('H#'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('H${heading.level}').hitTestable());
      await tester.pump();

      expect(find.text(heading.expectedText), findsOneWidget);
      expect(controller.selection, TextSelection.collapsed(offset: heading.cursorOffset));
      expect(focusNode.hasFocus, isTrue);
    });
  }

  testWidgets('heading options can be closed and reopened without changing the draft', (tester) async {
    final controller = TextEditingController(text: 'Heading');
    final focusNode = FocusNode();
    await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [MarkdownType.title]);
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 7);

    await tester.tap(find.text('H#'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('H#').hitTestable(), findsOneWidget);
    expect(find.text('H1').hitTestable(), findsNothing);
    expect(controller.text, 'Heading');
    expect(controller.selection, const TextSelection(baseOffset: 0, extentOffset: 7));

    await tester.tap(find.text('H#'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('H2').hitTestable());
    await tester.pump();

    expect(find.text('## Heading'), findsOneWidget);
  });
}
