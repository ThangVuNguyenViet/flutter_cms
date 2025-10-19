import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../inputs/array_input.dart';
import '../inputs/block_input.dart';
import '../inputs/boolean_input.dart';
import '../inputs/cross_dataset_reference_input.dart';
import '../inputs/date_input.dart';
import '../inputs/datetime_input.dart';
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
import '../models/fields/cross_dataset_reference_field.dart';
import '../models/fields/date_field.dart';
import '../models/fields/datetime_field.dart';
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

/// A form widget that renders fields based on CmsFieldConfig list
class CmsForm extends StatefulWidget {
  final List<CmsFieldConfig> fields;
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
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = Map.from(widget.data);
  }

  Widget _buildFieldInput(CmsFieldConfig fieldConfig) {
    final fieldName = fieldConfig.name ?? '';
    final fieldTitle = fieldConfig.title ?? '';
    final data = _formData[fieldName] != null
        ? CmsData(value: _formData[fieldName], path: fieldName)
        : null;

    // Match field config to appropriate input widget
    if (fieldConfig is CmsTextFieldConfig) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: CmsTextInput(
          field: CmsTextField(
            name: fieldName,
            title: fieldTitle,
            option:
                fieldConfig.option as CmsTextOption? ?? const CmsTextOption(),
          ),
          data: data,
        ),
      );
    } else if (fieldConfig is CmsStringFieldConfig) {
      return CmsStringInput(
        field: CmsStringField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsStringOption? ??
              const CmsStringOption(),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsNumberFieldConfig) {
      return CmsNumberInput(
        field: CmsNumberField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsNumberOption? ??
              const CmsNumberOption(validation: ''),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsBooleanFieldConfig) {
      return CmsBooleanInput(
        field: CmsBooleanField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsBooleanOption? ??
              const CmsBooleanOption(),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsDateFieldConfig) {
      return CmsDateInput(
        field: CmsDateField(
          name: fieldName,
          title: fieldTitle,
          option:
              fieldConfig.option as CmsDateOption? ?? const CmsDateOption(),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsDateTimeFieldConfig) {
      return CmsDateTimeInput(
        field: CmsDateTimeField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsDateTimeOption? ??
              const CmsDateTimeOption(),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsUrlFieldConfig) {
      return CmsUrlInput(
        field: CmsUrlField(
          name: fieldName,
          title: fieldTitle,
          option:
              fieldConfig.option as CmsUrlOption? ?? const CmsUrlOption(),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsSlugFieldConfig) {
      return CmsSlugInput(
        field: CmsSlugField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsSlugOption? ??
              const CmsSlugOption(source: '', maxLength: 96),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsImageFieldConfig) {
      return CmsImageInput(
        field: CmsImageField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsImageOption?,
        ),
        data: data,
      );
    } else if (fieldConfig is CmsFileFieldConfig) {
      return CmsFileInput(
        field: CmsFileField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsFileOption? ??
              const CmsFileOption(),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsArrayFieldConfig) {
      return CmsArrayInput(
        field: CmsArrayField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsArrayOption?,
        ),
        data: data,
      );
    } else if (fieldConfig is CmsBlockFieldConfig) {
      return CmsBlockInput(
        field: CmsBlockField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsBlockOption? ??
              const CmsBlockOption(),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsObjectFieldConfig) {
      return CmsObjectInput(
        field: CmsObjectField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsObjectOption? ??
              const CmsObjectOption(fields: []),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsReferenceFieldConfig) {
      return CmsReferenceInput(
        field: CmsReferenceField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsReferenceOption? ??
              const CmsReferenceOption(to: CmsReferenceTo(type: '')),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsCrossDatasetReferenceFieldConfig) {
      return CmsCrossDatasetReferenceInput(
        field: CmsCrossDatasetReferenceField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsCrossDatasetReferenceOption? ??
              const CmsCrossDatasetReferenceOption(dataset: '', to: []),
        ),
        data: data,
      );
    } else if (fieldConfig is CmsGeopointFieldConfig) {
      return CmsGeopointInput(
        field: CmsGeopointField(
          name: fieldName,
          title: fieldTitle,
          option: fieldConfig.option as CmsGeopointOption? ??
              const CmsGeopointOption(),
        ),
        data: data,
      );
    }

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
                            Text(
                              widget.title!,
                              style: theme.textTheme.h2,
                            ),
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
          ...widget.fields.map((fieldConfig) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildFieldInput(fieldConfig),
            );
          }),
        ],
      ),
    );
  }
}