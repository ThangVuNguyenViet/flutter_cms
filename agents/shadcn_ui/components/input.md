# Shadcn UI Input Component

## Overview
The Shadcn UI Input component provides a flexible and customizable text input field with support for various input types, validation, and styling.

## Import
```dart
import 'package:shadcn_ui/shadcn_ui.dart';
```

## Basic Usage
### Standard Input
```dart
ShadInput(
  placeholder: const Text('Enter your text'),
  keyboardType: TextInputType.text,
)
```

### Email Input
```dart
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 320),
  child: const ShadInput(
    placeholder: Text('Email'),
    keyboardType: TextInputType.emailAddress,
  ),
)
```

## Form Input with Validation
```dart
ShadInputFormField(
  id: 'username',
  label: const Text('Username'),
  placeholder: const Text('Enter your username'),
  description: const Text('This is your public display name.'),
  validator: (v) {
    if (v.length < 2) {
      return 'Username must be at least 2 characters.';
    }
    return null;
  },
)
```

## Password Input
```dart
class PasswordInput extends StatefulWidget {
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      placeholder: const Text('Password'),
      obscureText: obscure,
      leading: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(LucideIcons.lock),
      ),
      trailing: ShadButton(
        // Implement password visibility toggle
      ),
    );
  }
}
```

## Component Types
1. `ShadInput`: Standard input field
2. `ShadInputFormField`: Input field with form validation support

## Key Features
- Placeholder text support
- Keyboard type configuration
- Leading and trailing widget support
- Form validation
- Password text obscuring
- Responsive design

## Best Practices
- Always provide clear placeholder or label text
- Implement appropriate keyboard types
- Use validators for form inputs
- Consider accessibility requirements
- Provide clear error messages

## Customization Options
- `placeholder`: Text displayed when input is empty
- `obscureText`: Enable/disable text masking
- `leading`: Widget displayed before input
- `trailing`: Widget displayed after input
- `keyboardType`: Define input type (email, number, text)
- `validator`: Custom validation logic

## Performance Considerations
Shadcn UI inputs are designed to be lightweight and performant, ensuring smooth user interactions in complex Flutter applications.