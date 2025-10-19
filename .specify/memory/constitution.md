<!--
===============================================================================
SYNC IMPACT REPORT - Constitution v1.2.0 (Data Serialization Amendment)
===============================================================================

VERSION CHANGE: v1.1.0 → v1.2.0 (Minor: Data class generation principle added)

MODIFIED PRINCIPLES:
- MODIFIED: III. Developer Experience - Enhanced to include reactive state management and dart_mappable
- MODIFIED: IV. Build Integration - Updated to include SolidArt and dart_mappable integration requirements
- NEW: VI. Reactive State Management - SolidArt-based state management principle added
- NEW: VII. Data Class Generation - dart_mappable for automatic serialization and data classes

ADDED SECTIONS:
- State Management Requirements section with SolidArt-specific guidelines
- Data Class Requirements section with dart_mappable-specific guidelines
- Updated Quality Standards to include reactive state and serialization requirements

REMOVED SECTIONS: None

TEMPLATES REQUIRING UPDATES:
✅ .specify/templates/plan-template.md - Constitution Check section aligns
✅ .specify/templates/spec-template.md - Requirements format consistent
✅ .specify/templates/tasks-template.md - Task organization supports principles
✅ .specify/templates/checklist-template.md - Checklist format supports validation

FOLLOW-UP TODOs: None
===============================================================================
-->

# Flutter CMS Constitution

## Core Principles

### I. Code Generation First
All CMS functionality MUST be implemented through annotation-driven code generation.
Manual implementation of CMS features is prohibited to ensure consistency and reduce
maintenance burden. Every new field type, configuration option, and data structure
MUST be generated from user annotations. This ensures a single source of truth and
prevents divergence between user intent and generated code.

### II. Type Safety First
Generated code MUST be fully type-safe with compile-time validation. All CMS data
structures, field configurations, and transformations MUST leverage Dart's type
system to catch errors before runtime. Generic types like `CmsData<T>` MUST preserve
original type information throughout the generation pipeline. No dynamic types or
runtime type checking allowed in core generated code.

### III. Developer Experience
Simple annotations MUST produce powerful, well-documented output with reactive state
management and automatic serialization. A single `@CmsConfig()` annotation should
generate complete field lists, configuration classes, reactive signals, dart_mappable
data classes with fromJson/toJson/copyWith methods, and all necessary infrastructure.
Generated code MUST include proper documentation comments and clear naming conventions.
Error messages during generation MUST be actionable and include specific guidance for
resolution. All studio interfaces MUST use SolidArt signals for reactive state
updates without manual state management overhead.

### IV. Build Integration
Code generation MUST integrate seamlessly with `dart build_runner` and follow Dart
package conventions. All generators MUST use `source_gen` and `code_builder` patterns.
Build configuration MUST be minimal - a single `build.yaml` entry should enable full
code generation including SolidArt signal generation and dart_mappable serialization.
Generated files MUST use `.cms.g.dart` extension and proper part file declarations.
SolidArt and dart_mappable dependencies MUST be automatically included in generated
code imports. All data models MUST use dart_mappable annotations for serialization.

### V. Package Quality
Flutter CMS MUST maintain high-quality reusable package standards. Public API surface
MUST be minimal and focused. All public APIs MUST have comprehensive documentation
and examples. Breaking changes MUST follow semantic versioning. Package MUST support
all Flutter-supported Dart versions and platforms without platform-specific code.

### VI. Reactive State Management
All studio state management MUST use SolidArt signals for reactive updates. Event
buses, manual listeners, and imperative state updates are prohibited in favor of
declarative signal-based state management. All data models MUST expose reactive
signals for key properties. UI components MUST use SignalBuilder widgets for
automatic reactivity. Cross-component communication MUST use computed signals and
effects rather than event dispatching. State persistence MUST integrate seamlessly
with signal updates through reactive effects.

