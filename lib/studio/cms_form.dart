import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../inputs/array_input.dart';
import '../inputs/block_input.dart';
import '../inputs/boolean_input.dart';
import '../inputs/checkbox_input.dart';
import '../inputs/color_input.dart';
import '../inputs/cross_dataset_reference_input.dart';
import '../inputs/date_input.dart';
import '../inputs/datetime_input.dart';
import '../inputs/dropdown_input.dart';
import '../inputs/file_input.dart';
import '../inputs/geopoint_input.dart';
import '../inputs/image_input.dart';
import '../inputs/number_input.dart';
import '../inputs/object_input.dart';
import '../inputs/reference_input.dart';
import '../inputs/slug_input.dart';
import '../inputs/string_input.dart';
import '../inputs/text_input.dart';
import '../inputs/url_input.dart';
import '../models/cms_data.dart';
import '../models/fields.dart';
import '../models/fields/array_field.dart';
import '../models/fields/block_field.dart';
import '../models/fields/boolean_field.dart';
import '../models/fields/checkbox_field.dart';
import '../models/fields/color_field.dart';
import '../models/fields/cross_dataset_reference_field.dart';
import '../models/fields/date_field.dart';
import '../models/fields/datetime_field.dart';
import '../models/fields/dropdown_field.dart';
import '../models/fields/file_field.dart';
import '../models/fields/geopoint_field.dart';
import '../models/fields/image_field.dart';
import '../models/fields/number_field.dart';
import '../models/fields/object_field.dart';
import '../models/fields/reference_field.dart';
import '../models/fields/slug_field.dart';
import '../models/fields/string_field.dart';
import '../models/fields/text_field.dart';
import '../models/fields/url_field.dart';
import 'signals/cms_signals.dart';

/// Type definition for field value change callbacks
typedef OnFieldChanged = void Function(String fieldName, dynamic value);

/// Type definition for field input builder functions
typedef FieldInputBuilder =
    Widget Function(CmsField field, CmsData? data, OnFieldChanged onChanged);

/// Registry of field types to their corresponding input widgets.
/// Uses switch-case pattern for default field types with optional custom registry.
class CmsFieldInputRegistry {
  /// Map of custom field runtime types to their input builder functions
  static final Map<Type, FieldInputBuilder> _customRegistry =
      <Type, FieldInputBuilder>{};

  /// Register a custom field input builder for a specific field type.
  /// This allows extending the form system with custom field types.
  static void register<T extends CmsField>(FieldInputBuilder builder) {
    _customRegistry[T] = builder;
  }

  /// Get the input builder for a given field type using switch-case for defaults.
  /// Returns null if no builder is available for the type.
  static FieldInputBuilder? getBuilder(CmsField field) {
    // Check custom registry first
    if (_customRegistry.containsKey(field.runtimeType)) {
      return _customRegistry[field.runtimeType];
    }

    // Default field builders using switch-case
    switch (field) {
      case CmsTextField():
        return (field, data, onChanged) => CmsTextInput(
          field: field as CmsTextField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsStringField():
        return (field, data, onChanged) => CmsStringInput(
          field: field as CmsStringField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsNumberField():
        return (field, data, onChanged) => CmsNumberInput(
          field: field as CmsNumberField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsBooleanField():
        return (field, data, onChanged) => CmsBooleanInput(
          field: field as CmsBooleanField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsCheckboxField():
        return (field, data, onChanged) => CmsCheckboxInput(
          field: field as CmsCheckboxField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsDateField():
        return (field, data, onChanged) => CmsDateInput(
          field: field as CmsDateField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsDateTimeField():
        return (field, data, onChanged) => CmsDateTimeInput(
          field: field as CmsDateTimeField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsDropdownField():
        return (field, data, onChanged) => CmsDropdownInput(
          field: field as CmsDropdownField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsUrlField():
        return (field, data, onChanged) => CmsUrlInput(
          field: field as CmsUrlField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsSlugField():
        return (field, data, onChanged) => CmsSlugInput(
          field: field as CmsSlugField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsImageField():
        return (field, data, onChanged) => CmsImageInput(
          field: field as CmsImageField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsFileField():
        return (field, data, onChanged) => CmsFileInput(
          field: field as CmsFileField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsArrayField():
        return (field, data, onChanged) => CmsArrayInput(
          field: field as CmsArrayField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsBlockField():
        return (field, data, onChanged) => CmsBlockInput(
          field: field as CmsBlockField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsObjectField():
        return (field, data, onChanged) => CmsObjectInput(
          field: field as CmsObjectField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsReferenceField():
        return (field, data, onChanged) => CmsReferenceInput(
          field: field as CmsReferenceField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsCrossDatasetReferenceField():
        return (field, data, onChanged) => CmsCrossDatasetReferenceInput(
          field: field as CmsCrossDatasetReferenceField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsGeopointField():
        return (field, data, onChanged) => CmsGeopointInput(
          field: field as CmsGeopointField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      case CmsColorField():
        return (field, data, onChanged) => CmsColorInput(
          field: field as CmsColorField,
          data: data,
          onChanged: (value) => onChanged(field.name, value),
        );
      default:
        return null;
    }
  }

  /// Check if a builder is available for a given field type.
  static bool hasBuilder(CmsField field) {
    return getBuilder(field) != null;
  }
}

/// A form widget that renders fields based on CmsField list
class CmsForm extends StatefulWidget {
  final List<CmsField> fields;
  final Map<String, dynamic> data;
  final String? title;
  final String? description;
  final VoidCallback? onSave;
  final VoidCallback? onDiscard;

  const CmsForm({
    super.key,
    required this.fields,
    this.data = const {},
    this.title,
    this.description,
    this.onSave,
    this.onDiscard,
  });

  @override
  State<CmsForm> createState() => _CmsFormState();
}

class _CmsFormState extends State<CmsForm> {
  void _handleFieldChange(String fieldName, dynamic value) {
    // Update the document signal field directly for real-time sync
    documentDataSignal.updateField(fieldName, value);
  }

  Widget _buildFieldInput(CmsField field) {
    final fieldName = field.name;
    final data =
        widget.data[fieldName] != null
            ? CmsData(value: widget.data[fieldName], path: fieldName)
            : null;

    // Look up the builder for this field type in the registry
    final builder = CmsFieldInputRegistry.getBuilder(field);

    if (builder != null) {
      return builder(field, data, _handleFieldChange);
    }

    // If no builder found, return empty widget and log warning
    assert(
      false,
      'No input builder registered for field type: ${field.runtimeType}. '
      'Register a builder using CmsFieldInputRegistry.register<${field.runtimeType}>().',
    );
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header
          if (widget.title != null || widget.description != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null)
                            Text(widget.title!, style: theme.textTheme.h2),
                          if (widget.description != null)
                            Text(
                              widget.description!,
                              style: theme.textTheme.small.copyWith(
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (widget.onDiscard != null)
                          ShadButton.outline(
                            onPressed: widget.onDiscard,
                            child: const Text('Discard'),
                          ),
                        if (widget.onDiscard != null) const SizedBox(width: 8),
                        if (widget.onSave != null)
                          ShadButton(
                            onPressed: widget.onSave,
                            child: const Text('Save'),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          // Dynamic form fields
          ...widget.fields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildFieldInput(field),
            );
          }),
        ],
      ),
    );
  }
}
