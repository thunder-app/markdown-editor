import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:material_ui/material_ui.dart';

import 'support/editor.dart';

void main() {
  testWidgets('all actions are available and heading choices open on demand', (tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: MarkdownType.values);

    for (final type in MarkdownType.values) {
      expect(find.byKey(Key(type.key)), findsOneWidget, reason: '${type.name} should be available');
    }
    expect(find.text('H1').hitTestable(), findsNothing);

    await tester.tap(find.text('H#'));
    await tester.pumpAndSettle();

    for (var level = 1; level <= 6; level++) {
      expect(find.text('H$level').hitTestable(), findsOneWidget);
    }
  });

  group('formatting selected text', () {
    for (final example in [
      (type: MarkdownType.bold, text: 'Draft', expectedText: '**Draft**', cursorOffset: 9),
      (type: MarkdownType.italic, text: 'Draft', expectedText: '_Draft_', cursorOffset: 7),
      (type: MarkdownType.strikethrough, text: 'Draft', expectedText: '~~Draft~~', cursorOffset: 9),
      (type: MarkdownType.link, text: 'Draft', expectedText: '[Draft](Draft)', cursorOffset: 14),
      (type: MarkdownType.list, text: 'First\nSecond', expectedText: '* First\n* Second', cursorOffset: 16),
      (type: MarkdownType.code, text: 'Draft', expectedText: '```Draft```', cursorOffset: 11),
      (type: MarkdownType.blockquote, text: 'First\nSecond', expectedText: '> First\n> Second', cursorOffset: 16),
      (type: MarkdownType.separator, text: 'Draft', expectedText: '\n------\nDraft', cursorOffset: 13),
      (type: MarkdownType.image, text: 'Draft', expectedText: '![Draft](Draft)', cursorOffset: 15),
      (type: MarkdownType.spoiler, text: 'Draft', expectedText: '::: spoiler Spoiler\nDraft\n:::', cursorOffset: 20),
    ]) {
      testWidgets('${example.type.name} updates the draft and returns focus to the field', (tester) async {
        final controller = TextEditingController(text: example.text);
        final focusNode = FocusNode();
        await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [example.type], insertLinksByDialog: false);
        controller.selection = TextSelection(baseOffset: 0, extentOffset: example.text.length);

        await tester.tap(find.byKey(Key(example.type.key)));
        await tester.pump();

        expect(controller.text, example.expectedText);
        expect(find.text(example.expectedText), findsOneWidget);
        expect(controller.selection, TextSelection.collapsed(offset: example.cursorOffset));
        expect(focusNode.hasFocus, isTrue);
      });
    }
  });

  group('formatting at the cursor', () {
    for (final example in [
      (type: MarkdownType.bold, expectedText: 'Say **** here', cursorOffset: 6),
      (type: MarkdownType.italic, expectedText: 'Say __ here', cursorOffset: 5),
      (type: MarkdownType.strikethrough, expectedText: 'Say ~~~~ here', cursorOffset: 6),
      (type: MarkdownType.code, expectedText: 'Say `````` here', cursorOffset: 7),
    ]) {
      testWidgets('${example.type.name} puts the cursor between inserted markers', (tester) async {
        final controller = TextEditingController(text: 'Say  here');
        final focusNode = FocusNode();
        await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [example.type]);
        controller.selection = const TextSelection.collapsed(offset: 4);

        await tester.tap(find.byKey(Key(example.type.key)));
        await tester.pump();

        expect(controller.text, example.expectedText);
        expect(controller.selection, TextSelection.collapsed(offset: example.cursorOffset));
        expect(focusNode.hasFocus, isTrue);
      });
    }

    testWidgets('blockquote inserts an alternative selection at the cursor', (tester) async {
      final controller = TextEditingController(text: 'Reply:\n');
      final focusNode = FocusNode();
      await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [MarkdownType.blockquote], getAlternativeSelection: () => 'First line\nSecond line');
      controller.selection = const TextSelection.collapsed(offset: 7);

      await tester.tap(find.byKey(const Key('quote_button')));
      await tester.pump();

      expect(controller.text, 'Reply:\n> First line\n> Second line');
      expect(controller.selection, const TextSelection.collapsed(offset: 33));
    });
  });
}
