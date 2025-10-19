import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/array_field.dart';

@Preview(name: 'CmsArrayInput')
Widget preview() => ShadApp(
      home: CmsArrayInput(
        field: const CmsArrayField(
          name: 'tags',
          title: 'Tags',
          option: CmsArrayOption(
            of: [CmsArrayOf(type: 'string')],
          ),
        ),
      ),
    );

class CmsArrayInput extends StatefulWidget {
  final CmsArrayField field;
  final CmsData? data;

  const CmsArrayInput({super.key, required this.field, this.data});

  @override
  State<CmsArrayInput> createState() => _CmsArrayInputState();
}

class _CmsArrayInputState extends State<CmsArrayInput> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = (widget.data?.value as List?)?.cast<String>() ?? [];
  }

  void _addItem() {
    setState(() {
      _items.add('');
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _updateItem(int index, String value) {
    setState(() {
      _items[index] = value;
    });
  }

  void _moveItemUp(int index) {
    if (index > 0) {
      setState(() {
        final item = _items.removeAt(index);
        _items.insert(index - 1, item);
      });
    }
  }

  void _moveItemDown(int index) {
    if (index < _items.length - 1) {
      setState(() {
        final item = _items.removeAt(index);
        _items.insert(index + 1, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.field.title,
                style: theme.textTheme.large.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ShadButton(
                size: ShadButtonSize.sm,
                onPressed: _addItem,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 4),
                    Text('Add'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_items.isEmpty)
            Center(
              child: Text(
                'No items. Click "Add" to create one.',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ShadInputFormField(
                          initialValue: _items[index],
                          placeholder: const Text('Enter value...'),
                          onChanged: (value) => _updateItem(index, value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward, size: 18),
                        onPressed: index > 0 ? () => _moveItemUp(index) : null,
                        tooltip: 'Move up',
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward, size: 18),
                        onPressed: index < _items.length - 1
                            ? () => _moveItemDown(index)
                            : null,
                        tooltip: 'Move down',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => _removeItem(index),
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
