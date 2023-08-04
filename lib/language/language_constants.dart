import 'package:offline_classes/language/language_model.dart';

class LanguageConstants {
  static const COUNTRY_CODE = 'country_code';
  static const LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
      countryCode: 'US',
      languageName: 'English',
      languageCode: 'en',
    ),
    LanguageModel(
      countryCode: 'IN',
      languageName: 'हिन्दी',
      languageCode: 'hi',
    ),
  ];
}
