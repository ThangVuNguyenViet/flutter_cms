import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/image_field.dart';

@Preview(name: 'CmsImageInput')
Widget preview() => ShadApp(
      home: CmsImageInput(
        field: const CmsImageField(
          name: 'avatar',
          title: 'Profile Image',
          option: CmsImageOption(hotspot: false),
        ),
      ),
    );

class CmsImageInput extends StatefulWidget {
  final CmsImageField field;
  final CmsData? data;

  const CmsImageInput({super.key, required this.field, this.data});

  @override
  State<CmsImageInput> createState() => _CmsImageInputState();
}

class _CmsImageInputState extends State<CmsImageInput> {
  String? _imageUrl;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.data?.value?.toString();
  }

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _pickedImage = image;
          _imageUrl = null; // Clear URL if we have a local file
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _pickedImage = photo;
          _imageUrl = null; // Clear URL if we have a local file
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take photo: $e')),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imageUrl = null;
      _pickedImage = null;
    });
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreview(ShadThemeData theme) {
    if (_pickedImage != null) {
      // Show local file preview
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: kIsWeb
              ? Image.network(
                  _pickedImage!.path,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    );
                  },
                )
              : Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    );
                  },
                ),
        ),
      );
    } else if (_imageUrl != null) {
      // Show URL-based image
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            _imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, size: 48),
              );
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option?.hidden ?? false) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);
    final hasImage = _imageUrl != null || _pickedImage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.title,
          style: theme.textTheme.small,
        ),
        const SizedBox(height: 8),
        if (hasImage) ...[
          _buildImagePreview(theme),
          const SizedBox(height: 8),
          Row(
            children: [
              ShadButton(
                onPressed: _showImageSourceDialog,
                child: const Text('Change Image'),
              ),
              const SizedBox(width: 8),
              ShadButton.destructive(
                onPressed: _removeImage,
                child: const Text('Remove'),
              ),
            ],
          ),
        ] else
          ShadButton(
            onPressed: _showImageSourceDialog,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload, size: 16),
                SizedBox(width: 8),
                Text('Upload Image'),
              ],
            ),
          ),
        if (widget.field.option?.hotspot ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Hotspot enabled',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ),
        if (_pickedImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'File: ${_pickedImage!.name}',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.mutedForeground,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
