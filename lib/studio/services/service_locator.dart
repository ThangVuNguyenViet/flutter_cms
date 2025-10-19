import 'dart:async';
import 'studio_state_service.dart';

/// Service locator pattern for dependency injection in CMS Studio
/// Provides a simple way to register and retrieve service instances
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  static ServiceLocator get instance => _instance;

  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};
  final Map<Type, Function()> _factories = {};
  final Map<Type, Function()> _singletonFactories = {};
  final Set<Type> _initialized = {};

  /// Register a singleton service instance
  void registerSingleton<T>(T service) {
    _services[T] = service;
  }

  /// Register a factory that creates new instances each time
  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  /// Register a lazy singleton that is created on first access
  void registerLazySingleton<T>(T Function() factory) {
    _singletonFactories[T] = factory;
  }

  /// Get a service instance
  T get<T>() {
    // Check if singleton already exists
    if (_services.containsKey(T)) {
      return _services[T] as T;
    }

    // Check if lazy singleton factory exists
    if (_singletonFactories.containsKey(T)) {
      final factory = _singletonFactories[T]!;
      final instance = factory() as T;
      _services[T] = instance;
      return instance;
    }

    // Check if factory exists
    if (_factories.containsKey(T)) {
      final factory = _factories[T]!;
      return factory() as T;
    }

    throw ServiceNotRegisteredException(T);
  }

  /// Try to get a service instance, returns null if not found
  T? tryGet<T>() {
    try {
      return get<T>();
    } on ServiceNotRegisteredException {
      return null;
    }
  }

  /// Check if a service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T) ||
        _factories.containsKey(T) ||
        _singletonFactories.containsKey(T);
  }

  /// Unregister a service
  void unregister<T>() {
    _services.remove(T);
    _factories.remove(T);
    _singletonFactories.remove(T);
    _initialized.remove(T);
  }

  /// Clear all registered services (useful for testing)
  void clear() {
    _services.clear();
    _factories.clear();
    _singletonFactories.clear();
    _initialized.clear();
  }

  /// Initialize a service if it implements Initializable
  Future<void> initialize<T>() async {
    if (_initialized.contains(T)) {
      return; // Already initialized
    }

    final service = get<T>();
    if (service is Initializable) {
      await service.initialize();
      _initialized.add(T);
    }
  }

  /// Initialize all registered services that implement Initializable
  Future<void> initializeAll() async {
    final futures = <Future<void>>[];

    // Register core state service if not already registered
    if (!isRegistered<StudioStateService>()) {
      registerSingleton<StudioStateService>(StudioStateService.instance);
    }

    // Initialize singletons
    for (final type in _services.keys) {
      final service = _services[type];
      if (service is Initializable && !_initialized.contains(type)) {
        futures.add(service.initialize().then((_) => _initialized.add(type)));
      }
    }

    // Initialize lazy singletons
    for (final type in _singletonFactories.keys) {
      if (!_initialized.contains(type)) {
        final service = get<dynamic>();
        if (service is Initializable) {
          futures.add(service.initialize().then((_) => _initialized.add(type)));
        }
      }
    }

    await Future.wait(futures);
  }

  /// Dispose all services that implement Disposable
  Future<void> disposeAll() async {
    final futures = <Future<void>>[];

    for (final service in _services.values) {
      if (service is Disposable) {
        futures.add(service.dispose());
      }
    }

    await Future.wait(futures);
    clear();
  }

  /// Get all registered service types
  List<Type> get registeredTypes {
    final types = <Type>{};
    types.addAll(_services.keys);
    types.addAll(_factories.keys);
    types.addAll(_singletonFactories.keys);
    return types.toList();
  }

  /// Get registration info for debugging
  Map<String, String> get registrationInfo {
    final info = <String, String>{};

    for (final type in _services.keys) {
      info[type.toString()] = 'Singleton Instance';
    }

    for (final type in _factories.keys) {
      info[type.toString()] = 'Factory';
    }

    for (final type in _singletonFactories.keys) {
      info[type.toString()] = 'Lazy Singleton';
    }

    return info;
  }
}

/// Interface for services that need initialization
abstract class Initializable {
  Future<void> initialize();
}

/// Interface for services that need cleanup
abstract class Disposable {
  Future<void> dispose();
}

/// Exception thrown when trying to get an unregistered service
class ServiceNotRegisteredException implements Exception {
  ServiceNotRegisteredException(this.type);

  final Type type;

  @override
  String toString() => 'Service of type $type is not registered';
}

/// Helper extension for easier service access
extension ServiceLocatorExtension on Type {
  /// Get service instance for this type
  T get<T>() => ServiceLocator.instance.get<T>();

  /// Try to get service instance for this type
  T? tryGet<T>() => ServiceLocator.instance.tryGet<T>();

  /// Check if this type is registered
  bool get isRegistered => ServiceLocator.instance.isRegistered<Type>();
}