# Code Generation Planning Document

This document serves as a comprehensive reference for code generation work using `source_gen` and `code_builder` packages in the Flutter CMS project.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Source Gen Package Reference](#source-gen-package-reference)
3. [Code Builder Package Reference](#code-builder-package-reference)
4. [Current Implementation](#current-implementation)
5. [Architecture Patterns](#architecture-patterns)
6. [Common Patterns & Examples](#common-patterns--examples)

---

## Project Overview

### Flutter CMS Code Generation System

The Flutter CMS project uses code generation to automatically create:
1. **Config Classes** (`*CmsConfig`) - Wrapper classes with `CmsData<T>` fields for each original field
2. **Field Configuration Lists** - Lists of field configs (`CmsTextFieldConfig`, `CmsImageFieldConfig`, etc.) for form generation

### Complete Example: Input → Output

**Input File**: `lib/home_screen_config.dart`

```dart
import 'dart:ui';
import 'package:flutter_cms/models/cms_annotations.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:flutter_cms/models/fields/datetime_field.dart';
import 'package:flutter_cms/models/fields/image_field.dart';
import 'package:flutter_cms/models/fields/number_field.dart';
import 'package:flutter_cms/models/fields/string_field.dart';
import 'package:flutter_cms/models/fields/text_field.dart';

part 'home_screen_config.cms.g.dart';

@CmsConfig()
class HomeScreenConfig {
  @CmsTextFieldConfig(
    option: CmsTextOption(rows: 1, description: 'Title of the home screen'),
  )
  final String title;

  @CmsImageFieldConfig()
  final String backgroundImageAsset;

  @CmsDateTimeFieldConfig()
  final DateTime dateTime;

  @CmsNumberFieldConfig()
  final double number;

  final HomeScreenButtonConfig buttonConfig;

  const HomeScreenConfig({
    required this.title,
    required this.backgroundImageAsset,
    required this.dateTime,
    required this.number,
    required this.buttonConfig,
  });
}

@CmsConfig()
class HomeScreenButtonConfig {
  @CmsStringFieldConfig()
  final String label;

  @CmsStringFieldConfig()
  final Color backgroundColor;

  const HomeScreenButtonConfig({
    required this.label,
    required this.backgroundColor,
  });
}
```

**Generated Output**: `lib/home_screen_config.cms.g.dart`

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_screen_config.dart';

// **************************************************************************
// CmsFieldGenerator
// **************************************************************************

/// Generated field configurations for HomeScreenConfig
final homeScreenConfigFields = [
  CmsTextFieldConfig(
    name: 'title',
    title: 'Title',
    option: CmsTextOption(rows: 1),
  ),
  CmsImageFieldConfig(
    name: 'backgroundImageAsset',
    title: 'Background Image Asset',
  ),
  CmsDateTimeFieldConfig(name: 'dateTime', title: 'Date Time'),
  CmsNumberFieldConfig(name: 'number', title: 'Number'),
  CmsObjectFieldConfig(
    name: 'buttonConfig',
    title: 'Button Config',
    option: CmsObjectOption(fields: homeScreenButtonConfigFields),
  ),
];

/// Generated field configurations for HomeScreenButtonConfig
final homeScreenButtonConfigFields = [
  CmsStringFieldConfig(name: 'label', title: 'Label'),
  CmsStringFieldConfig(name: 'backgroundColor', title: 'Background Color'),
];

// **************************************************************************
// CmsConfigGenerator
// **************************************************************************

class HomeScreenConfigCmsConfig {
  HomeScreenConfigCmsConfig({
    required this.title,
    required this.backgroundImageAsset,
    required this.dateTime,
    required this.number,
    required this.buttonConfig,
  });

  final CmsData<String> title;

  final CmsData<String> backgroundImageAsset;

  final CmsData<DateTime> dateTime;

  final CmsData<double> number;

  final CmsData<HomeScreenButtonConfigCmsConfig> buttonConfig;
}

class HomeScreenButtonConfigCmsConfig {
  HomeScreenButtonConfigCmsConfig({
    required this.label,
    required this.backgroundColor,
  });

  final CmsData<String> label;

  final CmsData<Color> backgroundColor;
}
```

**Key Transformations**:

1. **Class Annotation (`@CmsConfig()`)** generates:
   - A new class with suffix `CmsConfig`
   - All fields wrapped in `CmsData<T>`
   - Constructor with all fields as required named parameters
   - Nested `@CmsConfig` classes also get transformed (e.g., `HomeScreenButtonConfig` → `HomeScreenButtonConfigCmsConfig`)

2. **Field Annotations** (e.g., `@CmsTextFieldConfig()`, `@CmsImageFieldConfig()`) generate:
   - A list variable named `{className}Fields` (camelCase)
   - Each annotated field becomes a config object with `name`, `title`, and `option`
   - Field names are converted to Title Case for the `title` property
   - Nested `@CmsConfig` classes become `CmsObjectFieldConfig` with reference to nested fields list

3. **Field without explicit annotation** but type has `@CmsConfig`:
   - Automatically treated as `CmsObjectFieldConfig`
   - References the nested class's generated fields list

### Key Dependencies
```yaml
dependencies:
  source_gen: ^2.0.0
  code_builder: ^4.10.0
  build: ^2.5.4
  analyzer: ^7.7.0

dev_dependencies:
  build_runner: ^2.5.4
```

### Build Configuration (`build.yaml`)
```yaml
targets:
  $default:
    builders:
      flutter_cms|cmsBuilder:
        enabled: true
        generate_for:
          - lib/home_screen_config.dart

builders:
  cmsBuilder:
    target: ":flutter_cms"
    import: "package:flutter_cms/builder.dart"
    builder_factories: ["cmsBuilder"]
    build_extensions: {".dart": [".cms.g.dart"]}
    auto_apply: dependents
    build_to: source
    applies_builders: ["source_gen:combining_builder"]
```

---

## Source Gen Package Reference

### Core Classes

#### 1. Generator (Abstract Base Class)
```dart
abstract class Generator {
  const Generator();

  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) => null;
}
```

**Usage**: Extend this for custom generators that need full library access.

#### 2. GeneratorForAnnotation<T>
```dart
abstract class GeneratorForAnnotation<T> extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep);

  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  );
}
```

**Usage**: The most common base class. Automatically finds elements annotated with `@T` and calls `generateForAnnotatedElement` for each.

#### 3. LibraryReader
```dart
class LibraryReader {
  final LibraryElement element;

  LibraryReader(this.element);

  // Find a specific type by name
  ClassElement? findType(String name);

  // Get all elements in the library
  Iterable<Element> get allElements;

  // Find elements annotated with a specific type
  Iterable<AnnotatedElement> annotatedWith(
    TypeChecker checker,
    {bool throwOnUnresolved = true}
  );
}
```

**Usage**: Read and query library elements during code generation.

#### 4. TypeChecker
```dart
// Create from runtime type
final typeChecker = TypeChecker.fromRuntime(MyAnnotation);

// Check if element has annotation
bool hasAnnotation = typeChecker.hasAnnotationOf(element);

// Get first annotation
DartObject? annotation = typeChecker.firstAnnotationOf(element);
```

**Usage**: Check for annotations on elements without importing the actual annotation class.

#### 5. ConstantReader
```dart
class ConstantReader {
  // Read field values from annotations
  int? toIntValue();
  String? toStringValue();
  bool? toBoolValue();

  // Access fields of the annotation object
  ConstantReader? getField(String name);
}
```

**Usage**: Read annotation parameter values during code generation.

#### 6. Builders
```dart
// PartBuilder - generates part files
Builder partBuilder = PartBuilder(
  [MyGenerator()],
  '.g.dart',
  header: '// Custom header',
);

// LibraryBuilder - generates standalone library files
Builder libraryBuilder = LibraryBuilder(
  MyGenerator(),
  generatedExtension: '.generated.dart',
);

// SharedPartBuilder - combines multiple part files
Builder sharedBuilder = SharedPartBuilder(
  [MyGenerator()],
  'my_shared',
);
```

#### 7. Error Handling
```dart
class InvalidGenerationSource implements Exception {
  final String message;
  final String todo;
  final Element? element;

  InvalidGenerationSource(
    this.message, {
    this.todo = '',
    this.element,
  });
}
```

**Usage**: Throw this to provide helpful error messages during code generation.

---

## Code Builder Package Reference

### Core Concepts

**Code Builder** uses a fluent, builder-based API with the visitor pattern. All specs implement `Spec` and use the `accept()` method with `DartEmitter` to generate code.

### Key Classes

#### 1. Spec (Base Interface)
```dart
abstract class Spec {
  R accept<R>(SpecVisitor<R> visitor, [R? context]);
}
```

All code builder classes implement `Spec`.

#### 2. Reference - Type References
```dart
// Create a reference to a type
Reference refer(String symbol, [String? url]);

// Examples:
final stringRef = refer('String');
final listRef = refer('List', 'dart:core');
final customRef = refer('MyClass', 'package:my_package/my_class.dart');

// Generic types
final listOfStrings = refer('List').call([refer('String')]);
```

**Usage**: Reference types, classes, and functions in generated code.

#### 3. Field - Class Fields
```dart
abstract class Field implements Built<Field, FieldBuilder>, Spec {
  String get name;
  Reference? get type;
  FieldModifier get modifier; // var$, final$, constant
  Code? get assignment;
  bool get static;
  bool get late;
  bool get external;
  BuiltList<Expression> get annotations;
  BuiltList<String> get docs;
}

// Usage:
final field = Field(
  (b) => b
    ..name = 'myField'
    ..type = refer('String')
    ..modifier = FieldModifier.final$
    ..assignment = Code('\'default value\''),
);
```

**Field Modifiers**:
- `FieldModifier.var$` - `var myField`
- `FieldModifier.final$` - `final myField`
- `FieldModifier.constant` - `const myField`

#### 4. Constructor
```dart
abstract class Constructor implements Built<Constructor, ConstructorBuilder> {
  String? get name;
  BuiltList<Parameter> get requiredParameters;
  BuiltList<Parameter> get optionalParameters;
  BuiltList<Code> get initializers;
  Code? get body;
  bool get constant;
  bool get factory;
  bool get external;
  bool? get lambda;
  Reference? get redirect;
}

// Usage:
final constructor = Constructor(
  (b) => b
    ..optionalParameters.addAll([
      Parameter((b) => b
        ..name = 'title'
        ..toThis = true
        ..named = true
        ..required = true),
    ]),
);
```

#### 5. Parameter
```dart
abstract class Parameter implements Built<Parameter, ParameterBuilder> {
  String get name;
  Reference? get type;
  bool get named;
  bool get required;
  bool get toThis; // For constructor parameters
  Code? get defaultTo;
}
```

#### 6. Method
```dart
abstract class Method implements Built<Method, MethodBuilder>, Spec {
  String get name;
  Reference? get returns;
  BuiltList<Parameter> get requiredParameters;
  BuiltList<Parameter> get optionalParameters;
  Code? get body;
  bool get static;
  bool get external;
  MethodType? get type; // getter, setter
  MethodModifier? get modifier; // async, asyncStar, syncStar
  bool? get lambda;
}

// Usage:
final method = Method(
  (b) => b
    ..name = 'myMethod'
    ..returns = refer('String')
    ..body = Code('return "hello";'),
);
```

#### 7. Class
```dart
abstract class Class implements Built<Class, ClassBuilder>, Spec {
  String get name;
  bool get abstract;
  bool get sealed;
  bool get mixin;
  ClassModifier? get modifier; // base, final, interface
  Reference? get extend;
  BuiltList<Reference> get implements;
  BuiltList<Reference> get mixins;
  BuiltList<Reference> get types; // Generic type parameters
  BuiltList<Constructor> get constructors;
  BuiltList<Method> get methods;
  BuiltList<Field> get fields;
  BuiltList<Expression> get annotations;
  BuiltList<String> get docs;
}

// Usage:
final generatedClass = Class(
  (b) => b
    ..name = 'MyGeneratedClass'
    ..fields.addAll([
      Field((b) => b
        ..name = 'field1'
        ..type = refer('String')
        ..modifier = FieldModifier.final$),
    ])
    ..constructors.add(
      Constructor((b) => b
        ..optionalParameters.add(
          Parameter((b) => b
            ..name = 'field1'
            ..toThis = true
            ..named = true
            ..required = true),
        )),
    ),
);
```

#### 8. Code & Expression
```dart
// Static code string
final code = Code('return "hello";');

// Scoped code with automatic imports
final scopedCode = Code.scope((allocate) {
  return 'return ${allocate(refer('MyClass', 'package:my/lib.dart'))}();';
});

// Expression - represents Dart expressions
abstract class Expression implements Code {
  // Create literals
  static Expression literal(Object? value);

  // Variable declaration
  Expression asVar(String name);
  Expression asFinal(String name);
  Expression asConst(String name);

  // Operations
  Expression call(Iterable<Expression> positional, [Map<String, Expression> named]);
  Expression property(String name);
  Expression index(Expression index);
}
```

#### 9. DartEmitter - Code Output
```dart
final emitter = DartEmitter();

// Generate code string from any Spec
final classCode = myClass.accept(emitter);
final methodCode = myMethod.accept(emitter);
final fieldCode = myField.accept(emitter);

// With allocator for automatic imports
final allocator = Allocator();
final emitterWithAllocator = DartEmitter(allocator: allocator);
```

#### 10. Block - Code Blocks
```dart
final block = Block(
  (b) => b.statements.addAll([
    Code('print("hello");'),
    Code('return true;'),
  ]),
);

// Or using factory
final block2 = Block.of([
  Code('var x = 1;'),
  Code('print(x);'),
]);
```

---

## Current Implementation

### 1. CmsConfigGenerator

**Location**: `lib/src/cms_data_generator.dart`

**Purpose**: Generates config classes that wrap original fields with `CmsData<T>`.

**Example**:
```dart
// Input:
@CmsConfig()
class HomeScreenConfig {
  final String title;
  final DateTime dateTime;
}

// Output:
class HomeScreenConfigCmsConfig {
  HomeScreenConfigCmsConfig({
    required this.title,
    required this.dateTime,
  });

  final CmsData<String> title;
  final CmsData<DateTime> dateTime;
}
```

**Key Implementation Details**:
```dart
class CmsConfigGenerator extends GeneratorForAnnotation<CmsConfig> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // 1. Validate element is a class
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@CmsConfig` can only be used on classes.',
        element: element,
      );
    }

    // 2. Get class name and generate new name
    final className = element.name;
    final generatedClassName = '${className}CmsConfig';

    // 3. Transform fields to CmsData<T> fields
    final fields = element.fields
        .where((field) => !field.isStatic)
        .map((field) {
          final fieldType = field.type.getDisplayString(withNullability: false);

          // Check if field type also has @CmsConfig
          final typeChecker = TypeChecker.fromRuntime(CmsConfig);
          final fieldElement = field.type.element;
          String cmsDataType;

          if (fieldElement is ClassElement &&
              typeChecker.hasAnnotationOfExact(fieldElement)) {
            cmsDataType = 'CmsData<${fieldType}CmsConfig>';
          } else {
            cmsDataType = 'CmsData<$fieldType>';
          }

          return Field(
            (b) => b
              ..name = field.name
              ..modifier = FieldModifier.final$
              ..type = refer(cmsDataType),
          );
        });

    // 4. Generate constructor
    final constructor = Constructor(
      (b) => b
        ..optionalParameters.addAll(
          element.fields
              .where((field) => !field.isStatic)
              .map((field) => Parameter(
                    (b) => b
                      ..name = field.name
                      ..toThis = true
                      ..named = true
                      ..required = true,
                  )),
        ),
    );

    // 5. Build class
    final generatedClass = Class(
      (b) => b
        ..name = generatedClassName
        ..fields.addAll(fields)
        ..constructors.add(constructor),
    );

    // 6. Emit and format code
    final emitter = DartEmitter();
    return DartFormatter(
      languageVersion: Version(3, 7, 0),
    ).format('${generatedClass.accept(emitter)}');
  }
}
```

### 2. CmsFieldGenerator

**Location**: `lib/src/cms_field_generator.dart`

**Purpose**: Generates field configuration lists for form generation.

**Example**:
```dart
// Input:
@CmsConfig()
class HomeScreenConfig {
  @CmsTextFieldConfig(option: CmsTextOption(rows: 1))
  final String title;

  @CmsImageFieldConfig()
  final String backgroundImage;
}

// Output:
final homeScreenConfigFields = [
  CmsTextFieldConfig(
    name: 'title',
    title: 'Title',
    option: CmsTextOption(rows: 1),
  ),
  CmsImageFieldConfig(
    name: 'backgroundImage',
    title: 'Background Image',
  ),
];
```

**Key Implementation Details**:
```dart
class CmsFieldGenerator extends GeneratorForAnnotation<CmsConfig> {
  // Map of annotation types to code generators
  static final _fieldConfigs = {
    'CmsTextFieldConfig': (FieldElement field, DartObject? config) {
      final option = config?.getField('option');
      final rows = option?.getField('rows')?.toIntValue() ?? 1;
      return '''CmsTextFieldConfig(
    name: '${field.name}',
    title: '${_titleCase(field.name)}',
    option: CmsTextOption(rows: $rows),
  )''';
    },
    'CmsImageFieldConfig': (FieldElement field, DartObject? config) =>
        '''CmsImageFieldConfig(
    name: '${field.name}',
    title: '${_titleCase(field.name)}',
  )''',
    // ... more field configs
  };

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // 1. Generate list variable name
    final className = element.name;
    final fieldsListName =
        '${className[0].toLowerCase()}${className.substring(1)}Fields';

    // 2. Process each field
    final fields = element.fields.where((f) => !f.isStatic);
    final fieldConfigs = <String>[];

    for (final field in fields) {
      // Check for field-specific annotations
      for (final annotation in field.metadata) {
        final annotationType = annotation.computeConstantValue()?.type;
        if (annotationType != null &&
            _fieldConfigs.containsKey(annotationType.toString())) {
          final generator = _fieldConfigs[annotationType.toString()]!;
          fieldConfigs.add(
            generator(field, annotation.computeConstantValue())
          );
          break;
        }
      }

      // Handle nested @CmsConfig classes as object fields
      if (field.type.element is ClassElement) {
        final fieldClass = field.type.element as ClassElement;
        if (TypeChecker.fromRuntime(CmsConfig).hasAnnotationOf(fieldClass)) {
          fieldConfigs.add('''CmsObjectFieldConfig(
    name: '${field.name}',
    title: '${_titleCase(field.name)}',
    option: CmsObjectOption(fields: ${fieldClass.name[0].toLowerCase()}${fieldClass.name.substring(1)}Fields),
  )''');
        }
      }
    }

    // 3. Generate list
    return '''
/// Generated field configurations for $className
final $fieldsListName = [
  ${fieldConfigs.join(',\n  ')},
];
''';
  }

  // Utility: Convert camelCase to Title Case
  static String _titleCase(String input) {
    // Implementation...
  }
}
```

### 3. Builder Configuration

**Location**: `lib/builder.dart`

```dart
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/cms_data_generator.dart';
import 'src/cms_field_generator.dart';

/// Creates a builder for generating CMS data and field configurations
Builder cmsBuilder(BuilderOptions options) =>
    PartBuilder(
      [CmsFieldGenerator(), CmsConfigGenerator()],
      '.cms.g.dart',
    );
```

**Key Points**:
- `PartBuilder` combines multiple generators into one part file
- Generators run in order: `CmsFieldGenerator` first, then `CmsConfigGenerator`
- Output extension is `.cms.g.dart`

---

## Architecture Patterns

### 1. Generator Pattern

```
User's Code (@Annotated)
         ↓
    build_runner
         ↓
   Source Gen (finds annotations)
         ↓
Your Generator (generateForAnnotatedElement)
         ↓
   Code Builder (builds code specs)
         ↓
    DartEmitter (emits Dart code)
         ↓
   DartFormatter (formats code)
         ↓
  Generated .g.dart file
```

### 2. Typical Generator Structure

```dart
class MyGenerator extends GeneratorForAnnotation<MyAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // 1. VALIDATE
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError('Message', element: element);
    }

    // 2. EXTRACT DATA
    final className = element.name;
    final fields = element.fields.where((f) => !f.isStatic);
    final annotationValue = annotation.read('someParam').stringValue;

    // 3. BUILD CODE SPECS
    final generatedFields = fields.map((field) =>
      Field((b) => b
        ..name = field.name
        ..type = refer(field.type.getDisplayString(withNullability: false))
        ..modifier = FieldModifier.final$)
    );

    final generatedClass = Class((b) => b
      ..name = '${className}Generated'
      ..fields.addAll(generatedFields));

    // 4. EMIT CODE
    final emitter = DartEmitter();
    final code = generatedClass.accept(emitter);

    // 5. FORMAT (optional)
    return DartFormatter().format('$code');
  }
}
```

### 3. Handling Nested Annotations

When a field's type also has `@CmsConfig`:

```dart
// Check if field type has @CmsConfig
final typeChecker = TypeChecker.fromRuntime(CmsConfig);
final fieldElement = field.type.element;

if (fieldElement is ClassElement &&
    typeChecker.hasAnnotationOfExact(fieldElement)) {
  // This field's type is also @CmsConfig annotated
  // Generate special handling
}
```

### 4. Reading Annotation Parameters

```dart
// Annotation definition:
class MyAnnotation {
  final String title;
  final int count;
  final bool enabled;

  const MyAnnotation({
    this.title = 'default',
    this.count = 0,
    this.enabled = false,
  });
}

// Reading in generator:
String generateForAnnotatedElement(
  Element element,
  ConstantReader annotation,
  BuildStep buildStep,
) {
  final title = annotation.read('title').stringValue;
  final count = annotation.read('count').intValue;
  final enabled = annotation.read('enabled').boolValue;

  // Or with defaults:
  final titleOrDefault =
    annotation.peek('title')?.stringValue ?? 'default';
}
```

---

## Common Patterns & Examples

### 1. Generate a Simple Class

```dart
final myClass = Class((b) => b
  ..name = 'Person'
  ..fields.addAll([
    Field((b) => b
      ..name = 'name'
      ..type = refer('String')
      ..modifier = FieldModifier.final$),
    Field((b) => b
      ..name = 'age'
      ..type = refer('int')
      ..modifier = FieldModifier.final$),
  ])
  ..constructors.add(
    Constructor((b) => b
      ..constant = true
      ..optionalParameters.addAll([
        Parameter((b) => b
          ..name = 'name'
          ..toThis = true
          ..named = true
          ..required = true),
        Parameter((b) => b
          ..name = 'age'
          ..toThis = true
          ..named = true
          ..required = true),
      ])),
  ));

// Output:
// class Person {
//   const Person({
//     required this.name,
//     required this.age,
//   });
//
//   final String name;
//   final int age;
// }
```

### 2. Generate a Method

```dart
final method = Method((b) => b
  ..name = 'greet'
  ..returns = refer('String')
  ..requiredParameters.add(
    Parameter((b) => b
      ..name = 'name'
      ..type = refer('String')))
  ..body = Code('return "Hello, \$name!";'));

// Output:
// String greet(String name) {
//   return "Hello, $name!";
// }
```

### 3. Generate Generic Types

```dart
// List<String>
final listOfStrings = refer('List').type(
  [refer('String')]
);

// Map<String, int>
final mapOfStringToInt = refer('Map').type(
  [refer('String'), refer('int')]
);

// Custom<T>
final customGeneric = refer('Custom').type(
  [refer('T')]
);
```

### 4. Generate with Imports

```dart
// Using URL parameter
final reference = refer('MyClass', 'package:my_package/my_class.dart');

// The DartEmitter will handle imports automatically
```

### 5. Iterate Over Class Fields

```dart
String generateForAnnotatedElement(
  Element element,
  ConstantReader annotation,
  BuildStep buildStep,
) {
  final classElement = element as ClassElement;

  // Get all non-static fields
  final fields = classElement.fields.where((f) => !f.isStatic);

  for (final field in fields) {
    final fieldName = field.name;
    final fieldType = field.type.getDisplayString(withNullability: false);
    final isNullable = field.type.nullabilitySuffix == NullabilitySuffix.question;

    // Check field annotations
    for (final annotation in field.metadata) {
      final annotationValue = annotation.computeConstantValue();
      // Process annotation...
    }
  }

  // Generate code...
}
```

### 6. Generate a Constructor with Named Parameters

```dart
final constructor = Constructor((b) => b
  ..optionalParameters.addAll([
    Parameter((b) => b
      ..name = 'title'
      ..type = refer('String')
      ..named = true
      ..required = true),
    Parameter((b) => b
      ..name = 'count'
      ..type = refer('int')
      ..named = true
      ..defaultTo = Code('0')),
  ]));

// Output:
// MyClass({
//   required String title,
//   int count = 0,
// })
```

### 7. Generate toString() Method

```dart
final toStringMethod = Method((b) => b
  ..name = 'toString'
  ..returns = refer('String')
  ..annotations.add(refer('override'))
  ..lambda = true
  ..body = Code(
    "'Person(name: \$name, age: \$age)'",
  ));

// Output:
// @override
// String toString() => 'Person(name: $name, age: $age)';
```

### 8. Generate Static Fields/Methods

```dart
final staticField = Field((b) => b
  ..name = 'instance'
  ..type = refer('MyClass')
  ..static = true
  ..modifier = FieldModifier.final$
  ..assignment = Code('MyClass()'));

final staticMethod = Method((b) => b
  ..name = 'create'
  ..static = true
  ..returns = refer('MyClass')
  ..body = Code('return MyClass();'));

// Output:
// static final MyClass instance = MyClass();
// static MyClass create() {
//   return MyClass();
// }
```

### 9. Generate Extension Methods

```dart
final extension = Extension((b) => b
  ..name = 'StringExtensions'
  ..on = refer('String')
  ..methods.add(
    Method((b) => b
      ..name = 'capitalize'
      ..returns = refer('String')
      ..lambda = true
      ..body = Code(
        'isEmpty ? this : this[0].toUpperCase() + substring(1)',
      )),
  ));

// Output:
// extension StringExtensions on String {
//   String capitalize() =>
//     isEmpty ? this : this[0].toUpperCase() + substring(1);
// }
```

### 10. Handle Multiple Generators in One Builder

```dart
Builder myBuilder(BuilderOptions options) => PartBuilder(
  [
    FirstGenerator(),
    SecondGenerator(),
    ThirdGenerator(),
  ],
  '.g.dart',
  header: '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: my_builder
''',
);
```

### 11. Generate Documentation Comments

```dart
final classWithDocs = Class((b) => b
  ..name = 'MyClass'
  ..docs.addAll([
    '/// A class that does something cool.',
    '///',
    '/// This is a longer description.',
  ])
  ..fields.add(
    Field((b) => b
      ..name = 'value'
      ..type = refer('String')
      ..docs.add('/// The value field')
      ..modifier = FieldModifier.final$),
  ));

// Output:
// /// A class that does something cool.
// ///
// /// This is a longer description.
// class MyClass {
//   /// The value field
//   final String value;
// }
```

### 12. Generate with Annotations

```dart
final annotatedClass = Class((b) => b
  ..name = 'MyModel'
  ..annotations.addAll([
    refer('immutable'),
    refer('JsonSerializable').call([]),
  ])
  ..fields.add(
    Field((b) => b
      ..name = 'id'
      ..type = refer('String')
      ..annotations.add(
        refer('JsonKey').call([], {
          'name': literalString('_id'),
        }),
      )
      ..modifier = FieldModifier.final$),
  ));

// Output:
// @immutable
// @JsonSerializable()
// class MyModel {
//   @JsonKey(name: '_id')
//   final String id;
// }
```

---

## Best Practices

### 1. Error Handling
Always validate input and provide helpful error messages:

```dart
if (element is! ClassElement) {
  throw InvalidGenerationSourceError(
    '`@MyAnnotation` can only be used on classes.',
    element: element,
    todo: 'Remove the annotation or apply it to a class.',
  );
}
```

### 2. Null Safety
Handle nullable types correctly:

```dart
final fieldType = field.type.getDisplayString(withNullability: true);
// vs
final fieldTypeNoNull = field.type.getDisplayString(withNullability: false);
```

### 3. Import Management
Let `DartEmitter` handle imports automatically by using `refer()` with package URLs.

### 4. Code Formatting
Always format generated code:

```dart
final emitter = DartEmitter();
final code = myClass.accept(emitter);
return DartFormatter().format('$code');
```

### 5. Avoid String Concatenation
Use Code Builder's API instead of string concatenation for type safety:

```dart
// ❌ Don't do this:
final code = 'class ${className} { final String name; }';

// ✅ Do this:
final myClass = Class((b) => b
  ..name = className
  ..fields.add(Field((b) => b
    ..name = 'name'
    ..type = refer('String')
    ..modifier = FieldModifier.final$)));
```

### 6. Testing Generators
Create unit tests for your generators:

```dart
test('generates correct class', () async {
  final library = await resolveSource('''
    import 'package:my_package/annotations.dart';

    @MyAnnotation()
    class TestClass {
      final String field;
    }
  ''');

  final generator = MyGenerator();
  final output = await generator.generate(
    LibraryReader(library),
    buildStep,
  );

  expect(output, contains('class TestClassGenerated'));
});
```

---

## Troubleshooting

### Common Issues

1. **"part of" statement missing**: Make sure your generated file has `part of 'original_file.dart';`
2. **Import errors**: Use full package paths in `refer('Type', 'package:...')`
3. **Type not found**: Ensure the type is imported in the original file or use string type names
4. **Builder not running**: Check `build.yaml` configuration and `build_extensions`
5. **Generated code not formatted**: Use `DartFormatter` before returning the code

### Debug Tips

1. Print the element type: `print(element.runtimeType)`
2. Print field types: `print(field.type.getDisplayString(withNullability: true))`
3. Print annotations: `print(field.metadata.map((m) => m.element?.displayName))`
4. Use `buildStep.log.info()` for logging during generation

---

## Additional Resources

- [source_gen package](https://github.com/dart-lang/source_gen)
- [code_builder package](https://github.com/dart-lang/tools/tree/main/pkgs/code_builder)
- [build package](https://github.com/dart-lang/build)
- [analyzer package](https://github.com/dart-lang/sdk/tree/main/pkg/analyzer)

---

## Next Steps for Flutter CMS

Potential enhancements to the code generation system:

1. **Add more field types**: Generate configs for all CMS field types
2. **Validation generation**: Auto-generate validators based on field annotations
3. **JSON serialization**: Generate `fromJson`/`toJson` methods for CmsData classes
4. **Form builders**: Generate form widgets from field configurations
5. **API clients**: Generate API client code for fetching/updating CMS data
6. **Type-safe references**: Generate type-safe accessors for nested config objects
7. **Schema validation**: Validate field configurations at compile time
8. **Documentation**: Auto-generate API documentation from CMS configs

---

*Last updated: 2025-10-04*
