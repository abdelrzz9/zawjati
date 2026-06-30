import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiFileViewer extends StatelessWidget {
  final String filename;
  final int? fileSize;
  final String? fileUrl;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  const ZawjatiFileViewer({
    super.key,
    required this.filename,
    this.fileSize,
    this.fileUrl,
    this.onDownload,
    this.onTap,
  });

  IconData get _fileIcon {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_rounded;
      case 'zip':
      case 'rar':
      case 'tar':
      case 'gz':
        return Icons.folder_zip_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image_rounded;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.videocam_rounded;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
        return Icons.audio_file_rounded;
      case 'txt':
        return Icons.article_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color get _iconColor {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return const Color(0xFFF87171);
      case 'doc':
      case 'docx':
        return const Color(0xFF60A5FA);
      case 'xls':
      case 'xlsx':
        return const Color(0xFF34D399);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return const Color(0xFFFBBF24);
      default:
        return AppThemeColors.hintText;
    }
  }

  String get _formattedSize {
    if (fileSize == null) return '';
    final bytes = fileSize!;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppThemeMetrics.spacingSm),
                  decoration: BoxDecoration(
                    color: _iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
                  ),
                  child: Icon(
                    _fileIcon,
                    size: 28,
                    color: _iconColor,
                  ),
                ),
                const SizedBox(width: AppThemeMetrics.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        filename,
                        style: AppThemeTextStyles.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_formattedSize.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          _formattedSize,
                          style: AppThemeTextStyles.textTheme.labelSmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (onDownload != null)
                  IconButton(
                    icon: const Icon(Icons.download_rounded, size: 20),
                    color: AppThemeColors.primaryAccent,
                    onPressed: onDownload,
                    splashRadius: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
