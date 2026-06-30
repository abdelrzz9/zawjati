import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';

class UploadDialog extends StatefulWidget {
  const UploadDialog({super.key});

  static Future<Map<String, String>?> show(BuildContext context) {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const UploadDialog(),
    );
  }

  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc', 'txt', 'md'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  void _upload() {
    if (_selectedFile != null && _selectedFile!.path != null) {
      Navigator.of(context).pop({
        'path': _selectedFile!.path!,
        'name': _selectedFile!.name,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Document'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
              decoration: BoxDecoration(
                color: _selectedFile != null
                    ? AppThemeColors.selected
                    : AppThemeColors.inputFill,
                borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
                border: Border.all(
                  color: _selectedFile != null
                      ? AppThemeColors.primaryAccent
                      : AppThemeColors.inputBorder,
                  width: AppThemeMetrics.borderHairline,
                ),
              ),
              child: _selectedFile != null
                  ? Column(
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          color: AppThemeColors.primaryAccent,
                          size: AppThemeMetrics.iconLg,
                        ),
                        const SizedBox(height: AppThemeMetrics.spacingSm),
                        Text(
                          _selectedFile!.name,
                          style: TextStyle(
                            color: AppThemeColors.primaryText,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          _formatSize(_selectedFile!.size),
                          style: TextStyle(
                            color: AppThemeColors.hintText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: AppThemeColors.hintText,
                          size: AppThemeMetrics.iconLg,
                        ),
                        const SizedBox(height: AppThemeMetrics.spacingSm),
                        Text(
                          'Tap to select a file',
                          style: TextStyle(
                            color: AppThemeColors.hintText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: AppThemeMetrics.spacingXs),
                        Text(
                          'PDF, DOCX, TXT, MD',
                          style: TextStyle(
                            color: AppThemeColors.subtitleText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedFile != null ? _upload : null,
              child: const Text('Upload'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
