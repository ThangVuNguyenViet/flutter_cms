# Signals.dart Expert

You are an expert in Signals.dart, a reactive state management library for Dart and Flutter applications.

## Overview

Signals.dart is a reactive primitive library (not a framework) that works across Dart VM, WASM, Flutter, and server environments. It provides a complete reactivity system based on fine-grained reactive primitives.

## Installation

**For Flutter projects:**
```bash
flutter pub add signals
```

**For Dart projects:**
```bash
dart pub add signals
```

**Import usage:**
```dart
// For Dart projects
import 'package:signals/signals.dart';

// For Flutter projects (includes ValueNotifier/ValueListenable compatibility)
import 'package:signals/signals_flutter.dart';
```

## Core Concepts

### Signal - Reactive State Container

A signal is a reactive container that automatically notifies dependents when its value changes.

**Creating signals:**
```dart
final counter = signal(0);
final name = signal("Jane");
```

**Reading and writing:**
```dart
print(counter.value); // Read: 0
counter.value = 1;    // Write: updates all dependents
```

**Non-reactive reads:**
```dart
counter.peek(); // Read previous value without creating dependencies
```

**Force updates:**
```dart
signal.set(value, force: true); // Forces update even if value is same
```

**Lifecycle management:**
```dart
signal.onDispose(() => print('cleaned up'));
signal.dispose(); // Freezes value and stops tracking
final isDisposed = signal.disposed; // Check disposal status
```

### Computed - Derived Values

Computed signals automatically derive values from other signals and update when dependencies change.

**Basic usage:**
```dart
final name = signal("Jane");
final surname = signal("Doe");
final fullName = computed(() => name.value + " " + surname.value);
```

**Force recomputation:**
```dart
fullName.recompute(); // Manually trigger recalculation
```

**Auto-disposal:**
```dart
final computed = computed(
  () => name.value,
  autoDispose: true, // Disposes when no listeners remain
);
```

### Effect - Side Effects

Effects execute side effects when their dependencies change.

**Basic effect:**
```dart
final name = signal("Jane");
effect(() => print(name.value)); // Prints whenever name changes
```

**With disposal:**
```dart
final dispose = effect(() => print(name.value));
dispose(); // Stop the effect
```

**With cleanup:**
```dart
// Cleanup function returned from effect
effect(() {
  print(s.value);
  return () => print('Effect destroyed');
});

// Or with onDispose callback
effect(
  () => print(s.value),
  onDispose: () => print('Effect destroyed')
);
```

**Critical warning:** Never mutate a signal inside an effect without using `untracked()` - this causes infinite loops.

### Untracked - Non-reactive Reads

Read signal values without creating dependencies:

```dart
final counter = signal(0);
final effectCount = signal(0);

effect(() {
  print(counter.value); // Tracked
  effectCount.value = untracked(() => effectCount.value + 1); // Not tracked
});
```

### Batch - Optimize Multiple Updates

Batch multiple signal updates into a single update cycle:

```dart
batch(() {
  name.value = "Foo";
  surname.value = "Bar";
}); // Effects trigger once with both changes
```

Benefits:
- Deferred updates until batch completes
- Smart dependency resolution
- Supports nested batches

## Flutter Integration

### Watch Widget

The `Watch` widget rebuilds only itself when signals change:

```dart
Watch((context) {
  return Text('Count: ${counter.value}');
});
```

**With child optimization:**
```dart
Watch.builder(
  builder: (context, child) {
    return Column(
      children: [
        Text('Count: ${counter.value}'),
        child!, // This doesn't rebuild
      ],
    );
  },
  child: ExpensiveWidget(),
);
```

### Extension Method (not recommended)

```dart
Text('Count: ${counter.watch(context)}')
```

Note: Use `Watch` widget instead - it unsubscribes immediately on disposal vs waiting for garbage collection.

### SignalProvider

Share signals across widget tree using InheritedNotifier:

```dart
// Create a signal class
class Counter extends FlutterSignal<int> {
  Counter() : super(0);
}

// Provide it
SignalProvider<Counter>(
  create: () => Counter(),
  child: MyApp(),
);

// Access it
final counter = SignalProvider.of<Counter>(context); // Listens to changes
final counter = SignalProvider.of<Counter>(context, listen: false); // No rebuild
```

### SignalsMixin

