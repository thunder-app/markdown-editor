import 'dart:math';

import 'package:flutter/material.dart';

/// Class that converts a [String] to [ResultMarkdown]
class FormatMarkdown {
  static ResultMarkdown convertToMarkdown(
    /// Type of markdown
    MarkdownType type,

    /// String to convert
    String data,

    /// Start index when converting part of [data]
    int fromIndex,

    /// End index when converting part of [data]
    int toIndex, {
    /// Title size for markdown headings
    int titleSize = 1,

    /// Link used for converting to [MarkdownType.link]
    String? link,

    /// The curently selected text
    String selectedText = '',

    /// An alternate data source on which to perform formatting
    String? alternateData,
  }) {
    late String changedData;
    late int replaceCursorIndex;
    int? cursorIndex;

    final lesserIndex = min(fromIndex, toIndex);
    final greaterIndex = max(fromIndex, toIndex);

    fromIndex = lesserIndex;
    toIndex = greaterIndex;

    switch (type) {
      case MarkdownType.bold:
        changedData = '**${data.substring(fromIndex, toIndex)}**';
        replaceCursorIndex = 2;
        break;
      case MarkdownType.italic:
        changedData = '_${data.substring(fromIndex, toIndex)}_';
        replaceCursorIndex = 1;
        break;
      case MarkdownType.strikethrough:
        changedData = '~~${data.substring(fromIndex, toIndex)}~~';
        replaceCursorIndex = 2;
        break;
      case MarkdownType.link:
        changedData = '[$selectedText](${link ?? selectedText})';
        replaceCursorIndex = 0;
        break;
      case MarkdownType.title:
        changedData = "${"#" * titleSize} ${data.substring(fromIndex, toIndex)}";
        replaceCursorIndex = 0;
        break;
      case MarkdownType.list:
        int index = 0;
        final splitedData = data.substring(fromIndex, toIndex).split('\n');
        changedData = splitedData.map((value) {
          index++;
          return index == splitedData.length ? '* $value' : '* $value\n';
        }).join();
        replaceCursorIndex = 0;
        break;
      case MarkdownType.code:
        changedData = '```${data.substring(fromIndex, toIndex)}```';
        replaceCursorIndex = 3;
        break;
      case MarkdownType.blockquote:
        var index = 0;
        final splitedData = (data.isEmpty ? (alternateData ?? '') : data.substring(fromIndex, toIndex)).split('\n');
        changedData = splitedData.map((value) {
          index++;
          return index == splitedData.length ? '> $value' : '> $value\n';
        }).join();
        replaceCursorIndex = 0;
        break;
      case MarkdownType.separator:
        changedData = '\n------\n${data.substring(fromIndex, toIndex)}';
        replaceCursorIndex = 0;
        break;
      case MarkdownType.image:
        changedData = '![${data.substring(fromIndex, toIndex)}](${data.substring(fromIndex, toIndex)})';
        replaceCursorIndex = 3;
        break;
      case MarkdownType.spoiler:
        if (fromIndex == 0 && toIndex == data.length) {
          // If the entire data is selected, then convert to spoiler
          changedData = '::: spoiler Spoiler\n${data.substring(fromIndex, toIndex)}\n:::';
          cursorIndex = 20;
        } else {
          // If part of the data is selected, then add new lines when necessary
          changedData = '${fromIndex == 0 ? '' : '\n'}::: spoiler Spoiler\n${data.substring(fromIndex, toIndex)}\n:::${toIndex == data.length ? '' : '\n'}';
          cursorIndex = fromIndex == 0 ? 20 + data.substring(fromIndex, toIndex).length : 21 + data.substring(fromIndex, toIndex).length;
        }

        replaceCursorIndex = 0;
        break;
      case MarkdownType.username:
      case MarkdownType.community:
        break;
    }

    cursorIndex ??= changedData.length;

    return ResultMarkdown(
      data.substring(0, fromIndex) + changedData + data.substring(toIndex, data.length),
      cursorIndex,
      replaceCursorIndex,
    );
  }
}

/// [ResultMarkdown] gives you the converted [data] to markdown and the associated [cursorIndex]
class ResultMarkdown {
  /// String converted to markdown
  String data;

  /// Cursor index position just after the converted part in markdown
  int cursorIndex;

  /// Index at which cursor need to be replaced if no text selected
  int replaceCursorIndex;

  ResultMarkdown(this.data, this.cursorIndex, this.replaceCursorIndex);
}

/// Enum containing all compatible markdown types
///
/// Contains methods to get key and icon for the given [MarkdownType]
enum MarkdownType {
  /// For **bold** text
  bold,

  /// For _italic_ text
  italic,

  /// For ~~strikethrough~~ text
  strikethrough,

  /// For [link](https://flutter.dev)
  link,

  /// For # Title or ## Title or ### Title
  title,

  /// For :
  ///   * Item 1
  ///   * Item 2
  ///   * Item 3
  list,

  /// For ```code``` text
  code,

  /// For :
  ///   > Item 1
  ///   > Item 2
  ///   > Item 3
  blockquote,

  /// For adding ------
  separator,

  /// For ![Alt text](link)
  image,

  /// For [@username@instance.tld](https://instance.tld/u/username)
  username,

  /// For [!community@instance.tld](https://instance.tld/c/community)
  community,

  /// For
  /// ::: spoiler
  /// :::
  /// text
  spoiler;

  String get key {
    switch (this) {
      case MarkdownType.bold:
        return 'bold_button';
      case MarkdownType.italic:
        return 'italic_button';
      case MarkdownType.strikethrough:
        return 'strikethrough_button';
      case MarkdownType.link:
        return 'link_button';
      case MarkdownType.title:
        return 'H#_button';
      case MarkdownType.list:
        return 'list_button';
      case MarkdownType.code:
        return 'code_button';
      case MarkdownType.blockquote:
        return 'quote_button';
      case MarkdownType.separator:
        return 'separator_button';
      case MarkdownType.image:
        return 'image_button';
      case MarkdownType.username:
        return 'username_button';
      case MarkdownType.community:
        return 'community_button';
      case MarkdownType.spoiler:
        return 'spoiler_button';
    }
  }

  IconData get icon {
    switch (this) {
      case MarkdownType.bold:
        return Icons.format_bold;
      case MarkdownType.italic:
        return Icons.format_italic;
      case MarkdownType.strikethrough:
        return Icons.format_strikethrough;
      case MarkdownType.link:
        return Icons.link;
      case MarkdownType.title:
        return Icons.text_fields;
      case MarkdownType.list:
        return Icons.list;
      case MarkdownType.code:
        return Icons.code;
      case MarkdownType.blockquote:
        return Icons.format_quote_rounded;
      case MarkdownType.separator:
        return Icons.minimize_rounded;
      case MarkdownType.image:
        return Icons.image_rounded;
      case MarkdownType.username:
        return Icons.alternate_email_rounded;
      case MarkdownType.community:
        return const IconData(0x0021);
      case MarkdownType.spoiler:
        return Icons.lock_rounded;
    }
  }
}
