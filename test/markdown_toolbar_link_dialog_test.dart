import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:material_ui/material_ui.dart';

import 'support/editor.dart';

Finder _dialogField(String label) => find.descendant(
  of: find.byType(AlertDialog),
  matching: find.ancestor(of: find.text(label), matching: find.byType(TextField)),
);

void main() {
  testWidgets('editing the selected label and URL inserts a link', (tester) async {
    final controller = TextEditingController(text: 'Visit Flutter today.');
    final focusNode = FocusNode();
    await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [MarkdownType.link]);
    controller.selection = const TextSelection(baseOffset: 6, extentOffset: 13);

    await tester.tap(find.byKey(const Key('link_button')));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(_dialogField('Text')).controller!.text, 'Flutter');
    expect(tester.widget<TextField>(_dialogField('Link')).focusNode!.hasFocus, isTrue);

    await tester.enterText(_dialogField('Text'), 'Flutter docs');
    await tester.enterText(_dialogField('Link'), 'https://flutter.dev');
    await tester.tap(find.text('Insert'));
    await tester.pumpAndSettle();

    expect(find.text('Visit [Flutter docs](https://flutter.dev) today.'), findsOneWidget);
    expect(controller.selection, const TextSelection.collapsed(offset: 41));
    expect(focusNode.hasFocus, isTrue);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('keyboard next moves focus to the URL and cancelling preserves the draft', (tester) async {
    final controller = TextEditingController(text: 'Visit ');
    final focusNode = FocusNode();
    await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [MarkdownType.link]);
    controller.selection = const TextSelection.collapsed(offset: 6);

    await tester.tap(find.byKey(const Key('link_button')));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(_dialogField('Text')).focusNode!.hasFocus, isTrue);

    await tester.enterText(_dialogField('Text'), 'Documentation');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(_dialogField('Link')).focusNode!.hasFocus, isTrue);

    await tester.enterText(_dialogField('Link'), 'https://example.org');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Visit '), findsOneWidget);
    expect(controller.selection, const TextSelection.collapsed(offset: 6));
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('a new link is inserted at the cursor', (tester) async {
    final controller = TextEditingController(text: 'Visit  today.');
    final focusNode = FocusNode();
    await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [MarkdownType.link]);
    controller.selection = const TextSelection.collapsed(offset: 6);

    await tester.tap(find.byKey(const Key('link_button')));
    await tester.pumpAndSettle();
    await tester.enterText(_dialogField('Text'), 'Docs');
    await tester.enterText(_dialogField('Link'), 'https://example.org');
    await tester.tap(find.text('Insert'));
    await tester.pumpAndSettle();

    expect(find.text('Visit [Docs](https://example.org) today.'), findsOneWidget);
    expect(controller.selection, const TextSelection.collapsed(offset: 33));
    expect(find.byType(AlertDialog), findsNothing);
  });
}
