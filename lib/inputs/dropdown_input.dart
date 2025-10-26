import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/dropdown_field.dart';

@Preview(name: 'CmsDropdownInput')
Widget preview() => ShadApp(
  home: CmsDropdownInput<String>(
    field: const CmsDropdownField(
      name: 'category',
      title: 'Category',
      option: CmsDropdownOption(
        options: [
          DropdownOption(value: 'tech', label: 'Technology'),
          DropdownOption(value: 'health', label: 'Health'),
          DropdownOption(value: 'finance', label: 'Finance'),
        ],
        placeholder: 'Select a category',
      ),
    ),
  ),
);

class CmsDropdownInput<T> extends StatefulWidget {
  final CmsDropdownField<T> field;
  final CmsData? data;
  final ValueChanged<T?>? onChanged;

  const CmsDropdownInput({
    super.key,
    required this.field,
    this.data,
    this.onChanged,
  });

  @override
  State<CmsDropdownInput<T>> createState() => _CmsDropdownInputState<T>();
}

class _CmsDropdownInputState<T> extends State<CmsDropdownInput<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue =
        widget.data?.value as T? ?? widget.field.option.defaultValue;
  }

  @override
  void didUpdateWidget(CmsDropdownInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _selectedValue =
          widget.data?.value as T? ?? widget.field.option.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);
    final options = widget.field.option.options;

    if (options.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.title,
            style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('No options available', style: theme.textTheme.muted),
          ),
          if (widget.field.description != null) ...[
            const SizedBox(height: 4),
            Text(widget.field.description!, style: theme.textTheme.muted),
          ],
        ],
      );
    }

    // Convert dropdown options to select options
    final selectOptions =
        options
            .map(
              (option) =>
                  ShadOption<T>(value: option.value, child: Text(option.label)),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.field.title.isNotEmpty) ...[
          Text(
            widget.field.title,
            style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        ShadSelect<T>(
          placeholder: Text(
            widget.field.option.placeholder ?? 'Select an option...',
            style: theme.textTheme.muted,
          ),
          options: selectOptions,
          selectedOptionBuilder: (context, value) {
            final option = options.firstWhere(
              (opt) => opt.value == value,
              orElse:
                  () => DropdownOption(value: value, label: value.toString()),
            );
            return Text(option.label);
          },
          initialValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged?.call(value);
          },
          enabled: true,
        ),
        if (widget.field.description != null) ...[
          const SizedBox(height: 4),
          Text(widget.field.description!, style: theme.textTheme.muted),
        ],
      ],
    );
  }
}