Automatic signal disposal in StatefulWidget:

```dart
class _MyWidgetState extends State<MyWidget> with SignalsMixin {
  late final count = createSignal(0);
  late final isEven = createComputed(() => count.value.isEven);
  late final list = createListSignal([1, 2, 3]);

  @override
  void initState() {
    super.initState();
    // Effects must be in initState, not as late fields
    createEffect(() => print('Count: ${count.value}'));
  }
}
```

### Flutter Hooks

```dart
import 'package:signals/signals_flutter.dart';

Widget build(BuildContext context) {
  final count = useSignal(0);
  final doubled = useComputed(() => count.value * 2);

  useSignalEffect(() {
    print('Count: ${count.value}');
  });

  // Async hooks
  final future = useFutureSignal(() async => fetchData());
  final stream = useStreamSignal(() => dataStream);

  // Collection hooks
  final list = useListSignal([1, 2, 3]);
  final map = useMapSignal({'key': 'value'});
  final set = useSetSignal({1, 2, 3});

  return Text('Count: ${count.value}');
}
```

### ValueNotifier/ValueListenable Compatibility

Signals created with Flutter import automatically implement ValueNotifier/ValueListenable:

```dart
final count = signal(0);
final ValueNotifier<int> notifier = count; // Works!

// Convert existing ValueNotifier to signal
final existingNotifier = ValueNotifier(10);
final signal = existingNotifier.toSignal(); // Bidirectional sync

// Convert ValueListenable to signal
final ValueListenable listenable = /* ... */;
final signal = listenable.toSignal();
```

### DevTools

Signals.dart includes an early-stage DevTools extension with:
- Graph view of signal dependencies
- List view of all signals
- State inspection

## Async Signals

### FutureSignal

Wrap futures with reactive state:

```dart
// Create from callback
final future = futureSignal(() async => fetchData());

// Convert existing future
final future = Future(() => fetchData()).toSignal();

// With dependencies (re-executes when deps change)
final count = signal(0);
final future = futureSignal(
  () async => fetchDataForCount(count.value),
  dependencies: [count],
);
```

**State management:**
```dart
future.value; // Returns AsyncState<T>
future.reset(); // Return to initial state
future.refresh(); // Keep state, set isLoading = true
future.reload(); // Reset to AsyncLoading with preserved value/error
```

### StreamSignal

Wrap streams with reactive state:

```dart
// Create from callback
final stream = streamSignal(() => dataStream);

// Convert existing stream
final stream = dataStream.toSignal();

// With dependencies
final stream = streamSignal(
  () async* { yield count.value; },
  dependencies: [count],
);
```

**State management:** Same methods as FutureSignal (reset, refresh, reload)

### AsyncState

Sealed union class representing async states:

```dart
// Create states
final loading = AsyncState<int>.loading();
final data = AsyncState.data(42);
final error = AsyncState<int>.error('Error', stackTrace);

// Check state
if (state.isLoading) { ... }
if (state.hasValue) { ... }
if (state.hasError) { ... }
if (state.isRefreshing) { ... } // Loading with existing value/error
if (state.isReloading) { ... } // Loading with prior value/error

// Access data
final value = state.value; // Nullable
final value = state.requireValue; // Throws if null/error
final err = state.error;
final stack = state.stackTrace;

// Pattern matching
state.map(
  loading: () => CircularProgressIndicator(),
  data: (value) => Text('$value'),
  error: (error, stackTrace) => Text('Error: $error'),
);

// Or use switch expressions
return switch (state) {
  AsyncLoading() => CircularProgressIndicator(),
  AsyncData(:final value) => Text('$value'),
  AsyncError(:final error) => Text('Error: $error'),
};
```

### Async Computed

```dart
// computedAsync - syntax sugar around FutureSignal
final movieId = signal('id');
final movie = computedAsync(() => fetchMovie(movieId.value));
// Note: Access signal values BEFORE any await statements

// computedFrom - explicit dependencies
final movie = computedFrom(
  [movieId],
  (args) => fetchMovie(args.first), // No await timing issues
);
```

### Connect - Stream to Signal

Feed streams into signals:

```dart
final s = signal(0);
final c = connect(s);

// Add streams
final stream1 = Stream.value(1);
final stream2 = Stream.value(2);
c.from(stream1).from(stream2);
// Or: c << stream1 << stream2;

// Cleanup
c.dispose();
```

