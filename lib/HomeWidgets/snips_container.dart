import 'package:flutter/material.dart';
import 'package:snip/HomeWidgets/snip_tile.dart';
import 'package:snip/snippet_class.dart';

class SnipsContainer extends StatelessWidget {
  const SnipsContainer({super.key, required this.snips});
  final List<SnippetClass> snips;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 900,
      child: Card(
        child: ListView.builder(
          itemCount: snips.length,
          itemBuilder: (context, index) {
            return SnipTile(snip: snips[index]);
          },
        ),
      ),
    );
  }
}
