import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor/markdown_editor.dart';

void main() {
  runApp(const MarkdownEditorExample());
}

class MarkdownEditorExample extends StatelessWidget {
  const MarkdownEditorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Markdown Editor Example',
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

  final focusNode = FocusNode();

  bool showPreview = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(top: 8.0),
          title: Text('Markdown Editor', style: theme.textTheme.titleLarge),
          subtitle: Text('Mode: ${showPreview ? 'Previewing' : 'Editing'}'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(showPreview ? Icons.visibility_off_rounded : Icons.visibility_rounded),
            onPressed: () {
              if (showPreview) focusNode.requestFocus();
              setState(() => showPreview = !showPreview);
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Divider(),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: showPreview
                      ? Markdown(data: controller.text, shrinkWrap: true, padding: EdgeInsets.zero)
                      : MarkdownTextInputField(
                          controller: controller,
                          focusNode: focusNode,
                          label: 'Enter markdown text here',
                          minLines: 25,
                          maxLines: null,
                        ),
                ),
              ),
            ),
          ),
          const Divider(),
          MarkdownToolbar(
            controller: controller,
            focusNode: focusNode,
            actions: const [
              MarkdownType.image,
              MarkdownType.link,
              MarkdownType.bold,
              MarkdownType.italic,
              MarkdownType.spoiler,
              MarkdownType.blockquote,
              MarkdownType.strikethrough,
              MarkdownType.title,
              MarkdownType.list,
              MarkdownType.separator,
              MarkdownType.code,
            ],
          ),
        ],
      ),
    );
  }
}
