import 'package:flutter/material.dart';
import 'package:snip/snippet_class.dart';

class SnipPage extends StatelessWidget {
  const SnipPage({super.key, required this.snip});
  final SnippetClass snip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 8, children: [Icon(Icons.code), Text('Snip')]),
      ),

      body: Center(
        child: Column(
          children: [
            Hero(
              tag: snip.id.toString(),
              child: Text(
                snip.title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
