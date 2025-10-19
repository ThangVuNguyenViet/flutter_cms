import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/url_field.dart';

@Preview(name: 'CmsUrlInput')
Widget preview() => ShadApp(
  home: CmsUrlInput(
    field: const CmsUrlField(
      name: 'website',
      title: 'Website URL',
      option: CmsUrlOption(),
    ),
  ),
);

class CmsUrlInput extends StatelessWidget {
  final CmsUrlField field;
  final CmsData? data;

  const CmsUrlInput({super.key, required this.field, this.data});

  @override
  Widget build(BuildContext context) {
    if (field.option.hidden) {
      return const SizedBox.shrink();
    }

    return ShadInputFormField(
      initialValue: data?.value?.toString(),
      label: Text(field.title),
      placeholder: const Text('https://example.com'),
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value.isEmpty) {
          return null;
        }
        try {
          final uri = Uri.parse(value);
          if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
            return 'Please enter a valid URL starting with http:// or https://';
          }
        } catch (e) {
          return 'Please enter a valid URL';
        }
        return null;
      },
    );
  }
}
