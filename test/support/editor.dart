import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:material_ui/material_ui.dart';

/// Mounts a field and toolbar sharing the supplied controller and focus node.
/// This helper owns their cleanup, unmounting the editor before disposing them.
Future<void> pumpEditor(
  WidgetTester tester, {
  required TextEditingController controller,
  required FocusNode focusNode,
  required List<MarkdownType> actions,
  bool insertLinksByDialog = true,
  Map<MarkdownType, VoidCallback>? customTapActions,
  VoidCallback? customImageButtonAction,
  bool imageIsLoading = false,
  String? Function()? getAlternativeSelection,
}) async {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
    focusNode.dispose();
  });

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            MarkdownTextInputField(controller: controller, focusNode: focusNode, spellCheckConfiguration: const SpellCheckConfiguration.disabled()),
            MarkdownToolbar(
              controller: controller,
              focusNode: focusNode,
              actions: actions,
              insertLinksByDialog: insertLinksByDialog,
              customTapActions: customTapActions,
              customImageButtonAction: customImageButtonAction,
              imageIsLoading: imageIsLoading,
              getAlternativeSelection: getAlternativeSelection,
            ),
          ],
        ),
      ),
    ),
  );
}
