import 'package:flutter_bloc/flutter_bloc.dart';

class TitleCubit extends Cubit<String> {
  TitleCubit(super.tituloInicial);
  void setTitle(String newTitle) {
    emit(newTitle);
  }
}
