import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:markdown_editor/src/format_markdown.dart';
import 'package:markdown_editor/src/markdown_toolbar.dart';

void main() {
  Widget component(String initialValue, Function updateValue) {
    TextEditingController controller = TextEditingController(text: initialValue);
    FocusNode focusNode = FocusNode();

    return MaterialApp(
      home: Scaffold(
        body: MarkdownToolbar(
          controller: controller,
          focusNode: focusNode,
          actions: MarkdownType.values,
          insertLinksByDialog: false,
        ),
      ),
    );
  }

  testWidgets('MarkdownTextInput has all buttons', (WidgetTester tester) async {
    await tester.pumpWidget(component('initial value', () => null));

    const boldKey = Key('bold_button');
    const italicKey = Key('italic_button');
    const strikethroughKey = Key('strikethrough_button');
    const hKey = Key('H#_button');
    const h1Key = Key('H1_button');
    const h2Key = Key('H2_button');
    const h3Key = Key('H3_button');
    const h4Key = Key('H4_button');
    const h5Key = Key('H5_button');
    const h6Key = Key('H6_button');
    const linkKey = Key('link_button');
    const listKey = Key('list_button');
    const quoteKey = Key('quote_button');
    const separatorKey = Key('separator_button');
    const imageKey = Key('image_button');

    expect(find.byKey(boldKey), findsOneWidget);
    expect(find.byKey(italicKey), findsOneWidget);
    expect(find.byKey(strikethroughKey), findsOneWidget);
    expect(find.byKey(hKey), findsOneWidget);
    expect(find.byKey(h1Key), findsOneWidget);
    expect(find.byKey(h2Key), findsOneWidget);
    expect(find.byKey(h3Key), findsOneWidget);
    expect(find.byKey(h4Key), findsOneWidget);
    expect(find.byKey(h5Key), findsOneWidget);
    expect(find.byKey(h6Key), findsOneWidget);
    expect(find.byKey(linkKey), findsOneWidget);
    expect(find.byKey(listKey), findsOneWidget);
    expect(find.byKey(quoteKey), findsOneWidget);
    expect(find.byKey(separatorKey), findsOneWidget);
    expect(find.byKey(imageKey), findsOneWidget);
  });

  testWidgets('MarkdownTextInput make bold from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('bold_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '**initial value**');
  });

  testWidgets('MarkdownTextInput make italic from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('italic_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '_initial value_');
  });

  testWidgets('MarkdownTextInput make strikethrough from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('strikethrough_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '~~initial value~~');
  });

  testWidgets('MarkdownTextInput make code from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('code_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '```initial value```');
  });

  testWidgets('MarkdownTextInput make link from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('link_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '[initial value](initial value)');
  });

  testWidgets('MarkdownTextInput make list from selection', (WidgetTester tester) async {
    String initialValue = 'initial\nvalue';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('list_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '* initial\n* value');
  });

  testWidgets('MarkdownTextInput make blockquote from selection', (WidgetTester tester) async {
    String initialValue = 'initial\nvalue';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('quote_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '> initial\n> value');
  });

  testWidgets('MarkdownTextInput make separator from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('separator_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '\n------\ninitial value');
  });

  testWidgets('MarkdownTextInput make image link from selection', (WidgetTester tester) async {
    String initialValue = 'initial value';
    await tester.pumpWidget(component(initialValue, (String value) => initialValue = value));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    const boldKey = Key('image_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '![initial value](initial value)');
  });
}
