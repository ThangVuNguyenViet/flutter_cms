import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/date_field.dart';

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

  const CmsDateInput({super.key, required this.field, this.data, this.onChanged});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.title,
          style: ShadTheme.of(context).textTheme.small,
        ),
        const SizedBox(height: 8),
        ShadButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
              widget.onChanged?.call(date);
            }
          },
          child: Text(
            _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : 'Select date',
          ),
        ),
      ],
    );
  }
}
