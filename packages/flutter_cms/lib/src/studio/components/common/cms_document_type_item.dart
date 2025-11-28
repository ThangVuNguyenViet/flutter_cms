import 'package:flutter/material.dart';
import 'package:flutter_cms_annotation/flutter_cms_annotation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/signals/cms_signals.dart';

/// A navigation item widget for a CmsDocumentType
class CmsDocumentTypeItem extends StatelessWidget {
  final CmsDocumentType documentType;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const CmsDocumentTypeItem({
    super.key,
    required this.documentType,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            // Update the global signal
            selectedDocumentSignal.selectDocument(documentType);
            // Call the optional onTap callback
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.15)
                            : theme.colorScheme.muted.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ?? Icons.description,
                    size: 20,
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.mutedForeground,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        documentType.title,
                        style: theme.textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.foreground,
                          fontSize: 14,
                        ),
                      ),
                      if (documentType.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          documentType.description,
                          style: theme.textTheme.muted.copyWith(
                            fontSize: 12,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Selection indicator
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
