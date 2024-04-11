import 'package:flutter_test/flutter_test.dart';

import 'package:markdown_editor/src/format_markdown.dart';

void main() {
  group("Test FormatMarkdown.convertToMarkdown function", () {
    test('successfully converts to bold (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.bold,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '**' '**' = 4");
      expect(formattedText.data, 'Lorem ipsum **dolor** sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to bold (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.bold,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '**' '**' = 4");
      expect(formattedText.data, 'Lorem ipsum **dolor** sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to italic (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.italic,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 7, reason: "dolor length = 5, '_' '_' = 2");
      expect(formattedText.data, 'Lorem ipsum _dolor_ sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to italic (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.italic,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 7, reason: "dolor length = 5, '_' '_' = 2");
      expect(formattedText.data, 'Lorem ipsum _dolor_ sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to strikethrough (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.strikethrough,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '~~' '~~' = 4");
      expect(formattedText.data, 'Lorem ipsum ~~dolor~~ sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to strikethrough (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.strikethrough,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '~~' '~~' = 4");
      expect(formattedText.data, 'Lorem ipsum ~~dolor~~ sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to Link (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.link,
        testString,
        from,
        to,
        selectedText: 'dolor',
      );

      expect(formattedText.data, 'Lorem ipsum [dolor](dolor) sit amet consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 14, reason: "dolor length = 5, '[dolor](dolor)'= 14");
    });

    test('successfully converts to Link (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.link,
        testString,
        from,
        to,
        selectedText: 'dolor',
      );

      expect(formattedText.data, 'Lorem ipsum [dolor](dolor) sit amet consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 14, reason: "dolor length = 5, '[](dolor)'= 9");
    });

    test('successfully converts to Link by dialog', () {
      String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.link,
        testString,
        from,
        to,
        link: 'example.com',
        selectedText: 'dolor',
      );

      expect(formattedText.data, 'Lorem ipsum [dolor](example.com) sit amet consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 20, reason: "dolor length = 5, '[](dolor)'= 9");
    });

    test('successfully converts to H1 (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 1,
      );

      expect(formattedText.cursorIndex, 7, reason: "dolor length = 5, '# '= 2");
      expect(formattedText.data, 'Lorem ipsum # dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H1 (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 1,
      );

      expect(formattedText.cursorIndex, 7, reason: "dolor length = 5, '# '= 2");
      expect(formattedText.data, 'Lorem ipsum # dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H2 (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 2,
      );

      expect(formattedText.cursorIndex, 8, reason: "dolor length = 5, '## '= 3");
      expect(formattedText.data, 'Lorem ipsum ## dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H2 (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 2,
      );

      expect(formattedText.cursorIndex, 8, reason: "dolor length = 5, '## '= 3");
      expect(formattedText.data, 'Lorem ipsum ## dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H3 (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 3,
      );

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '### '= 4");
      expect(formattedText.data, 'Lorem ipsum ### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H3 (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 3,
      );

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '### '= 4");
      expect(formattedText.data, 'Lorem ipsum ### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H4 (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 4,
      );

      expect(formattedText.cursorIndex, 10, reason: "dolor length = 5, '#### '= 5");
      expect(formattedText.data, 'Lorem ipsum #### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H4 (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 4,
      );

      expect(formattedText.cursorIndex, 10, reason: "dolor length = 5, '#### '= 5");
      expect(formattedText.data, 'Lorem ipsum #### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H5 (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 5,
      );

      expect(formattedText.cursorIndex, 11, reason: "dolor length = 5, '##### '= 6");
      expect(formattedText.data, 'Lorem ipsum ##### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H5 (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 5,
      );

      expect(formattedText.cursorIndex, 11, reason: "dolor length = 5, '##### '= 6");
      expect(formattedText.data, 'Lorem ipsum ##### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H6 (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 6,
      );

      expect(formattedText.cursorIndex, 12, reason: "dolor length = 5, '###### '= 7");
      expect(formattedText.data, 'Lorem ipsum ###### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to H6 (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.title,
        testString,
        from,
        to,
        titleSize: 6,
      );

      expect(formattedText.cursorIndex, 12, reason: "dolor length = 5, '###### '= 7");
      expect(formattedText.data, 'Lorem ipsum ###### dolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to List (LTR)', () {
      String testString = 'Lorem ipsum\ndolor sit amet\nconsectetur adipiscing elit.';
      int from = 0;
      int to = testString.length;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.list,
        testString,
        from,
        to,
      );

      expect(formattedText.data, '* Lorem ipsum\n* dolor sit amet\n* consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 61, reason: "testString length = 55, '* * * '= 6");
    });

    test('successfully converts to code (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.code,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 11, reason: "dolor length = 5, '```' '```' = 6");
      expect(formattedText.data, 'Lorem ipsum ```dolor``` sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to code (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.code,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 11, reason: "dolor length = 5, '```' '```' = 6");
      expect(formattedText.data, 'Lorem ipsum ```dolor``` sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to blockquote', () {
      String testString = 'Lorem ipsum\ndolor sit amet\nconsectetur adipiscing elit.';
      int from = 0;
      int to = testString.length;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.blockquote,
        testString,
        from,
        to,
      );

      expect(formattedText.data, '> Lorem ipsum\n> dolor sit amet\n> consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 61, reason: "testString length = 55, '> > > '= 6");
    });

    test('successfully converts to separator (LTR)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 12;
      int to = 17;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.separator,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 13, reason: "dolor length = 5, '\n------\n' = 8");
      expect(formattedText.data, 'Lorem ipsum \n------\ndolor sit amet, consectetur adipiscing elit.');
    });

    test('successfully converts to separator (RTL)', () {
      String testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      int from = 17;
      int to = 12;

      ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
        MarkdownType.separator,
        testString,
        from,
        to,
      );

      expect(formattedText.cursorIndex, 13, reason: "dolor length = 5, '\n------\n' = 8");
      expect(formattedText.data, 'Lorem ipsum \n------\ndolor sit amet, consectetur adipiscing elit.');
    });
  });

  test('successfully converts to image link (LTR)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 12;
    int to = 17;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.image,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem ipsum ![dolor](dolor) sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 15, reason: "dolor length = 5, '![](dolor)'= 10");
  });

  test('successfully converts to image link (RTL)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 17;
    int to = 12;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.image,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem ipsum ![dolor](dolor) sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 15, reason: "dolor length = 5, '![](dolor)'= 10");
  });

  test('successfully converts to spoiler (LTR)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 12;
    int to = 17;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem ipsum \n::: spoiler Spoiler\ndolor\n:::\n sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 26, reason: "dolor length = 5, '\n::: spoiler Spoiler\ndolor\n:::\n'= 31");
  });

  test('successfully converts to spoiler (RTL)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 17;
    int to = 12;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem ipsum \n::: spoiler Spoiler\ndolor\n:::\n sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 26, reason: "dolor length = 5, '\n::: spoiler Spoiler\ndolor\n:::\n'= 31");
  });

  test('successfully converts to spoiler (partial with start index at 0) (LTR)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 0;
    int to = 5;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, '::: spoiler Spoiler\nLorem\n:::\n ipsum dolor sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 25, reason: "::: spoiler Spoiler\nLorem = 25");
  });

  test('successfully converts to spoiler (partial with start index at 0) (RTL)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 5;
    int to = 0;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, '::: spoiler Spoiler\nLorem\n:::\n ipsum dolor sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 25, reason: "::: spoiler Spoiler\nLorem = 25");
  });

  test('successfully converts to spoiler (partial with start index in the middle) (LTR)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 6;
    int to = 11;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem \n::: spoiler Spoiler\nipsum\n:::\n dolor sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 26, reason: "\n::: spoiler Spoiler\nipsum = 26");
  });

  test('successfully converts to spoiler (partial with start index in the middle) (RTL)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 11;
    int to = 6;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem \n::: spoiler Spoiler\nipsum\n:::\n dolor sit amet consectetur adipiscing elit.');
    expect(formattedText.cursorIndex, 26, reason: "\n::: spoiler Spoiler\nipsum = 26");
  });

  test('successfully converts to spoiler (partial with end index at the end) (LTR)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 6;
    int to = 55;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem \n::: spoiler Spoiler\nipsum dolor sit amet consectetur adipiscing elit.\n:::');
    expect(formattedText.cursorIndex, 70, reason: "\n::: spoiler Spoiler\nipsum dolor sit amet consectetur adipiscing elit. = 70");
  });

  test('successfully converts to spoiler (partial with end index at the end) (RTL)', () {
    String testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    int from = 55;
    int to = 6;

    ResultMarkdown formattedText = FormatMarkdown.convertToMarkdown(
      MarkdownType.spoiler,
      testString,
      from,
      to,
    );

    expect(formattedText.data, 'Lorem \n::: spoiler Spoiler\nipsum dolor sit amet consectetur adipiscing elit.\n:::');
    expect(formattedText.cursorIndex, 70, reason: "\n::: spoiler Spoiler\nipsum dolor sit amet consectetur adipiscing elit. = 70");
  });

  // TODO: Add tests for username, community
}
