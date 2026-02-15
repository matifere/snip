import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:snip/Cubit/snippet_cubit.dart';
import 'package:snip/app_constants.dart';
import 'package:snip/snippet_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/highlight_core.dart';

class CreateSnippetPage extends StatefulWidget {
  const CreateSnippetPage({super.key});

  @override
  State<CreateSnippetPage> createState() => _CreateSnippetPageState();
}

class _CreateSnippetPageState extends State<CreateSnippetPage> {
  final client = Supabase.instance.client;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController titleControl = TextEditingController();

  final CodeController _codeController = CodeController(language: dart);

  var dropSnips = [
    DropdownMenuItem(value: 'Dart', child: Text('Dart')),
    DropdownMenuItem(value: 'JavaScript', child: Text('JavaScript')),
    DropdownMenuItem(value: 'Python', child: Text('Python')),
    DropdownMenuItem(value: 'Rust', child: Text('Rust')),
    DropdownMenuItem(value: 'Java', child: Text('Java')),
    DropdownMenuItem(value: 'Haskell', child: Text('Haskell')),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SnippetCubit(),
      child: BlocBuilder<SnippetCubit, Mode>(
        builder: (context, lang) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                spacing: 8,
                children: [Icon(Icons.code), Text('Snip')],
              ),
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
                                      key: ValueKey(lang),
                                      initialValue: deModeAString(lang),
                                      hint: Text('Select a language'),
                                      items: dropSnips,
                                      onChanged: (value) {
                                        context.read<SnippetCubit>().selectLang(
                                          value!,
                                        );
                                      },
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
                        FilledButton(
                          onPressed: () async {
                            await postNewSnippet(
                              titleControl.text,
                              _codeController.text,
                              deModeAString(lang),
                            );
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String deModeAString(Mode lang) {
    return languageMap.keys.firstWhere(
      (key) => languageMap[key] == lang,
      orElse: () => 'Dart',
    );
  }

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
