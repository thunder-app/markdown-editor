import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editor/markdown_editor.dart';

void main() {
  group('partial spoilers', () {
    for (final example in [
      (name: 'at the start', start: 0, end: 5, expectedText: '::: spoiler Spoiler\nFirst\n:::\n middle last', cursorIndex: 25),
      (name: 'in the middle', start: 6, end: 12, expectedText: 'First \n::: spoiler Spoiler\nmiddle\n:::\n last', cursorIndex: 27),
      (name: 'at the end', start: 6, end: 17, expectedText: 'First \n::: spoiler Spoiler\nmiddle last\n:::', cursorIndex: 32),
      (name: 'within a word', start: 6, end: 9, expectedText: 'First \n::: spoiler Spoiler\nmid\n:::\ndle last', cursorIndex: 24),
    ]) {
      for (final reversed in [false, true]) {
        test('${example.name} with a ${reversed ? 'reversed' : 'forward'} selection adds only the needed newlines', () {
          final result = FormatMarkdown.convertToMarkdown(MarkdownType.spoiler, 'First middle last', reversed ? example.end : example.start, reversed ? example.start : example.end);

          expect(result.data, example.expectedText);
          expect(result.cursorIndex, example.cursorIndex);
          expect(result.replaceCursorIndex, 0);
        });
      }
    }
  });

  test('a whole-draft spoiler needs no surrounding blank lines', () {
    final result = FormatMarkdown.convertToMarkdown(MarkdownType.spoiler, 'Secret', 0, 6);

    expect(result.data, '::: spoiler Spoiler\nSecret\n:::');
    expect(result.cursorIndex, 20);
    expect(result.replaceCursorIndex, 0);
  });
}
