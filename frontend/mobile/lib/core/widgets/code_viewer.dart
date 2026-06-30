import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiCodeView extends StatelessWidget {
  final String code;
  final String language;
  final String? filename;

  const ZawjatiCodeView({
    super.key,
    required this.code,
    this.language = '',
    this.filename,
  });

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');
    final lineCount = lines.length;

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.neutral850,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _HeaderBar(code: code, language: language, filename: filename),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(lineCount, (i) {
                    return SizedBox(
                      height: 20,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: AppThemeColors.neutral400,
                          height: 1.5,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: AppThemeMetrics.spacingMd),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lines.map((line) {
                    return SizedBox(
                      height: 20,
                      child: Text(
                        line,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: AppThemeColors.neutral0,
                          height: 1.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final String code;
  final String language;
  final String? filename;

  const _HeaderBar({
    required this.code,
    required this.language,
    this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeMetrics.spacingMd,
        vertical: AppThemeMetrics.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.neutral800,
        border: const Border(
          bottom: BorderSide(color: AppThemeColors.border, width: AppThemeMetrics.borderHairline),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.code_rounded, size: 16, color: AppThemeColors.hintText),
          const SizedBox(width: AppThemeMetrics.spacingSm),
          if (filename != null) ...[
            Text(
              filename!,
              style: AppThemeTextStyles.textTheme.labelSmall?.copyWith(
                color: AppThemeColors.neutral100,
              ),
            ),
            if (language.isNotEmpty) ...[
              const SizedBox(width: AppThemeMetrics.spacingSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppThemeColors.primaryAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppThemeMetrics.radiusXs),
                ),
                child: Text(
                  language,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppThemeColors.primaryAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ] else if (language.isNotEmpty)
            Text(
              language,
              style: AppThemeTextStyles.textTheme.labelSmall?.copyWith(
                color: AppThemeColors.neutral100,
              ),
            ),
          const Spacer(),
          InkWell(
            onTap: () => Clipboard.setData(ClipboardData(text: code)),
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.copy_rounded, size: 14, color: AppThemeColors.hintText),
                  const SizedBox(width: 4),
                  Text(
                    'Copy',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppThemeColors.hintText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
