library lifecycle;

/// Mixin to track Lifecycle of a object
abstract class LifecycleTracker {
  DateTime _createdAt;
  DateTime _updatedAt;

  void createTimestamp() => _createdAt = DateTime.now();
  void updateTimestamp() => _updatedAt = DateTime.now();

  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;
}