### VII. Data Class Generation
All data models MUST use dart_mappable for automatic serialization and data class
generation. Manual fromJson, toJson, and copyWith implementations are prohibited
to ensure consistency and reduce maintenance burden. Every data class MUST be
annotated with @MappableClass() and include proper part file declarations.
Serialization field mappings MUST be explicit and type-safe. Custom serialization
logic MUST be implemented through dart_mappable hooks and adapters. All generated
serialization code MUST handle nullable fields and nested objects correctly.

## Quality Standards

### Code Generation Requirements
- ALL generators MUST extend `GeneratorForAnnotation<T>` from source_gen
- Generated code MUST be formatted using `DartFormatter`
- Error handling MUST use `InvalidGenerationSourceError` with actionable messages
- All generated classes MUST include proper constructor signatures
- Field transformations MUST preserve nullability and generic type parameters
- Generated models MUST include SolidArt signal properties for reactive state

### State Management Requirements
- All studio services MUST use `Signal<T>` for mutable state properties
- UI components MUST use `SignalBuilder` widgets for reactive updates
- Computed state MUST use `Computed()` for derived values
- Side effects MUST use `Effect()` for reactive state synchronization
- No manual event dispatching or listener management allowed
- State persistence MUST be handled through reactive effects on signals

### Data Class Requirements
- All data models MUST use `@MappableClass()` annotation
- Part file declarations MUST follow `part 'filename.mapper.dart'` convention
- Field mappings MUST be explicit using `@MappableField()` when needed
- Custom serialization MUST use dart_mappable hooks, not manual override
- Enum serialization MUST use dart_mappable enum adapters
- Date/DateTime serialization MUST use consistent ISO string format
- All generated serialization methods MUST be tested for round-trip accuracy

### Documentation Requirements
- Every annotation class MUST have comprehensive dartdoc comments
- Generated code MUST include header comments indicating generator source
- Field configurations MUST auto-generate human-readable titles from field names
- All examples in documentation MUST show complete input/output transformations
- State management patterns MUST be documented with signal usage examples

### Testing Requirements
- All generators MUST have unit tests covering success and error cases
- Integration tests MUST verify complete annotation-to-generated-code workflows
- Test coverage MUST include nested `@CmsConfig` classes and all field types
- Performance tests MUST verify generation time scales linearly with input size
- Signal reactivity MUST be tested with automated state change verification

## Development Workflow

### Code Generation Workflow
All feature development MUST follow the annotation-first approach: Define annotation
parameters → Write generator logic → Generate reactive signals → Generate dart_mappable
data classes → Generate test cases → Verify output format → Write documentation.
NO manual code should replicate generated functionality. Generated models MUST include
appropriate signal properties for reactive state management and dart_mappable
annotations for serialization.

### State Management Workflow
All studio feature development MUST follow reactive-first approach: Identify state
requirements → Define signals and computed values → Implement reactive effects →
Build SignalBuilder UI components → Test signal reactivity. NO imperative state
updates or manual listener management allowed.

### Build Process
- Developers MUST run `dart run build_runner build` after annotation changes
- CI/CD MUST verify that committed generated files match current annotations
- Build failures MUST provide specific guidance on annotation corrections needed
- Generated files MUST be committed to version control for build reproducibility
- SolidArt signal generation MUST be verified in build process

### Breaking Change Policy
- Major version bumps required for: removing annotations, changing generated class signatures, breaking signal contracts
- Minor version bumps required for: new annotations, optional annotation parameters, new signal properties
- Patch version bumps for: bug fixes in generation logic, improved error messages, signal optimization
- All breaking changes MUST include automated migration documentation

## Governance

Constitutional compliance MUST be verified in all pull requests through automated
checks and code review. Complexity that violates these principles MUST be
justified with specific technical rationale and approval from package maintainers.
All generators and annotations MUST undergo design review before implementation
to ensure alignment with code generation patterns, reactive state management, and
developer experience goals.

**Version**: 1.2.0 | **Ratified**: 2025-10-18 | **Last Amended**: 2025-10-18