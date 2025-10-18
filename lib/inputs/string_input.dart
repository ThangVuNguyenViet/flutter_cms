import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/extensions/object_extensions.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/string_field.dart';

@Preview(name: 'CmsStringInput')
Widget preview() => ShadApp(
      home: CmsStringInput(
        field: const CmsStringField(
          name: 'username',
          title: 'Username',
          option: CmsStringOption(),
        ),
      ),
    );

class CmsStringInput extends StatelessWidget {
  final CmsStringField field;
  final CmsData? data;

  const CmsStringInput({super.key, required this.field, this.data});

  @override
  Widget build(BuildContext context) {
    if (field.option.hidden) {
      return const SizedBox.shrink();
    }

    return ShadInputFormField(
      initialValue: data?.value?.toString(),
      description: field.description?.letOrNull(
        (desc) => Text(desc),
      ),
      label: Text(field.title),
      placeholder: const Text('Enter text...'),
      maxLines: 1,
    );
  }
}
