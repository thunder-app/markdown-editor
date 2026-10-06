import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:material_ui/material_ui.dart';

import 'support/editor.dart';

void main() {
  group('mentions', () {
    for (final example in [
      (type: MarkdownType.username, mention: '[@alice@example.org](https://example.org/u/alice)', expectedText: 'Hello [@alice@example.org](https://example.org/u/alice)'),
      (type: MarkdownType.community, mention: '[!flutter@example.org](https://example.org/c/flutter)', expectedText: 'Hello [!flutter@example.org](https://example.org/c/flutter)'),
    ]) {
      testWidgets('custom ${example.type.name} action inserts a mention', (tester) async {
        final controller = TextEditingController(text: 'Hello ');
        final focusNode = FocusNode();
        await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [example.type], customTapActions: {example.type: () => controller.text += example.mention});

        await tester.tap(find.byKey(Key(example.type.key)));
        await tester.pump();

        expect(find.text(example.expectedText), findsOneWidget);
      });
    }
  });

  group('images', () {
    testWidgets('the upload action inserts an image', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      await pumpEditor(
        tester,
        controller: controller,
        focusNode: focusNode,
        actions: [MarkdownType.image],
        customImageButtonAction: () => controller.text = '![Sunset](https://example.org/sunset.jpg)',
      );

      await tester.tap(find.byKey(const Key('image_button')));
      await tester.pump();

      expect(find.text('![Sunset](https://example.org/sunset.jpg)'), findsOneWidget);
    });

    testWidgets('a custom tap action takes precedence over the upload action', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      await pumpEditor(
        tester,
        controller: controller,
        focusNode: focusNode,
        actions: [MarkdownType.image],
        customTapActions: {MarkdownType.image: () => controller.text = '![Override](override.png)'},
        customImageButtonAction: () => controller.text = '![Upload](upload.png)',
      );

      await tester.tap(find.byKey(const Key('image_button')));
      await tester.pump();

      expect(find.text('![Override](override.png)'), findsOneWidget);
    });

    testWidgets('the progress indicator is replaced by a usable image button after uploading', (tester) async {
      final controller = TextEditingController(text: 'photo.png');
      final focusNode = FocusNode();
      await pumpEditor(tester, controller: controller, focusNode: focusNode, actions: [MarkdownType.image], imageIsLoading: true);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('image_button')), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownToolbar(controller: controller, focusNode: focusNode, actions: const [MarkdownType.image], imageIsLoading: false),
          ),
        ),
      );
      controller.selection = const TextSelection(baseOffset: 0, extentOffset: 9);
      await tester.tap(find.byKey(const Key('image_button')));
      await tester.pumpAndSettle();

      expect(controller.text, '![photo.png](photo.png)');
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
