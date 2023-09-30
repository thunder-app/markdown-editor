import 'dart:io';
import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';

import 'format_markdown.dart';

/// Buttons of a [MarkdownTextInput] for when they should be separated from the text field.
/// Designed to be used in conjunction with [MarkdownTextInputField].
class MarkdownButtons extends StatelessWidget {
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

  /// Constructor for [MarkdownButtons]
  const MarkdownButtons({
    required this.controller,
    required this.focusNode,
    this.actions = const [MarkdownType.bold, MarkdownType.italic, MarkdownType.title, MarkdownType.link, MarkdownType.list],
    this.insertLinksByDialog = true,
    this.customImageButtonAction,
    this.imageIsLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 44,
      child: Material(
        color: Theme.of(context).cardColor,
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
                        child: Center(
                            child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(),
                        ))),
                  );
                }
                return _basicInkwell(type, label: 'Image', customOnTap: customImageButtonAction);
              case MarkdownType.title:
                return ExpandableNotifier(
                  child: Expandable(
                    key: const Key('H#_button'),
                    collapsed: ExpandableButton(
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'H#',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
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
                              child: Icon(
                                Icons.close,
                                semanticLabel: 'Close header options',
                              ),
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
                          var text = controller.text.substring(controller.selection.start, controller.selection.end);

                          var textController = TextEditingController()..text = text;
                          var linkController = TextEditingController();
                          var textFocus = FocusNode();
                          var linkFocus = FocusNode();

                          var color = Theme.of(context).colorScheme.secondary;
                          var language = kIsWeb ? window.locale.languageCode : Platform.localeName.substring(0, 2);

                          var textLabel = 'Text';
                          var linkLabel = 'Link';

                          if (context.mounted) {
                            await showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: const EdgeInsets.all(20),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 24.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Insert Link', style: theme.textTheme.titleLarge),
                                                GestureDetector(child: const Icon(Icons.close), onTap: () => Navigator.pop(context)),
                                              ],
                                            ),
                                          ),
                                          TextField(
                                            controller: textController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'example',
                                              label: Text(textLabel),
                                              labelStyle: TextStyle(color: color),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                            ),
                                            autofocus: text.isEmpty,
                                            focusNode: textFocus,
                                            textInputAction: TextInputAction.next,
                                            onSubmitted: (value) {
                                              textFocus.unfocus();
                                              FocusScope.of(context).requestFocus(linkFocus);
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: linkController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'https://example.com',
                                              label: Text(linkLabel),
                                              labelStyle: TextStyle(color: color),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                            ),
                                            autofocus: text.isNotEmpty,
                                            focusNode: linkFocus,
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                _onTap(type, link: linkController.text, selectedText: textController.text);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Insert'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
      key: Key(type.key),
      onTap: () => customOnTap != null ? customOnTap() : _onTap(type),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(type.icon, semanticLabel: label),
      ),
    );
  }

  void _onTap(MarkdownType type, {int titleSize = 1, String? link, String? selectedText}) {
    var noTextSelected = (controller.selection.start - controller.selection.end) == 0;

    var fromIndex = controller.selection.start;
    var toIndex = controller.selection.end;

    final result =
        FormatMarkdown.convertToMarkdown(type, controller.text, fromIndex, toIndex, titleSize: titleSize, link: link, selectedText: selectedText ?? controller.text.substring(fromIndex, toIndex));

    controller.value = controller.value.copyWith(text: result.data, selection: TextSelection.collapsed(offset: fromIndex + result.cursorIndex));

    if (noTextSelected) {
      controller.selection = TextSelection.collapsed(offset: controller.selection.end - result.replaceCursorIndex);
    }

    focusNode.requestFocus();
  }
}