## Value Signals (Collections)

### ListSignal

Reactive lists with standard List interface:

```dart
final list = listSignal([1, 2, 3]);
// Or: final list = [1, 2, 3].toSignal();

list[0] = -1; // Triggers updates
list.add(4);
list.addAll([5, 6]);
print(list.first);
print(list.length);

// Custom operators
final intersection = list & [3, 4, 5];
```

### MapSignal

Reactive maps with standard Map interface:

```dart
final map = mapSignal({'a': 1, 'b': 2});
// Or: final map = {'a': 1}.toSignal();

map['a'] = -1;
map.addAll({'c': 3});
map.remove('b');
print(map.keys);
```

### SetSignal

Reactive sets with standard Set interface:

```dart
final set = setSignal({1, 2, 3});
// Or: final set = {1, 2, 3}.toSignal();

set.add(4);
set.remove(1);
print(set.length);
print(set.contains(2));
final intersection = set.intersection({2, 3, 4});
```

## Advanced Patterns

### SignalsContainer

Create signals dynamically based on arguments:

```dart
// Without caching (creates new signal each time)
final counters = signalContainer<int, int>((id) => signal(id));
final counter1 = counters(1);
final counter2 = counters(2);

// With caching (returns same signal for same args)
final cachedCounters = signalContainer<int, int>(
  (id) => signal(id),
  cache: true,
);

// Practical example with persisted settings
final setting = signalContainer<String, (String, String)>(
  (args) {
    final (key, defaultValue) = args;
    return signal(prefs.getString(key) ?? defaultValue);
  },
  cache: true,
);
```

### Persisted Signals

Store signal state across app sessions:

```dart
// Define storage interface
abstract class KeyValueStore {
  Future<void> setItem(String key, String value);
  Future<String?> getItem(String key);
  Future<void> removeItem(String key);
}

// Implement persisted signal
class PersistedSignal<T> extends FlutterSignal<T>
    with PersistedSignalMixin<T> {
  PersistedSignal(
    this.key,
    T defaultValue, {
    required this.store,
  }) : super(defaultValue);

  @override
  final String key;

  @override
  final KeyValueStore store;

  @override
  String encode(T value) => value.toString();

  @override
  T decode(String serialized) => /* parse serialized */;
}

// Usage
final setting = PersistedSignal('theme', 'light', store: myStore);
```

**Custom serialization:**
```dart
// For enums
@override
String encode(MyEnum value) => value.name;

@override
MyEnum decode(String s) => MyEnum.values.byName(s);

// For colors
@override
String encode(Color value) => value.value.toString();

@override
Color decode(String s) => Color(int.parse(s));
```

### Bi-directional Data Flow

Use `untracked()` to break circular dependencies:

```dart
final a = signal(0);
final b = signal(0);

// Without untracked: infinite loop!
// With untracked: safe bi-directional flow
effect(() {
  b.value = untracked(() => a.value + 1);
});

effect(() {
  a.value = untracked(() => b.value + 1);
});
```

**Important:** Use sparingly and only when necessary - can lead to complex behavior.

### SignalsObserver

Monitor all signal updates globally:

```dart
class MyObserver extends SignalsObserver {
  @override
  void onSignalCreated(Signal signal) {
    print('Signal created: $signal');
  }

  @override
  void onSignalUpdated(Signal signal, dynamic value) {
    print('Signal updated: $signal = $value');
  }

  @override
  void onComputedCreated(Computed computed) { }

  @override
  void onComputedUpdated(Computed computed, dynamic value) { }
}

void main() {
  // Only enable in debug/profile builds - performance overhead!
  SignalsObserver.instance = LoggingSignalsObserver();
  // Or custom: SignalsObserver.instance = MyObserver();

  runApp(MyApp());
}

// Disable
SignalsObserver.instance = null;
```

## Dependency Injection Patterns

Signals work with any DI solution:

**Provider:**
```dart
Provider<CounterSignal>(
  create: (_) => signal(0),
  dispose: (_, s) => s.dispose(),
  child: MyApp(),
);
```

**GetIt:**
```dart
final getIt = GetIt.instance;
getIt.registerSingleton(signal(0));
```

**Riverpod:**
```dart
@riverpodSignal
Signal<int> counter(CounterRef ref) => signal(0);
```

