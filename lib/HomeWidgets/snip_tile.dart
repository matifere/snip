import 'package:flutter/material.dart';
import 'package:snip/OnSnippet/snip_page.dart';
import 'package:snip/snippet_class.dart';

class SnipTile extends StatelessWidget {
  const SnipTile({super.key, required this.snip});
  final SnippetClass snip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => SnipPage(snip: snip)));
        },
        child: ListTile(
          leading: Icon(Icons.code),
          title: Hero(
            tag: snip.id.toString(),
            child: Text(
              snip.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ),
    );
  }
}
