import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';

import '../../../constant.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleInitial());

  bool changeLocaleToEnglish() {
    emit(LocaleChangedtoEnglish());
    Prefs.setString(Klocale, "en");
    return true;
  }

  bool changeLocaleToArabic() {
    emit(LocaleChangedtoArabic());
    Prefs.setString(Klocale, "ar");
    return true;
  }
}
