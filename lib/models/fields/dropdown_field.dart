import 'package:flutter_cms/models/fields.dart';

/// Represents a dropdown option with a label and value
class DropdownOption<T> {
  final T value;
  final String label;

  const DropdownOption({
    required this.value,
    required this.label,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownOption<T> &&
           other.value == value &&
           other.label == label;
  }

  @override
  int get hashCode => value.hashCode ^ label.hashCode;
}

class CmsDropdownOption<T> extends CmsOption {
  final List<DropdownOption<T>> options;
  final T? defaultValue;
  final String? placeholder;
  final bool allowNull;

  const CmsDropdownOption({
    super.hidden,
    required this.options,
    this.defaultValue,
    this.placeholder,
    this.allowNull = true,
  });
}

class CmsDropdownField<T> extends CmsField {
  const CmsDropdownField({
    required super.name,
    required super.title,
    super.description,
    required CmsDropdownOption<T> super.option,
  });

  @override
  CmsDropdownOption<T> get option => super.option as CmsDropdownOption<T>;
}

class CmsDropdownFieldConfig<T> extends CmsFieldConfig {
  const CmsDropdownFieldConfig({
    super.name,
    super.title,
    super.description,
    CmsDropdownOption<T> super.option = const CmsDropdownOption(options: []),
  });

  @override
  List<Type> get supportedFieldTypes => [T];
}