# Solidart State Management

Solidart is a reactive state-management library for Dart and Flutter applications. This skill covers all core concepts and patterns.

## Signal

Signals are the cornerstone of reactivity in solidart. They hold values that change over time. When a signal's value updates, anything depending on it automatically refreshes.

### Creating a Signal

```dart
final counter = Signal(0);
```

### Accessing and Modifying Values

```dart
// Read value
print(counter.value);

// Set value
counter.value = 2;

// Update based on current value
counter.updateValue((value) => value * 2);

// Shorthand syntax to read value
print(counter()); // equivalent to counter.value
```

### Read-Only Signals

Convert a signal to read-only using `toReadSignal()`:

```dart
final readOnlyCounter = counter.toReadSignal();
print(readOnlyCounter.value); // Reading works
// readOnlyCounter.value = 2; // Compile-time error
```

### Observation

Monitor changes with `observe()`:

```dart
counter.observe((previousValue, value) {
  print("Counter changed from $previousValue to $value");
});
```

Optional parameter `fireImmediately: true` calls the observer immediately with the current value.

### Previous Value Access

```dart
print(counter.hasPreviousValue); // Boolean check
print(counter.previousValue); // Returns null if none exist
```

Constructor option: `trackPreviousValue: false` disables tracking.

### Conditional Waiting

The `until()` method pauses execution until a condition is satisfied:

```dart
await counter.until((value) => value >= 5, timeout: Duration(seconds: 10));
```

---

## Effect

An Effect is an observer that runs side effects in response to signal changes.

### Creating an Effect

```dart
final disposeEffect = Effect(() {
  print("The count is now ${counter.value}");
});
```

### Behavior

- **Immediate Execution**: Runs immediately upon creation
- **Automatic Subscription**: Subscribes to signals accessed within its callback
- **Reactive Reruns**: Reruns when subscribed signals change

### Disposal

The `Effect` constructor returns a `Dispose` callback:

```dart
disposeEffect(); // Stops listening and clears the effect
```

**Important**: An effect is useless after disposal - do not use it anymore.

---

## Computed

A computed signal depends on other signals and automatically subscribes to them.

### Creating a Computed

```dart
final count = Signal(0);
final doubleCount = Computed(() => count.value * 2);
```

### Key Characteristics

- **Read-only**: Returns a `ReadSignal`
- **Type transformation**: Can transform values to different types
- **Smart re-evaluation**: Only emits when actual output changes

```dart
final counter = Signal(0); // int type
final isGreaterThan5 = Computed(() => counter() > 5); // bool type
```

### Sub-field Subscriptions

Subscribe to specific properties of signal values:

```dart
final user = Signal(const User(name: "name", age: 20));
final age = Computed(() => user().age);
```

This prevents effect reruns when unrelated fields update.

---

## Resource

A Resource is a specialized Signal for handling async loading. It wraps async values and manages their states: **data**, **error**, and **loading**.

### Creating from a Future

```dart
Future<String> fetchUser() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
    headers: {'Accept': 'application/json'},
  );
  return response.body;
}

final user = Resource(fetchUser);
```

### Creating from a Stream

```dart
final stream = Stream.periodic(
  const Duration(seconds: 1),
  (count) => 'Tick: $count',
);
final resource = Resource.stream(() => stream);
```

### Using Resource State in Widgets

```dart
SignalBuilder(
  builder: (context, child) {
    return user.state.when(
      ready: (data) => Text(data),
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => const Text('Loading...'),
    );
  },
)
```

### Dynamic Source Switching

Resources automatically refetch when a source Signal changes:

```dart
final userId = Signal<String?>(null);
late final userData = Resource(
  () => userId.value == null
    ? Future.value(null)
    : getUserData(userId.value),
  source: userId,
);
```

For multiple dependencies, use Computed as the source:

```dart
final page = Signal(1);
final pageSize = Signal(20);
final searchQuery = Signal<String?>(null);

final _queryParams = Computed(() => QueryParams(
  page: page.value,
  pageSize: pageSize.value,
  search: searchQuery.value,
));

final documentsResource = Resource<DocumentListResult>(
  _fetchDocuments,
  source: _queryParams,
  debounceDelay: const Duration(milliseconds: 300),
);
```

### Key Methods & Parameters

| Feature | Description |
|---------|-------------|
| `debounceDelay` | Delays fetcher execution after source changes |
| `refresh()` | Manually refresh the Resource |
| `state` | The current ResourceState (loading, ready, or error) |
| `state.isLoading` | Boolean indicating if loading |
| `state.isReady` | Boolean indicating if data is ready |
| `state.hasError` | Boolean indicating if there's an error |
| `state.value` | The data value (when ready) |
| `state.error` | The error (when hasError) |
| `isRefreshing` | Flag indicating refresh state |
| `useRefreshing` | When true (default), refresh keeps current state |

### ResourceState Methods

```dart
// Pattern matching with when()
resourceState.when(
  ready: (data) => /* widget for ready state */,
  loading: () => /* widget for loading state */,
  error: (error, stackTrace) => /* widget for error state */,
);

// Check state
if (resourceState.isLoading) { ... }
if (resourceState.isReady) { ... }
if (resourceState.hasError) { ... }

// Access value directly (may be null if not ready)
final data = resourceState.value;
```

---

## Batch

Batch queues multiple signal changes and applies them before notifying observers.

