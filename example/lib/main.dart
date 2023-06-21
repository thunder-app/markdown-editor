import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

void main() => runApp(MyApp());

// ignore: public_member_api_docs
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String description = 'My great package';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      print(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EditableTextInput'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      MarkdownTextInput(
                        (String value) => setState(() => description = value),
                        description,
                        label: 'Description',
                        maxLines: 10,
                        actions: MarkdownType.values,
                        controller: controller,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clear();
                        },
                        child: Text('Clear'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: MarkdownBody(
                          data: description,
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
