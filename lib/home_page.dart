import 'package:flutter/material.dart';
import 'package:snip/HomeWidgets/create_snippet_page.dart';
import 'package:snip/HomeWidgets/snips_container.dart';
import 'package:snip/login_page.dart';
import 'package:snip/snippet_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final client = Supabase.instance.client;

  final TextEditingController searchControll = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 8, children: [Icon(Icons.code), Text('Snip')]),
        actions: [
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();

              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          spacing: 16,
          children: [
            Text('Home', style: Theme.of(context).textTheme.displayLarge),
            SizedBox(
              width: 900,
              child: TextFormField(
                controller: searchControll,
                decoration: InputDecoration(hintText: 'Search'),
              ),
            ),
            StreamBuilder(
              stream: obtenerTabla(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (asyncSnapshot.hasError) {
                  return Text('Error: ${asyncSnapshot.error}');
                }
                return ValueListenableBuilder(
                  valueListenable: searchControll,
                  builder: (context, textValue, _) {
                    var list = asyncSnapshot.data!
                        .where(
                          (value) => value.title.toLowerCase().contains(
                            textValue.text.toLowerCase(),
                          ),
                        )
                        .toList();
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'Nothing here...',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      );
                    }
                    return SnipsContainer(snips: list);
                  },
                );
              },
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateSnippetPage()),
                );
              },
              child: Text('New Snippet'),
            ),
          ],
        ),
      ),
    );
  }

  //sin realtime:
  //Future<List<SnippetClass>> obtenerTabla() async {
  //    final listaSupa = await client.from('snippets').select();
  //return listaSupa.map((mapa) => SnippetClass.fromJson(mapa)).toList();
  //}

  Stream<List<SnippetClass>> obtenerTabla() {
    final listaSupa = client.from('snippets').stream(primaryKey: ['id']);
    return listaSupa.map((listaDeMapas) {
      return listaDeMapas.map((mapa) => SnippetClass.fromJson(mapa)).toList();
    });
  }
}
