import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/boolean_field.dart';

@Preview(name: 'CmsBooleanInput')
Widget preview() => ShadApp(
      home: CmsBooleanInput(
        field: const CmsBooleanField(
          name: 'isActive',
          title: 'Is Active',
          option: CmsBooleanOption(),
        ),
      ),
    );

class CmsBooleanInput extends StatefulWidget {
  final CmsBooleanField field;
  final CmsData? data;

  const CmsBooleanInput({super.key, required this.field, this.data});

  @override
  State<CmsBooleanInput> createState() => _CmsBooleanInputState();
}

class _CmsBooleanInputState extends State<CmsBooleanInput> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.data?.value as bool? ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);

    return Row(
      children: [
        ShadSwitch(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
        ),
        const SizedBox(width: 12),
        Text(
          widget.field.title,
          style: theme.textTheme.small,
        ),
      ],
    );
  }
}
