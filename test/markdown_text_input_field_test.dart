import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController(text: 'Controller draft');
    focusNode = FocusNode();
  });

  Future<void> pumpField(WidgetTester tester, {String? initialValue, ValueChanged<String>? onTextChanged, FormFieldValidator<String>? validator}) async {
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
      focusNode.dispose();
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: MarkdownTextInputField(
              controller: controller,
              focusNode: focusNode,
              initialValue: initialValue,
              onTextChanged: onTextChanged,
              validators: validator,
              label: 'Write a reply',
              spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('initial value replaces the controller draft and starts the cursor at zero', (tester) async {
    await pumpField(tester, initialValue: 'Initial draft');

    expect(find.text('Initial draft'), findsOneWidget);
    expect(controller.text, 'Initial draft');
    expect(controller.selection, const TextSelection.collapsed(offset: 0));
  });

  testWidgets('existing selection is preserved when mounting the field', (tester) async {
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 10);
    await pumpField(tester);

    expect(find.text('Controller draft'), findsOneWidget);
    expect(controller.selection, const TextSelection(baseOffset: 0, extentOffset: 10));
  });

  testWidgets('typing and controller edits report the updated draft', (tester) async {
    final changes = <String>[];
    await pumpField(tester, onTextChanged: changes.add);

    await tester.enterText(find.byType(TextFormField), 'Typed **reply**');
    expect(changes.last, 'Typed **reply**');
    expect(find.text('Typed **reply**'), findsOneWidget);

    controller.text = 'Updated from toolbar';
    await tester.pump();
    expect(changes.last, 'Updated from toolbar');
    expect(find.text('Updated from toolbar'), findsOneWidget);
  });

  testWidgets('validation displays an error and clears it after the draft is fixed', (tester) async {
    await pumpField(tester, validator: (value) => value == null || value.isEmpty ? 'A reply is required' : null);
    final form = tester.state<FormState>(find.byType(Form));

    await tester.enterText(find.byType(TextFormField), '');
    expect(form.validate(), isFalse);
    await tester.pump();
    expect(find.text('A reply is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Valid reply');
    expect(form.validate(), isTrue);
    await tester.pump();
    expect(find.text('Valid reply'), findsOneWidget);
    expect(find.text('A reply is required'), findsNothing);
  });
}
