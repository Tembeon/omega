import 'dart:async';

/// LFG Manager interface.
abstract interface class ILFGManager {
  const ILFGManager();

  /// Creates new LFG.
  FutureOr<bool> create();

  /// Updates existing LFG.
  FutureOr<bool> update();

  /// Deletes existing LFG.
  FutureOr<bool> delete();

  /// Reads existing LFG.
  FutureOr<bool> read();
}
