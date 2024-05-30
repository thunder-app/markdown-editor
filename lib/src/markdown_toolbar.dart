import 'dart:math';

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';

import 'format_markdown.dart';

/// A toolbar containing all possible Markdown actions. Designed to be used in conjunction with [MarkdownTextInputField].
class MarkdownToolbar extends StatelessWidget {
  /// Controller that controls the corresponding [MarkdownTextInputField].
  final TextEditingController controller;

  /// FocusNode used to request focus on the corresponding [MarkdownTextInputField].
  final FocusNode focusNode;

  /// List of actions the component can handle
  final List<MarkdownType> actions;

  /// If you prefer to use the dialog to insert links, you can choose to use the markdown syntax directly by setting [insertLinksByDialog] to false. In this case, the selected text will be used as label and link.
  /// Default value is true.
  final bool insertLinksByDialog;

  /// Optional function to override the default image button action when [MarkdownType.image] is in [actions].
  final Function? customImageButtonAction;

  /// When true, image icon is replaced by a [CircularProgressIndicator].
  final bool imageIsLoading;

  /// Allows overriding tap actions for each [MarkdownType]
  final Map<MarkdownType, void Function()>? customTapActions;

  /// Constructor for [MarkdownToolbar]
  const MarkdownToolbar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.actions = const [MarkdownType.bold, MarkdownType.italic, MarkdownType.title, MarkdownType.link, MarkdownType.list],
    this.insertLinksByDialog = true,
    this.customImageButtonAction,
    this.imageIsLoading = false,
    this.customTapActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: Material(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: actions.map((MarkdownType type) {
            switch (type) {
              case MarkdownType.image:
                if (imageIsLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator())),
                    ),
                  );
                }
                return _basicInkwell(type, label: 'Image', customOnTap: customImageButtonAction);
              case MarkdownType.title:
                return ExpandableNotifier(
                  child: Expandable(
                    key: Key(MarkdownType.title.key),
                    collapsed: ExpandableButton(
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('H#', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    expanded: Container(
                      color: Colors.white10,
                      child: Row(
                        children: [
                          for (int i = 1; i <= 6; i++)
                            InkWell(
                              key: Key('H${i}_button'),
                              onTap: () => _onTap(MarkdownType.title, titleSize: i),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'H$i',
                                  style: TextStyle(fontSize: (18 - i).toDouble(), fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ExpandableButton(
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.close, semanticLabel: 'Close header options'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              case MarkdownType.link:
                return _basicInkwell(
                  type,
                  label: 'Link',
                  customOnTap: !insertLinksByDialog
                      ? null
                      : () async {
                          String text = controller.text.substring(controller.selection.start, controller.selection.end);

                          TextEditingController textController = TextEditingController()..text = text;
                          TextEditingController linkController = TextEditingController();
                          FocusNode textFocus = FocusNode();
                          FocusNode linkFocus = FocusNode();

                          String textLabel = 'Text';
                          String linkLabel = 'Link';

                          if (context.mounted) {
                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Insert Link'),
                                  content: SizedBox(
                                    width: min(MediaQuery.of(context).size.width, 700),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: textController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'example',
                                            label: Text(textLabel),
                                            border: const OutlineInputBorder(),
                                          ),
                                          autofocus: text.isEmpty,
                                          focusNode: textFocus,
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (value) {
                                            textFocus.unfocus();
                                            FocusScope.of(context).requestFocus(linkFocus);
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller: linkController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'https://example.com',
                                            label: Text(linkLabel),
                                            border: const OutlineInputBorder(),
                                          ),
                                          autofocus: text.isNotEmpty,
                                          focusNode: linkFocus,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        _onTap(type, link: linkController.text, selectedText: textController.text);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Insert'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                );
              default:
                return _basicInkwell(type, label: type.name);
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _basicInkwell(MarkdownType type, {required String label, Function? customOnTap}) {
    return InkWell(
      customBorder: const CircleBorder(),
      key: Key(type.key),
      onTap: () => customTapActions?.containsKey(type) == true
          ? customTapActions![type]!()
          : customOnTap != null
              ? customOnTap()
              : _onTap(type),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(type.icon, semanticLabel: label),
      ),
    );
  }

  /// Handles onTap for all [MarkdownType] actions. It converts the selected text to Markdown, and adjusts the cursor position accordingly.
  void _onTap(MarkdownType type, {int titleSize = 1, String? link, String? selectedText}) {
    bool noTextSelected = (controller.selection.start - controller.selection.end) == 0;

    int fromIndex = controller.selection.start;
    int toIndex = controller.selection.end;

    ResultMarkdown result = FormatMarkdown.convertToMarkdown(
      type,
      controller.text,
      fromIndex,
      toIndex,
      titleSize: titleSize,
      link: link,
      selectedText: selectedText ?? controller.text.substring(fromIndex, toIndex),
    );

    controller.value = controller.value.copyWith(text: result.data, selection: TextSelection.collapsed(offset: fromIndex + result.cursorIndex));

    if (noTextSelected) {
      controller.selection = TextSelection.collapsed(offset: controller.selection.end - result.replaceCursorIndex);
    }

    focusNode.requestFocus();
  }
}
