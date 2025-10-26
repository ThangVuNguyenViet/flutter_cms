import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/array_field.dart';

@Preview(name: 'CmsArrayInput')
Widget preview() => ShadApp(
  home: CmsArrayInput(
    field: CmsArrayField(
      name: 'tags',
      title: 'Tags',
      option: const CmsArrayOption(),
      itemBuilder: (context, value) => Text(value),
    ),
  ),
);

class CmsArrayInput<T> extends StatefulWidget {
  final CmsArrayField field;
  final CmsData? data;
  final ValueChanged<List?>? onChanged;

  const CmsArrayInput({
    super.key,
    required this.field,
    this.data,
    this.onChanged,
  });

  @override
  State<CmsArrayInput<T>> createState() => _CmsArrayInputState<T>();
}

class _CmsArrayInputState<T> extends State<CmsArrayInput<T>> {
  late List<T> _items;

  @override
  void initState() {
    super.initState();
    _items = (widget.data?.value as List?)?.cast<T>() ?? [];
  }

  void _addItem() {
    setState(() {
      // For now, we'll need a factory method or default value for T
      // This is a simplified approach - in practice, you'd need a way to create default values
      if (T == String) {
        _items.add('' as T);
      } else if (T == int) {
        _items.add(0 as T);
      } else {
        // For other types, you might need a factory function
        throw UnsupportedError(
          'Default value creation not implemented for type $T',
        );
      }
    });
    widget.onChanged?.call(_items);
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    widget.onChanged?.call(_items);
  }


  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
    widget.onChanged?.call(_items);
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
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                return Padding(
                  key: ValueKey('item_$index'),
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.drag_handle,
                        size: 18,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: widget.field.itemBuilder(context, _items[index]),
                      ),
                      const SizedBox(width: 8),
                      ShadIconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => _removeItem(index),
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
