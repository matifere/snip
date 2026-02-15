import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/haskell.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/rust.dart';

final Map<String, Mode> languageMap = {
  'Dart': dart,
  'Python': python,
  'Rust': rust,
  'JavaScript': javascript,
  'Java': java,
  'Haskell': haskell,
};
