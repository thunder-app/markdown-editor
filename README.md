# Markdown Editor

A set of utility widgets that convert Text to Markdown. Extended to support custom Lemmy syntax.

Provides `MarkdownToolbar` and `MarkdownTextInputField` widgets.

## Markdown Support
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
Custom markdown actions have been added to handle Lemmy specific syntax. This includes
- User format `@user@instance.tld`
- Community format `!community@instance.tld`
- Spoiler tags

## Acknowledgements

Original implementation by [Playmoweb](https://github.com/playmoweb/markdown-editable-textinput). 
