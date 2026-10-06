# Markdown Editor

Markdown editing widgets for Flutter, with custom Lemmy and PieFed syntax.

Provides `MarkdownToolbar` and `MarkdownTextInputField` widgets.

## Development

Initialize the Flutter submodule after cloning:

```sh
git submodule update --init --recursive
```

Run analysis, formatting checks, tests, and coverage:

```sh
./scripts/check.sh
```

The coverage report is saved to `coverage/lcov.info` and uploaded as a CI artifact.

## Markdown support

The following markdown syntax is supported by this package:

- Bold: `MarkdownType.bold`
- Italics: `MarkdownType.italic`
- Strikethrough: `MarkdownType.strikethrough`
- Links: `MarkdownType.link`
- Headings: `MarkdownType.title`
- Lists: `MarkdownType.list`
- Code: `MarkdownType.code`
- Block quotes: `MarkdownType.blockquote`
- Dividers: `MarkdownType.separator`
- Images: `MarkdownType.image`

### Custom Markdown

Custom actions support Lemmy and PieFed syntax:

- User format `@user@instance.tld`
- Community format `!community@instance.tld`
- Spoiler tags

## Acknowledgements

Original implementation by [Playmoweb](https://github.com/playmoweb/markdown-editable-textinput).
