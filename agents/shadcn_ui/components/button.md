# Shadcn UI Button Component

## Overview
The Shadcn UI Button component is a versatile and customizable UI element that supports multiple styles and configurations.

## Import
```dart
import 'package:shadcn_ui/shadcn_ui.dart';
```

## Basic Usage
Shadcn UI provides multiple button styles to suit different design needs:

### Primary Button
```dart
ShadButton(
  child: const Text('Primary Button'),
  onPressed: () {
    // Handle button press
  },
)
```

### Secondary Button
```dart
ShadButton.secondary(
  child: const Text('Secondary Button'),
  onPressed: () {
    // Handle button press
  },
)
```

### Button Variants
1. Destructive Button
```dart
ShadButton.destructive(
  child: const Text('Destructive'),
  onPressed: () {},
)
```

2. Outline Button
```dart
ShadButton.outline(
  child: const Text('Outline Button'),
  onPressed: () {},
)
```

3. Ghost Button
```dart
ShadButton.ghost(
  child: const Text('Ghost Button'),
  onPressed: () {},
)
```

### Button with Icon
```dart
ShadButton(
  onPressed: () {},
  leading: const Icon(LucideIcons.mail),
  child: const Text('Login with Email'),
)
```

### Loading State
```dart
ShadButton(
  onPressed: () {},
  leading: SizedBox.square(
    dimension: 16,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: ShadTheme.of(context).colorScheme.primaryForeground,
    ),
  ),
  child: const Text('Please wait'),
)
```

## Customization
The Button supports advanced customization like gradients and shadows:

```dart
ShadButton(
  onPressed: () {},
  gradient: const LinearGradient(
    colors: [Colors.cyan, Colors.indigo],
  ),
  shadows: [
    BoxShadow(
      color: Colors.black26,
      offset: Offset(0, 4),
      blurRadius: 5.0,
    )
  ],
  child: const Text('Gradient Button'),
)
```

## Key Variants
- `ShadButton`: Standard button
- `ShadButton.secondary()`: Secondary styling
- `ShadButton.destructive()`: Destructive action button
- `ShadButton.outline()`: Outlined button style
- `ShadButton.ghost()`: Minimalist ghost button
- `ShadButton.link()`: Hyperlink-style button

## Best Practices
- Always provide meaningful text or icons
- Use appropriate button variant based on action importance
- Implement clear `onPressed` handlers
- Consider accessibility and touch targets

## Performance Note
Shadcn UI buttons are designed to be lightweight and performant, making them suitable for complex Flutter applications.