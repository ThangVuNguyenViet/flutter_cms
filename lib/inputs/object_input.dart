import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:flutter_cms/models/fields.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/object_field.dart';
import '../models/fields/string_field.dart';
import 'string_input.dart';

@Preview(name: 'CmsObjectInput')
Widget preview() => ShadApp(
      home: CmsObjectInput(
        field: const CmsObjectField(
          name: 'address',
          title: 'Address',
          option: CmsObjectOption(
            fields: [
              CmsStringFieldConfig(name: 'street', title: 'Street'),
              CmsStringFieldConfig(name: 'city', title: 'City'),
              CmsStringFieldConfig(name: 'zipCode', title: 'Zip Code'),
            ],
          ),
        ),
      ),
    );

class CmsObjectInput extends StatelessWidget {
  final CmsObjectField field;
  final CmsData? data;

  const CmsObjectInput({super.key, required this.field, this.data});

  Widget _buildFieldInput(CmsFieldConfig fieldConfig) {
    // For now, we only support string fields in objects
    // TODO: Support all field types recursively
    if (fieldConfig is CmsStringFieldConfig) {
      return CmsStringInput(
        field: CmsStringField(
          name: fieldConfig.name ?? '',
          title: fieldConfig.title ?? '',
          option: fieldConfig.option as CmsStringOption,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (field.option.hidden) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.title,
            style: theme.textTheme.large.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...field.option.fields.map((fieldConfig) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildFieldInput(fieldConfig),
            );
          }),
        ],
      ),
    );
  }
}
