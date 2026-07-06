// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

class LanguagePreferenceStore {
  static const _storageKey = 'list_monster_app_language';

  Future<String?> readLanguageCode() async {
    return html.window.localStorage[_storageKey];
  }

  Future<void> writeLanguageCode(String code) async {
    html.window.localStorage[_storageKey] = code;
  }
}
