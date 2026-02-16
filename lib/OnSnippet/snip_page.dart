import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/dart.dart';
import 'package:snip/Cubit/snippet_cubit.dart';
import 'package:snip/Cubit/title_cubit.dart';
import 'package:snip/app_constants.dart';
import 'package:snip/snippet_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SnipPage extends StatefulWidget {
  const SnipPage({super.key, required this.snip});
  final SnippetClass snip;

  @override
  State<SnipPage> createState() => _SnipPageState();
}

class _SnipPageState extends State<SnipPage> {
  final SupabaseClient client = Supabase.instance.client;

  final List<DropdownMenuItem<String>> dropSnips = [
    DropdownMenuItem(value: 'Dart', child: Text('Dart')),
    DropdownMenuItem(value: 'JavaScript', child: Text('JavaScript')),
    DropdownMenuItem(value: 'Python', child: Text('Python')),
    DropdownMenuItem(value: 'Rust', child: Text('Rust')),
    DropdownMenuItem(value: 'Java', child: Text('Java')),
    DropdownMenuItem(value: 'Haskell', child: Text('Haskell')),
    DropdownMenuItem(value: 'SQL', child: Text('SQL')),
  ];

  final TextEditingController titleControl = TextEditingController();
  CodeController _codeController = CodeController();
  @override
  void initState() {
    super.initState();
    // Inicializamos con los datos que vienen "de fábrica" en el snippet
    _codeController = CodeController(
      text: widget.snip.content, // Texto inicial
      language: languageMap[widget.snip.language], // Lenguaje inicial
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 8, children: [Icon(Icons.code), Text('Snip')]),
      ),

      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                SnippetCubit(languageMap[widget.snip.language] ?? dart),
          ),
          BlocProvider(create: (_) => TitleCubit(widget.snip.title)),
        ],
        child: BlocBuilder<TitleCubit, String>(
          builder: (context, title) {
            return BlocBuilder<SnippetCubit, Mode>(
              builder: (context, lang) {
                _codeController.language = lang;
                List<SizedBox> propiedades = [
                  //en el futuro agregar tags aqui
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField(
                      key: ValueKey(lang),
                      initialValue: deModeAString(lang),
                      hint: Text('Select a language'),
                      items: dropSnips,
                      onChanged: (value) {
                        context.read<SnippetCubit>().selectLang(value!);
                      },
                    ),
                  ),
                ];
                List<ButtonStyleButton> acciones = [
                  FilledButton(
                    onPressed: () async {
                      await deleteSnippet(widget.snip.id ?? 0, context);
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: Text('Delate'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      widget.snip.language = deModeAString(lang);
                      widget.snip.title = title;
                      widget.snip.content = _codeController.text;
                      await updateSnippet(context, widget.snip);
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ];
                return Center(
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: widget.snip.id.toString(),
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                          EditTitleButton(titleControl: titleControl),
                        ],
                      ),
                      SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width * 0.7 > 500
                            ? MediaQuery.of(context).size.width * 0.7
                            : MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 8,
                              children: [
                                MediaQuery.of(context).size.width * 0.7 > 650
                                    ? Row(
                                        spacing: 16,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: propiedades,
                                      )
                                    : Column(
                                        spacing: 16,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: propiedades,
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
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: acciones,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String deModeAString(Mode lang) {
    return languageMap.keys.firstWhere(
      (key) => languageMap[key] == lang,
      orElse: () => 'Dart',
    );
  }

  Future<void> deleteSnippet(int id, BuildContext context) async {
    try {
      await client.from('snippets').delete().eq('id', id);
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  Future<void> updateSnippet(BuildContext context, SnippetClass upSnip) async {
    try {
      await client
          .from('snippets')
          .update(upSnip.toRequiredSupaJson())
          .eq('id', upSnip.id ?? 0);
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }
}

class EditTitleButton extends StatelessWidget {
  const EditTitleButton({super.key, required this.titleControl});

  final TextEditingController titleControl;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final TitleCubit titleCubit = context.read<TitleCubit>();
        titleControl.text = titleCubit.state;
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change Title',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(controller: titleControl),
                  ),
                  Row(
                    spacing: 16,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          //actualizar dato en pantalla
                          titleCubit.setTitle(titleControl.text);
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
      icon: Icon(Icons.edit),
    );
  }
}
