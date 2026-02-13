import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:snip/snippet_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:highlight/languages/dart.dart';

class CreateSnippetPage extends StatelessWidget {
  CreateSnippetPage({super.key});
  final client = Supabase.instance.client;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController titleControl = TextEditingController();
  final CodeController _codeController = CodeController(language: dart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 8, children: [Icon(Icons.code), Text('Snip')]),
      ),
      body: Center(
        child: Form(
          key: _key,
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'New Snippet',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 500,
                width: 900,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 16,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: titleControl,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Title',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: DropdownButtonFormField(
                                hint: Text('Select a language'),
                                items: [
                                  DropdownMenuItem(
                                    value: 'dart',
                                    child: Text('Dart'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'javascript',
                                    child: Text('JavaScript'),
                                  ),
                                ],
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: CodeTheme(
                              data: CodeThemeData(styles: monokaiTheme),
                              child: CodeField(
                                minLines: 20,
                                controller: _codeController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  FilledButton(onPressed: () {}, child: Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //faltan implementar los tags aun
  Future<void> postNewSnippet(
    String title,
    String content,
    String language,
  ) async {
    final SnippetClass hardSnip = SnippetClass(
      title: title,
      content: content,
      language: language,
    );
    await client.from('snippets').insert(hardSnip.toRequiredSupaJson());
  }
}
