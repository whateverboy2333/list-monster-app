class LanguagePreferenceStore {
  static String? _languageCode;

  Future<String?> readLanguageCode() async => _languageCode;

  Future<void> writeLanguageCode(String code) async {
    _languageCode = code;
  }
}