```dart
final x = Signal(10);
final y = Signal(20);

Effect(() => print('x = ${x.value}, y = ${y.value}'));
// Output: 'x = 10, y = 20'

batch(() {
  x.value++;
  y.value++;
});
// Output: 'x = 11, y = 21' (only one notification)
```

Without batch, the effect would fire twice with intermediate states.

---

## Untracked

Execute a callback that won't be tracked by the reactive system:

```dart
final count = Signal(0);
final doubleCount = Signal(0);

Effect(() {
  final value = count();
  untracked(() {
    doubleCount.value = value * 2; // This won't trigger the Effect
  });
});
```

Useful for preventing infinite loops or unintended cascading updates.

---

## Show Widget

Conditionally renders content based on signal state:

```dart
Show(
  when: () => count() > 5,
  builder: (context) => const Text('Count is greater than 5'),
  fallback: (context) => const Text('Count is lower than 6'),
)
```

Parameters:
- `when`: Function returning bool
- `builder`: Widget when true
- `fallback`: Optional widget when false (defaults to nothing)

---

## SignalBuilder Widget

Automatically rebuilds when signals used within change:

```dart
SignalBuilder(
  builder: (context, child) {
    return Text(counter.value.toString());
  },
)
```

- Reacts to any number of signals
- Optional `child` parameter for static parts
- By default, asserts if no signals detected (disable with `SolidartConfig.assertSignalBuilderWithoutDependencies = false`)

---

## ListSignal

A signal for managing list values with automatic notifications:

```dart
final items = ListSignal([1, 2]);
items.observe((previousValue, value) {
  print("Items changed: $previousValue -> $value");
});
items.add(3); // prints "Items changed: [1, 2] -> [1, 2, 3]"
items[0] = 10; // prints "Items changed: [1, 2, 3] -> [10, 2, 3]"
```

---

## MapSignal

A signal for managing map values:

```dart
final items = MapSignal({'a': 1, 'b': 2});
items.observe((previousValue, value) {
  print("Items changed: $previousValue -> $value");
});
items['c'] = 3; // Add or update entries
items.remove('a'); // Remove entries
```

---

## SetSignal

A signal for managing set values:

```dart
final items = SetSignal({1, 2});
items.observe((previousValue, value) {
  print("Items changed: $previousValue -> $value");
});
items.add(3); // prints "Items changed: [1, 2] -> [1, 2, 3]"
items.remove(1); // prints "Items changed: [1, 2, 3] -> [2, 3]"
```

---

## Automatic Disposal

By default, `Signal`, `Computed`, `Resource`, and `Effect` dispose automatically when they have no remaining subscribers.

### Disable Per-Object

```dart
final counter = Signal(0, autoDispose: false);
```

### Disable Globally

```dart
SolidartConfig.autoDispose = false;
```

### Manual Disposal Pattern

When Effects watch signals without being disposed, both stay in memory:

```dart
final count = Signal(0);
late final DisposeEffect disposeEffect;

@override
void initState() {
  super.initState();
  disposeEffect = Effect(() {
    print("The count is ${count.value}");
  });
}

@override
void dispose() {
  disposeEffect(); // Dispose the effect
  // Or dispose all signals:
  // count.dispose();
  super.dispose();
}
```

Calling `dispose()` multiple times is safe.

---

## solidart_hooks

Integration with flutter_hooks:

```dart
// Create signals in hooks
final count = useSignal(0);
final doubled = useComputed(() => count.value * 2);

// Effects
useSolidartEffect(() {
  debugPrint('Effect triggered! Count: ${count.value}');
});

// Collection signals
final items = useListSignal<String>(['Item1', 'Item2']);
final uniqueItems = useSetSignal<String>({'Item1', 'Item2'});
final userRoles = useMapSignal<String, String>({'admin': 'John'});

// Resources
final userResource = useResource(() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Data loaded';
});

// Bind existing signals
final boundSignal = useExistingSignal(existingSignal);
```

---

## Common Patterns

### ViewModel Pattern with Resource

```dart
class MyViewModel {
  final ApiClient client;

  final selectedId = Signal<int?>(null);
  late final Resource<MyData?> dataResource;

  MyViewModel(this.client) {
    dataResource = Resource<MyData?>(
      _fetchData,
      source: selectedId,
      debounceDelay: const Duration(milliseconds: 300),
    );
  }

  Future<MyData?> _fetchData() async {
    final id = selectedId.value;
    if (id == null) return null;
    return await client.getData(id);
  }

  void selectItem(int id) {
    selectedId.value = id;
  }

  void refresh() {
    dataResource.refresh();
  }

  void dispose() {
    dataResource.dispose();
    selectedId.dispose();
  }
}
```

### Using Resource with Multiple Dependencies

```dart
final page = Signal(1);
final filter = Signal<String?>(null);

final _params = Computed(() => (page: page.value, filter: filter.value));

final itemsResource = Resource<List<Item>>(
  () async {
    final p = _params.value;
    return await api.getItems(page: p.page, filter: p.filter);
  },
  source: _params,
);
```

---

## Configuration

```dart
void main() {
  // Global configuration
  SolidartConfig.autoDispose = true; // default
  SolidartConfig.trackPreviousValue = true; // default
  SolidartConfig.useRefreshing = true; // default
  SolidartConfig.assertSignalBuilderWithoutDependencies = true; // default

  runApp(const MyApp());
}
```
