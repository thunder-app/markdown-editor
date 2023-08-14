import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

/// Text field of a [MarkdownTextInput] for when it should be separated from the buttons.
/// Designed to be used in conjunction with [MarkdownButtons].
class MarkdownTextInputField extends StatefulWidget {
  /// Callback called when text changed
  final Function? onTextChanged;

  /// Initial value you want to display
  final String? initialValue;

  /// Validator for the TextFormField
  final String? Function(String? value)? validators;

  /// String displayed at hintText in TextFormField
  final String? label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection textDirection;

  /// The maximum of lines that can be displayed in the input.
  /// If this is null, there is no limit to the number of lines.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  /// If this is null, starts with enough vertical space for one line.
  final int? minLines;

  /// Controller that controls this text field. The same controller must be
  /// given to the corresponding [MarkdownButtons].
  final TextEditingController controller;

  /// [FocusNode] used to request focus on this text field. The same [FocusNode]
  /// must be given to the corresponding [MarkdownButtons].
  final FocusNode focusNode;

  /// Overrides input text style
  final TextStyle? textStyle;

  /// Constructor for [MarkdownTextInputField]
  const MarkdownTextInputField({
    required this.controller,
    required this.focusNode,
    this.onTextChanged,
    this.initialValue,
    this.label = '',
    this.validators,
    this.textDirection = TextDirection.ltr,
    this.minLines,
    this.maxLines,
    this.textStyle,
  });

  @override
  State createState() => _MarkdownTextInputFieldState();
}

class _MarkdownTextInputFieldState extends State<MarkdownTextInputField> {
  @override
  void initState() {
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
    if (widget.controller.selection.baseOffset == -1) {
      widget.controller.selection = const TextSelection.collapsed(offset: 0);
    }
    if (widget.onTextChanged != null) {
      widget.controller.addListener(() {
        widget.onTextChanged!(widget.controller.text);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          spellCheckConfiguration: kIsWeb ? null : const SpellCheckConfiguration(),
          minLines: widget.minLines,
          focusNode: widget.focusNode,
          textInputAction: TextInputAction.newline,
          maxLines: widget.maxLines,
          controller: widget.controller,
          textCapitalization: TextCapitalization.sentences,
          validator: widget.validators != null ? (value) => widget.validators!(value) : null,
          style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
          cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
          textDirection: widget.textDirection,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.label,
          ),
        ),
      ],
    );
  }
}
