import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import '../core/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../fields/primitive/date_field.dart';

@Preview(name: 'CmsDateInput')
Widget preview() => ShadApp(
  home: CmsDateInput(
    field: const CmsDateField(
      name: 'birthdate',
      title: 'Birth Date',
      option: CmsDateOption(),
    ),
  ),
);

class CmsDateInput extends StatefulWidget {
  final CmsDateField field;
  final CmsData? data;
  final ValueChanged<DateTime?>? onChanged;

  const CmsDateInput({
    super.key,
    required this.field,
    this.data,
    this.onChanged,
  });

  @override
  State<CmsDateInput> createState() => _CmsDateInputState();
}

class _CmsDateInputState extends State<CmsDateInput> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.data?.value as DateTime?;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    return ShadDatePickerFormField(
      initialValue: _selectedDate,
      label: Text(widget.field.title),
      onChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
        widget.onChanged?.call(date);
      },
    );
  }
}
