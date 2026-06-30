import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/features/documents/domain/entities/user_document.dart';
import 'package:intl/intl.dart';

class DocumentCard extends StatelessWidget {
  final UserDocument document;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
        decoration: BoxDecoration(
          color: AppThemeColors.surface,
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
          border: Border.all(
            color: _statusBorderColor,
            width: AppThemeMetrics.borderHairline,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppThemeColors.selected,
                borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
              ),
              child: Icon(
                _iconForType(document.type),
                color: AppThemeColors.primaryAccent,
                size: AppThemeMetrics.iconMd,
              ),
            ),
            const SizedBox(width: AppThemeMetrics.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.filename,
                    style: TextStyle(
                      color: AppThemeColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppThemeMetrics.spacing2xs),
                  Row(
                    children: [
                      Text(
                        document.formattedSize,
                        style: TextStyle(
                          color: AppThemeColors.hintText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: AppThemeMetrics.spacingSm),
                      Text(
                        DateFormat('MMM d, y').format(document.createdAt),
                        style: TextStyle(
                          color: AppThemeColors.hintText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: AppThemeMetrics.spacingSm),
                      Text(
                        '${document.chunkCount} chunks',
                        style: TextStyle(
                          color: AppThemeColors.hintText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppThemeMetrics.spacingSm),
            _StatusBadge(status: document.status),
            const SizedBox(width: AppThemeMetrics.spacingSm),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_outline,
                color: AppThemeColors.hintText,
                size: AppThemeMetrics.iconMd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _statusBorderColor {
    switch (document.status) {
      case DocumentStatus.ready:
        return AppThemeColors.success.withValues(alpha: 0.3);
      case DocumentStatus.indexing:
        return AppThemeColors.warning.withValues(alpha: 0.3);
      case DocumentStatus.error:
        return AppThemeColors.error.withValues(alpha: 0.3);
    }
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'docx':
      case 'doc':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'md':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final DocumentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case DocumentStatus.ready:
        color = AppThemeColors.success;
        label = 'Ready';
        icon = Icons.check_circle;
      case DocumentStatus.indexing:
        color = AppThemeColors.warning;
        label = 'Indexing';
        icon = Icons.sync;
      case DocumentStatus.error:
        color = AppThemeColors.error;
        label = 'Error';
        icon = Icons.error_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeMetrics.spacingSm,
        vertical: AppThemeMetrics.spacing2xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: AppThemeMetrics.spacingXs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
