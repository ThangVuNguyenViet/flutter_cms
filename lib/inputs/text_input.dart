import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/extensions/object_extensions.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/text_field.dart';

@Preview(name: 'CmsTextInput')
Widget preview() => ShadApp(
  home: CmsTextInput(
    field: CmsTextField(
      name: 'name',
      title: 'title',
      option: CmsTextOption(rows: 1),
    ),
  ),
);

class CmsTextInput extends StatelessWidget {
  final CmsTextField field;
  final CmsData? data;

  const CmsTextInput({super.key, required this.field, this.data});

  @override
  Widget build(BuildContext context) {
    if (field.option.hidden) {
      return const SizedBox.shrink();
    }

    final label =
        field.option.validation?.labelTransformer?.call(field.title) ??
        field.title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.option.deprecatedReason case String deprecatedReason)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Deprecated: $deprecatedReason',
              style: ShadTheme.of(
                context,
              ).textTheme.small.copyWith(color: Colors.red),
            ),
          ),
        ShadInputFormField(
          initialValue: data?.value ?? field.option.initialValue,
          description: field.option.description?.letOrNull(
            (desc) => Text(desc),
          ),
          label: Text(label),
          validator: field.option.validation?.labeledValidator(field.title),
          maxLines: field.option.rows,
          enabled: !field.option.readOnly,
        ),
      ],
    );
  }
}
