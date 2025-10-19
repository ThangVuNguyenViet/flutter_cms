# Component Development Guide

This document provides guidelines for developing UI components in the Flutter CMS project.

## UI Library

We use **flutter-shadcn-ui** for building all UI components in this project.

- **Documentation**: https://flutter-shadcn-ui.mariuti.com/
- **GitHub Repository**: https://github.com/nank1ro/flutter-shadcn-ui
- **Package**: `shadcn_ui` on pub.dev

### Why flutter-shadcn-ui?

- 30+ high-quality, customizable components
- Supports pure Shadcn, Material, and Cupertino widgets
- Flexible theming system
- Actively maintained and growing component library

## Component Structure

All CMS input components are stored in the **`lib/inputs/`** directory.

### Example Component Structure

```dart
import 'package:flutter/material.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CmsTextInput extends StatelessWidget {
  final CmsTextField field;
  final CmsData? data;

  const CmsTextInput({super.key, required this.field, this.data});

  @override
  Widget build(BuildContext context) {
    // Use shadcn_ui widgets here
    return ShadInputFormField(
      initialValue: data?.value ?? field.option.initialValue,
      label: Text(field.title),
      // ... other properties
    );
  }
}
```

## Installation

The library is already added to `pubspec.yaml`:

```yaml
dependencies:
  shadcn_ui: ^0.28.0
```

To use the latest version:
```bash
flutter pub upgrade shadcn_ui
```

## Basic Usage

### 1. Import the library

```dart
import 'package:shadcn_ui/shadcn_ui.dart';
```

### 2. Available Components

The flutter-shadcn-ui library provides 30+ components including:

- **Form Components**: Input, Checkbox, Radio, Select, Switch, Slider
- **Buttons**: Button, IconButton
- **Dialogs**: Dialog, AlertDialog, Sheet
- **Navigation**: Tabs, Popover, DropdownMenu
- **Display**: Card, Avatar, Badge, Tooltip
- **Feedback**: Progress, Toast
- **Layout**: Accordion, Resizable, Separator

See the [full documentation](https://flutter-shadcn-ui.mariuti.com/) for complete component list and examples.

### 3. Using Components

Example using `ShadInputFormField`:

```dart
ShadInputFormField(
  label: Text('Username'),
  description: Text('Enter your username'),
  placeholder: Text('john_doe'),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  },
)
```

### 4. Theming

Access theme in components:

```dart
final theme = ShadTheme.of(context);
final textStyle = theme.textTheme.small;
final primaryColor = theme.colorScheme.primary;
```

## Component Development Guidelines

### 1. Component Location
- Place all CMS input components in `lib/inputs/`
- Name files using snake_case: `text_input.dart`, `image_input.dart`, etc.

### 2. Component Structure
Each component should:
- Accept a field configuration object (e.g., `CmsTextField`)
- Accept optional `CmsData` for initial values
- Handle field options (hidden, readOnly, validation, etc.)
- Use shadcn_ui widgets for UI rendering

### 3. Common Patterns

#### Handle Hidden Fields
```dart
if (field.option.hidden) {
  return const SizedBox.shrink();
}
```

#### Show Deprecation Warnings
```dart
if (field.option.deprecatedReason case String deprecatedReason)
  Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      'Deprecated: $deprecatedReason',
      style: theme.textTheme.small.copyWith(color: Colors.red),
    ),
  ),
```

#### Use Field Validation
```dart
ShadInputFormField(
  validator: field.option.validation?.labeledValidator(field.title),
  // ...
)
```

#### Respect ReadOnly State
```dart
ShadInputFormField(
  enabled: !field.option.readOnly,
  // ...
)
```

### 4. Widget Previews

Add widget previews for development:

```dart
import 'package:flutter/widget_previews.dart';

@Preview(name: 'CmsTextInput')
Widget preview() => ShadApp(
  home: CmsTextInput(
    field: CmsTextField(
      name: 'example',
      title: 'Example Field',
    ),
  ),
);
```

## App Configuration

### Pure Shadcn App

```dart
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadApp(
      home: MyHomePage(),
    );
  }
}
```

### With Material (Current Setup)

```dart
return ShadApp.custom(
  themeMode: ThemeMode.dark,
  appBuilder: (context) {
    return MaterialApp(
      builder: (context, child) {
        return ShadAppBuilder(child: child!);
      },
      home: MyHomePage(),
    );
  },
);
```

## Best Practices

1. **Consistency**: Use shadcn_ui components exclusively for consistency across the CMS
2. **Accessibility**: Ensure all components have proper labels and descriptions
3. **Validation**: Always implement proper validation for form fields
4. **Error Handling**: Display clear error messages to users
5. **Documentation**: Add comments for complex logic
6. **Testing**: Test components with various field configurations

## Resources

- **Documentation**: https://flutter-shadcn-ui.mariuti.com/
- **GitHub**: https://github.com/nank1ro/flutter-shadcn-ui
- **Examples**: Check `lib/inputs/text_input.dart` for reference implementation
- **Interactive Examples**: Visit the documentation site to interact with components

## Contributing

When adding new components:

1. Follow the existing component structure
2. Use shadcn_ui widgets
3. Handle all field options properly
4. Add widget previews for development
5. Test with different configurations
6. Update this guide if introducing new patterns
