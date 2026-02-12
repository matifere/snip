import 'package:flutter/material.dart';
import 'package:snip/HomeWidgets/create_snippet_page.dart';
import 'package:snip/HomeWidgets/snips_container.dart';
import 'package:snip/snippet_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 8, children: [Icon(Icons.code), Text('Snip')]),
      ),
      body: Center(
        child: Column(
          spacing: 16,
          children: [
            Text('Home', style: Theme.of(context).textTheme.displayLarge),
            FutureBuilder(
              future: obtenerTabla(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (asyncSnapshot.hasError) {
                  return Text('Error: ${asyncSnapshot.error}');
                }
                return SnipsContainer(snips: asyncSnapshot.data ?? []);
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

  Future<List<SnippetClass>> obtenerTabla() async {
    final listaSupa = await client.from('snippets').select();
    return listaSupa.map((mapa) => SnippetClass.fromJson(mapa)).toList();
  }
}
