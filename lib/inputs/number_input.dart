import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/number_field.dart';

@Preview(name: 'CmsNumberInput')
Widget preview() => ShadApp(
  home: CmsNumberInput(
    field: const CmsNumberField(
      name: 'age',
      title: 'Age',
      option: CmsNumberOption(validation: ''),
    ),
  ),
);

class CmsNumberInput extends StatelessWidget {
  final CmsNumberField field;
  final CmsData? data;

  const CmsNumberInput({super.key, required this.field, this.data});

  @override
  Widget build(BuildContext context) {
    if (field.option.hidden) {
      return const SizedBox.shrink();
    }

    return ShadInputFormField(
      initialValue: data?.value?.toString(),
      label: Text(field.title),
      placeholder: const Text('Enter number...'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (value) {
        if (value.isEmpty) {
          return null;
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        // Apply custom validation if provided
        if (field.option.validation.isNotEmpty) {
          // TODO: Implement custom validation logic
        }
        return null;
      },
    );
  }
}
