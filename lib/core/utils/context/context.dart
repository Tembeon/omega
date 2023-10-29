/// Context is a key-value storage for passing data between middlewares and handlers.
abstract final class Context {
  static Context? _root;
  static UnmodifiableContext get root => UnmodifiableContext(_root ?? _rootIsNotSet());

  static Never _rootIsNotSet() => throw Exception('Root context is not set');

  static void setRoot(Context context) {
    if (_root != null) {
      throw Exception('Root context is already set');
    }
    _root = context;
  }

  /// Puts value to context.
  void operator []=(String key, Object value);

  /// Returns value from context.
  Object operator [](String key);

  Map<String, Object> toMap();

  /// Creates new empty context.
  factory Context.empty() => _Context(Map());

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

  @override
  Map<String, Object> toMap() => _map;

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

  @override
  Map<String, Object> toMap() => _context.toMap();
}
