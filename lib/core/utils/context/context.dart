/// Context is a key-value storage for passing data between middlewares and handlers.
abstract final class Context {
  /// Puts value to context.
  void operator []=(String key, Object value);

  /// Returns value from context.
  Object operator [](String key);

  /// Creates new empty context.
  factory Context.empty() => _Context(Map.identity());

  /// Creates new context from [map].
  factory Context.from(Map<String, Object> map) => _Context(map);
}

final class _Context implements Context {
  const _Context(this._map);

  /// Stores context data.
  final Map<String, Object> _map;

  @override
  Object operator [](String key) => _map[key] ?? _throwKeyNotFound(key);

  @override
  void operator []=(String key, Object value) => _map[key] = value;

  Never _throwKeyNotFound(String key) => throw Exception('Key $key not found in context');
}

final class UnmodifiableContext implements Context {
  const UnmodifiableContext(this._context);

  /// Stores context data.
  final Context _context;

  @override
  Object operator [](String key) => _context[key];

  @override
  void operator []=(String key, Object value) => throw Exception('Context is unmodifiable');
}
