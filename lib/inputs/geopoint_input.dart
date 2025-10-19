import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/geopoint_field.dart';

@Preview(name: 'CmsGeopointInput')
Widget preview() => ShadApp(
      home: CmsGeopointInput(
        field: const CmsGeopointField(
          name: 'location',
          title: 'Location',
          option: CmsGeopointOption(),
        ),
      ),
    );

class CmsGeopointInput extends StatefulWidget {
  final CmsGeopointField field;
  final CmsData? data;

  const CmsGeopointInput({super.key, required this.field, this.data});

  @override
  State<CmsGeopointInput> createState() => _CmsGeopointInputState();
}

class _CmsGeopointInputState extends State<CmsGeopointInput> {
  late TextEditingController _latController;
  late TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    // Parse initial value if it's a geopoint object
    final data = widget.data?.value;
    double? lat;
    double? lng;

    if (data is Map) {
      lat = data['lat'] as double?;
      lng = data['lng'] as double?;
    }

    _latController = TextEditingController(text: lat?.toString());
    _lngController = TextEditingController(text: lng?.toString());
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  String? _validateCoordinate(String? value, String type) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'Please enter a valid number';
    }

    if (type == 'latitude') {
      if (doubleValue < -90 || doubleValue > 90) {
        return 'Latitude must be between -90 and 90';
      }
    } else if (type == 'longitude') {
      if (doubleValue < -180 || doubleValue > 180) {
        return 'Longitude must be between -180 and 180';
      }
    }

    return null;
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
          Text(
            widget.field.title,
            style: theme.textTheme.large.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ShadInputFormField(
                  controller: _latController,
                  label: const Text('Latitude'),
                  placeholder: const Text('e.g., 37.7749'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                  ],
                  validator: (value) => _validateCoordinate(value, 'latitude'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ShadInputFormField(
                  controller: _lngController,
                  label: const Text('Longitude'),
                  placeholder: const Text('e.g., -122.4194'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                  ],
                  validator: (value) =>
                      _validateCoordinate(value, 'longitude'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.mutedForeground,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Latitude: -90 to 90, Longitude: -180 to 180',
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Optional: Add map picker button
          ShadButton.outline(
            size: ShadButtonSize.sm,
            onPressed: () {
              // TODO: Implement map picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Map picker coming soon!'),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map, size: 16),
                SizedBox(width: 8),
                Text('Pick from map'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