**InheritedWidget:** Use `SignalProvider` (shown earlier)

**Global signals:**
```dart
final globalCounter = signal(0);
// Not recommended for large apps - manual lifecycle management required
```

## Testing

### Convert to Stream

```dart
test('signal updates', () async {
  final s = signal(0);
  final stream = s.toStream();

  s.value = 1;
  s.value = 2;

  await expectLater(stream, emitsInOrder([0, 1, 2]));
});
```

### Override Values

```dart
test('with mocked value', () {
  final s = signal(0);
  final overridden = s.overrideWith(42);

  expect(overridden.value, 42);
});
```

## Best Practices

1. **Use `Watch` instead of `.watch(context)`** - Better disposal management
2. **Never mutate signals inside effects** - Use `untracked()` if needed
3. **Use `batch()` for multiple updates** - Better performance
4. **Prefer `computedFrom()` over `computedAsync()`** - No await timing issues
5. **Enable `SignalsObserver` only in debug** - Performance overhead
6. **Use `SignalsMixin` in StatefulWidget** - Automatic disposal
7. **Put effects in `initState()`** - Not as late fields
8. **Use `autoDispose: true` sparingly** - Explicit is usually better
9. **Access signal values BEFORE await** - In `computedAsync()` callbacks
10. **Use persisted signals for settings** - Initialize before app starts

## Common Patterns

### Loading state with future:
```dart
final data = futureSignal(() => api.fetchData());

Watch((context) {
  return data.value.map(
    loading: () => CircularProgressIndicator(),
    data: (value) => DataWidget(value),
    error: (err, _) => ErrorWidget(err),
  );
});
```

### Form validation:
```dart
final email = signal('');
final isValidEmail = computed(() =>
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.value)
);

TextField(
  onChanged: (value) => email.value = value,
  decoration: InputDecoration(
    errorText: Watch((context) =>
      isValidEmail.value ? null : 'Invalid email'
    ),
  ),
)
```

### Reactive list filtering:
```dart
final items = listSignal(['apple', 'banana', 'cherry']);
final filter = signal('');
final filtered = computed(() =>
  items.where((item) => item.contains(filter.value)).toList()
);
```

### Debounced search:
```dart
final searchTerm = signal('');
final debouncedSearch = computed(() => searchTerm.value);

effect(() {
  final term = debouncedSearch.value;
  Timer(Duration(milliseconds: 300), () {
    if (term == searchTerm.value) {
      performSearch(term);
    }
  });
});
```

## Migration from Other Solutions

### From ValueNotifier:
- Replace `ValueNotifier` with `signal`
- Use `.toSignal()` extension for gradual migration
- Signals work cross-platform (not just Flutter)

### From Provider:
- Replace `ChangeNotifier` with signals
- Use `Watch` instead of `Consumer`
- Use `SignalProvider` for scoped signals

### From Riverpod:
- Replace providers with signals
- Use computed for derived state
- Use effects for side effects

### From BLoC:
- Replace streams with signals
- Replace StreamBuilder with `Watch`
- Use `streamSignal` to wrap existing streams

## Key Differences from Other Libraries

- **SolidJS-inspired** - Similar API to Solid.js signals
- **Framework-agnostic** - Works in Dart VM, Flutter, web, server
- **Fine-grained reactivity** - Only rebuilds what changed
- **Zero dependencies** - Pure Dart implementation
- **No code generation** - Works without build_runner
- **ValueNotifier compatible** - Drop-in replacement in Flutter
- **Lazy evaluation** - Computed signals only recalculate when read
- **Automatic cleanup** - With SignalsMixin and hooks

## Resources

- Documentation: https://dartsignals.dev
- GitHub: https://github.com/rodydavis/signals.dart
- Pub.dev: https://pub.dev/packages/signals
- LLM-friendly docs: https://dartsignals.dev/llms.txt

## When to Use Signals

Use signals when you need:
- Fine-grained reactivity
- Cross-platform state management
- Simple, composable state primitives
- Minimal boilerplate
- Automatic dependency tracking
- Integration with existing Flutter code (ValueNotifier)

Avoid signals when:
- You need time-travel debugging (use Redux/BLoC)
- You need middleware/interceptors (use BLoC)
- Your team is unfamiliar with reactive primitives
- You need extensive DevTools support (immature in signals)
