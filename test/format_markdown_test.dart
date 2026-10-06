import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';

void main() {
  for (final selection in [(name: 'forward selection', start: 7, end: 11), (name: 'reversed selection', start: 11, end: 7)]) {
    group(selection.name, () {
      for (final example in [
        (type: MarkdownType.bold, expectedText: 'Before **word** after', cursorIndex: 8, replaceCursorIndex: 2),
        (type: MarkdownType.italic, expectedText: 'Before _word_ after', cursorIndex: 6, replaceCursorIndex: 1),
        (type: MarkdownType.strikethrough, expectedText: 'Before ~~word~~ after', cursorIndex: 8, replaceCursorIndex: 2),
        (type: MarkdownType.code, expectedText: 'Before ```word``` after', cursorIndex: 10, replaceCursorIndex: 3),
        (type: MarkdownType.separator, expectedText: 'Before \n------\nword after', cursorIndex: 12, replaceCursorIndex: 0),
        (type: MarkdownType.image, expectedText: 'Before ![word](word) after', cursorIndex: 13, replaceCursorIndex: 3),
      ]) {
        test('${example.type.name} preserves the surrounding text', () {
          final result = FormatMarkdown.convertToMarkdown(example.type, 'Before word after', selection.start, selection.end);

          expect(result.data, example.expectedText);
          expect(result.cursorIndex, example.cursorIndex); // The formatter's cursor index is relative to the start of the selection.
          expect(result.replaceCursorIndex, example.replaceCursorIndex);
        });
      }

      test('link uses the selected label as the default URL', () {
        final result = FormatMarkdown.convertToMarkdown(MarkdownType.link, 'Before word after', selection.start, selection.end, selectedText: 'word');

        expect(result.data, 'Before [word](word) after');
        expect(result.cursorIndex, 12);
        expect(result.replaceCursorIndex, 0);
      });

      for (final heading in [
        (level: 1, expectedText: 'Before # word after', cursorIndex: 6),
        (level: 2, expectedText: 'Before ## word after', cursorIndex: 7),
        (level: 3, expectedText: 'Before ### word after', cursorIndex: 8),
        (level: 4, expectedText: 'Before #### word after', cursorIndex: 9),
        (level: 5, expectedText: 'Before ##### word after', cursorIndex: 10),
        (level: 6, expectedText: 'Before ###### word after', cursorIndex: 11),
      ]) {
        test('heading level ${heading.level} preserves the surrounding text', () {
          final result = FormatMarkdown.convertToMarkdown(MarkdownType.title, 'Before word after', selection.start, selection.end, titleSize: heading.level);

          expect(result.data, heading.expectedText);
          expect(result.cursorIndex, heading.cursorIndex);
          expect(result.replaceCursorIndex, 0);
        });
      }
    });
  }

  test('link accepts a separate label and URL', () {
    final result = FormatMarkdown.convertToMarkdown(MarkdownType.link, 'Visit site today', 6, 10, link: 'https://example.org', selectedText: 'Docs');

    expect(result.data, 'Visit [Docs](https://example.org) today');
    expect(result.cursorIndex, 27);
    expect(result.replaceCursorIndex, 0);
  });

  group('multiline selections', () {
    for (final example in [
      (type: MarkdownType.list, expectedText: '* First line\n* Second line\n* Third line'),
      (type: MarkdownType.blockquote, expectedText: '> First line\n> Second line\n> Third line'),
    ]) {
      test('${example.type.name} prefixes every selected line', () {
        const text = 'First line\nSecond line\nThird line';
        final result = FormatMarkdown.convertToMarkdown(example.type, text, 0, text.length);

        expect(result.data, example.expectedText);
        expect(result.cursorIndex, 39);
        expect(result.replaceCursorIndex, 0);
      });
    }
  });

  group('custom actions', () {
    for (final type in [MarkdownType.username, MarkdownType.community]) {
      test('${type.name} requires a custom tap action', () {
        expect(
          () => FormatMarkdown.convertToMarkdown(type, 'alice@example.org', 0, 17),
          throwsA(isA<UnsupportedError>().having((error) => error.message, 'message', '${type.name} requires a custom tap action.')),
        );
      });
    }
  });
}
