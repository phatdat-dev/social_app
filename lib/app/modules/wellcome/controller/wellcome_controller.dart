import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/services/translation_service.dart';

class WellComeController extends BaseController {
  @override
  Future<void> onInitData() async {
    TranslationService.changeLocale(TranslationService.getLocaleFromLanguage());
  }

  int counter = 0;

  void increment() {
    counter++;
    update();
  }

  void decrement() {
    counter--;
    update();
  }
}
