import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';

void main() {
  Key boldKey = Key(MarkdownType.bold.key);
  Key italicKey = Key(MarkdownType.italic.key);
  Key strikethroughKey = Key(MarkdownType.strikethrough.key);
  Key linkKey = Key(MarkdownType.link.key);

  Key hKey = Key(MarkdownType.title.key);
  Key h1Key = const Key('H1_button');
  Key h2Key = const Key('H2_button');
  Key h3Key = const Key('H3_button');
  Key h4Key = const Key('H4_button');
  Key h5Key = const Key('H5_button');
  Key h6Key = const Key('H6_button');

  Key listKey = Key(MarkdownType.list.key);
  Key codeKey = Key(MarkdownType.code.key);
  Key quoteKey = Key(MarkdownType.blockquote.key);
  Key separatorKey = Key(MarkdownType.separator.key);
  Key imageKey = Key(MarkdownType.image.key);

  Key usernameKey = Key(MarkdownType.username.key);
  Key communityKey = Key(MarkdownType.community.key);
  Key spoilerKey = Key(MarkdownType.spoiler.key);

  Widget component(String initialValue, Function updateValue) {
    TextEditingController controller = TextEditingController(text: initialValue);
    FocusNode focusNode = FocusNode();

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            MarkdownTextInputField(
              controller: controller,
              focusNode: focusNode,
            ),
            MarkdownToolbar(
              controller: controller,
              focusNode: focusNode,
              actions: MarkdownType.values,
              insertLinksByDialog: false,
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('MarkdownToolbar has all markdown buttons', (WidgetTester tester) async {
    await tester.pumpWidget(component('initial value', () => null));

    expect(find.byKey(boldKey), findsOneWidget);
    expect(find.byKey(italicKey), findsOneWidget);
    expect(find.byKey(strikethroughKey), findsOneWidget);
    expect(find.byKey(linkKey), findsOneWidget);

    expect(find.byKey(hKey), findsOneWidget);
    expect(find.byKey(h1Key), findsOneWidget);
    expect(find.byKey(h2Key), findsOneWidget);
    expect(find.byKey(h3Key), findsOneWidget);
    expect(find.byKey(h4Key), findsOneWidget);
    expect(find.byKey(h5Key), findsOneWidget);
    expect(find.byKey(h6Key), findsOneWidget);

    expect(find.byKey(listKey), findsOneWidget);
    expect(find.byKey(codeKey), findsOneWidget);
    expect(find.byKey(quoteKey), findsOneWidget);
    expect(find.byKey(separatorKey), findsOneWidget);
    expect(find.byKey(imageKey), findsOneWidget);

    expect(find.byKey(usernameKey), findsOneWidget);
    expect(find.byKey(communityKey), findsOneWidget);
    expect(find.byKey(spoilerKey), findsOneWidget);
  });

  testWidgets('MarkdownTextInputField make bold from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(boldKey));
    expect(formfield.controller.text, '**initial value**');
  });

  testWidgets('MarkdownTextInputField make italic from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(italicKey));
    expect(formfield.controller.text, '_initial value_');
  });

  testWidgets('MarkdownTextInputField make strikethrough from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(strikethroughKey));
    expect(formfield.controller.text, '~~initial value~~');
  });

  testWidgets('MarkdownTextInputField make link from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(linkKey));
    expect(formfield.controller.text, '[initial value](initial value)');
  });

  testWidgets('MarkdownTextInputField make header 1 from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(hKey));
    await tester.ensureVisible(find.byKey(h1Key));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(h1Key));

    expect(formfield.controller.text, '# initial value');
  });

  testWidgets('MarkdownTextInputField make header 2 from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(hKey));
    await tester.ensureVisible(find.byKey(h2Key));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(h2Key));

    expect(formfield.controller.text, '## initial value');
  });

  testWidgets('MarkdownTextInputField make header 3 from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(hKey));
    await tester.ensureVisible(find.byKey(h3Key));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(h3Key));

    expect(formfield.controller.text, '### initial value');
  });

  testWidgets('MarkdownTextInputField make header 4 from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(hKey));
    await tester.ensureVisible(find.byKey(h4Key));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(h4Key));

    expect(formfield.controller.text, '#### initial value');
  });

  testWidgets('MarkdownTextInputField make header 5 from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(hKey));
    await tester.ensureVisible(find.byKey(h5Key));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(h5Key));

    expect(formfield.controller.text, '##### initial value');
  });

  testWidgets('MarkdownTextInputField make header 6 from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(hKey));
    await tester.ensureVisible(find.byKey(h6Key));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(h6Key));

    expect(formfield.controller.text, '###### initial value');
  });

  testWidgets('MarkdownTextInputField make list from selection', (WidgetTester tester) async {
    String initialValue = 'initial\nvalue';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(listKey));
    expect(formfield.controller.text, '* initial\n* value');
  });

  testWidgets('MarkdownTextInputField make code from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(codeKey));
    expect(formfield.controller.text, '```initial value```');
  });

  testWidgets('MarkdownTextInputField make blockquote from selection', (WidgetTester tester) async {
    String initialValue = 'initial\nvalue';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(quoteKey));
    expect(formfield.controller.text, '> initial\n> value');
  });

  testWidgets('MarkdownTextInputField make separator from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(separatorKey));
    expect(formfield.controller.text, '\n------\ninitial value');
  });

  testWidgets('MarkdownTextInputField make image link from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(imageKey));
    expect(formfield.controller.text, '![initial value](initial value)');
  });

  testWidgets('MarkdownTextInputField make spoiler from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    await tester.tap(find.byKey(spoilerKey));
    expect(formfield.controller.text, '::: spoiler Spoiler\ninitial value\n:::');
  });

  // TODO: Add tests for username, community buttons
}
