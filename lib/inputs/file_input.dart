import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/file_field.dart';

@Preview(name: 'CmsFileInput')
Widget preview() => ShadApp(
      home: CmsFileInput(
        field: const CmsFileField(
          name: 'document',
          title: 'Document Upload',
          option: CmsFileOption(),
        ),
      ),
    );

class CmsFileInput extends StatefulWidget {
  final CmsFileField field;
  final CmsData? data;

  const CmsFileInput({super.key, required this.field, this.data});

  @override
  State<CmsFileInput> createState() => _CmsFileInputState();
}

class _CmsFileInputState extends State<CmsFileInput> {
  String? _fileUrl;
  String? _fileName;
  PlatformFile? _pickedFile;
  int? _fileSize;

  @override
  void initState() {
    super.initState();
    _fileUrl = widget.data?.value?.toString();
    if (_fileUrl != null) {
      _fileName = _fileUrl!.split('/').last;
    }
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedFile = result.files.first;
          _fileName = _pickedFile!.name;
          _fileSize = _pickedFile!.size;
          _fileUrl = null; // Clear URL if we have a local file
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }
  }

  void _removeFile() {
    setState(() {
      _fileUrl = null;
      _fileName = null;
      _pickedFile = null;
      _fileSize = null;
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  IconData _getFileIcon(String? fileName) {
    if (fileName == null) return Icons.insert_drive_file;

    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'ogg':
        return Icons.audio_file;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);
    final hasFile = _fileName != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.title,
          style: theme.textTheme.small,
        ),
        const SizedBox(height: 8),
        if (hasFile) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getFileIcon(_fileName),
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName!,
                        style: theme.textTheme.small,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_fileSize != null)
                        Text(
                          _formatFileSize(_fileSize!),
                          style: theme.textTheme.small.copyWith(
                            color: theme.colorScheme.mutedForeground,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: _removeFile,
                  tooltip: 'Remove file',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ShadButton(
            onPressed: _selectFile,
            child: const Text('Change File'),
          ),
        ] else
          ShadButton(
            onPressed: _selectFile,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload_file, size: 16),
                SizedBox(width: 8),
                Text('Upload File'),
              ],
            ),
          ),
      ],
    );
  }
}
