import 'dart:collection';

abstract final class Context {
  /// Puts value to context.
  void operator []=(String key, Object value);

  /// Returns value from context.
  Object operator [](String key);

  /// Creates empty context.
  factory Context.empty() => _Context(HashMap.identity());
}

final class _Context implements Context {
  const _Context(this._map);

  /// Stores context data.
  final HashMap<String, Object> _map;

  @override
  Object operator [](String key) => _map[key] ?? _throwKeyNotFound(key);

  @override
  void operator []=(String key, Object value) => _map[key] = value;

  Never _throwKeyNotFound(String key) => throw Exception('Key $key not found in context');
}
