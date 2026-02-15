import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/dart.dart';
import 'package:snip/app_constants.dart';

class SnippetCubit extends Cubit<Mode> {
  SnippetCubit() : super(dart);
  void selectLang(String lang) {
    emit(languageMap[lang] ?? dart);
  }
}
