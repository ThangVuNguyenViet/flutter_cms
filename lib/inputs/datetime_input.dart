import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/datetime_field.dart';

@Preview(name: 'CmsDateTimeInput')
Widget preview() => ShadApp(
  home: CmsDateTimeInput(
    field: const CmsDateTimeField(
      name: 'createdAt',
      title: 'Created At',
      option: CmsDateTimeOption(),
    ),
  ),
);

class CmsDateTimeInput extends StatefulWidget {
  final CmsDateTimeField field;
  final CmsData? data;
  final ValueChanged<DateTime?>? onChanged;

  const CmsDateTimeInput({super.key, required this.field, this.data, this.onChanged});

  @override
  State<CmsDateTimeInput> createState() => _CmsDateTimeInputState();
}

class _CmsDateTimeInputState extends State<CmsDateTimeInput> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = switch (widget.data?.value) {
      DateTime dt => dt,
      String s => DateTime.tryParse(s),
      _ => null,
    };
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime:
          _selectedDateTime != null
              ? TimeOfDay.fromDateTime(_selectedDateTime!)
              : TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    widget.onChanged?.call(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.field.title, style: ShadTheme.of(context).textTheme.small),
        const SizedBox(height: 8),
        ShadButton(
          onPressed: _selectDateTime,
          child: Text(
            _selectedDateTime != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)
                : 'Select date and time',
          ),
        ),
      ],
    );
  }
}
