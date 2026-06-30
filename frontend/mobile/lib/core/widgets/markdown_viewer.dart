import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiMarkdownView extends StatelessWidget {
  final String data;
  final bool selectable;

  const ZawjatiMarkdownView({
    super.key,
    required this.data,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final styleSheet = MarkdownStyleSheet(
      h1: AppThemeTextStyles.textTheme.displaySmall,
      h2: AppThemeTextStyles.textTheme.headlineLarge,
      h3: AppThemeTextStyles.textTheme.headlineMedium,
      h4: AppThemeTextStyles.textTheme.titleLarge,
      p: AppThemeTextStyles.textTheme.bodyMedium,
      a: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
        color: AppThemeColors.primaryAccent,
        decoration: TextDecoration.underline,
      ),
      code: TextStyle(
        backgroundColor: AppThemeColors.surfaceHigh,
        fontFamily: 'monospace',
        fontSize: 13,
        color: AppThemeColors.accent,
      ),
      codeblockDecoration: BoxDecoration(
        color: AppThemeColors.neutral850,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
      ),
      codeblockPadding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppThemeColors.primaryAccent.withValues(alpha: 0.5),
            width: 3,
          ),
        ),
        color: AppThemeColors.surfaceHigh.withValues(alpha: 0.5),
      ),
      blockquotePadding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      blockquote: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
        color: AppThemeColors.secondaryText,
        fontStyle: FontStyle.italic,
      ),
      listBullet: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
        color: AppThemeColors.primaryText,
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppThemeColors.divider,
            width: AppThemeMetrics.borderHairline,
          ),
        ),
      ),
      tableBorder: TableBorder.all(
        color: AppThemeColors.border,
        width: AppThemeMetrics.borderHairline,
      ),
      tableHead: AppThemeTextStyles.textTheme.labelLarge?.copyWith(
        color: AppThemeColors.primaryText,
        fontWeight: FontWeight.bold,
      ),
      tableBody: AppThemeTextStyles.textTheme.bodySmall,
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.all(AppThemeMetrics.spacingSm),
      strong: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      em: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
        fontStyle: FontStyle.italic,
      ),
      del: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
        decoration: TextDecoration.lineThrough,
      ),
      checkbox: AppThemeTextStyles.textTheme.bodyMedium,
    );

    final md = Markdown(
      data: data,
      styleSheet: styleSheet,
      selectable: selectable,
      onTapLink: (text, href, title) {
        if (href != null) launchUrl(Uri.parse(href));
      },
      builders: {
        'pre': _CodeBlockBuilder(),
      },
    );

    if (selectable) {
      return SelectionArea(child: md);
    }

    return md;
  }
}

class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(element, TextStyle? preferredStyle) {
    final code = element.textContent;
    final language = element.attributes['class']?.replaceFirst('language-', '') ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppThemeMetrics.spacingSm),
      decoration: BoxDecoration(
        color: AppThemeColors.neutral850,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (language.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppThemeMetrics.spacingMd,
                vertical: AppThemeMetrics.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppThemeColors.neutral800,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppThemeMetrics.radiusMd),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    language,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: AppThemeColors.hintText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Clipboard.setData(ClipboardData(text: code)),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: AppThemeColors.hintText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
            child: Text(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: AppThemeColors.neutral0,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
