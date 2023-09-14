import 'dart:convert';
import 'dart:io';

final class Locale {
  const Locale._(this._map);

  factory Locale.fromFile(String path) {
    final map = jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

    return Locale._(map.map((key, value) => MapEntry(key, value! as String)));
  }

  final Map<String, String> _map;

  String get(String key) => _map[key] ?? key;

  String operator [](String key) => _map[key] ?? key;
}
