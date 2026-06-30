import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:zawjati_mobile/core/theme/index.dart';

class ChatMarkdownView extends StatelessWidget {
  final String content;
  final bool isUser;

  const ChatMarkdownView({
    super.key,
    required this.content,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: content,
      selectable: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          color: isUser ? AppThemeColors.neutral0 : AppThemeColors.neutral0,
          fontSize: 15,
          height: 1.5,
        ),
        h1: TextStyle(
          color: AppThemeColors.neutral0,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        h2: TextStyle(
          color: AppThemeColors.neutral0,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        h3: TextStyle(
          color: AppThemeColors.neutral0,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        listBullet: TextStyle(
          color: isUser ? AppThemeColors.neutral0 : AppThemeColors.neutral100,
        ),
        code: TextStyle(
          color: AppThemeColors.accent,
          backgroundColor: AppThemeColors.neutral800,
          fontSize: 13,
        ),
        codeblockDecoration: BoxDecoration(
          color: AppThemeColors.neutral850,
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
          border: Border.all(color: AppThemeColors.neutral700),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppThemeColors.primaryAccent,
              width: 3,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppThemeColors.neutral600),
          ),
        ),
        codeblockPadding: const EdgeInsets.all(12),
        strong: TextStyle(
          color: AppThemeColors.neutral0,
          fontWeight: FontWeight.bold,
        ),
        em: const TextStyle(fontStyle: FontStyle.italic),
        del: TextStyle(
          color: AppThemeColors.neutral300,
          decoration: TextDecoration.lineThrough,
        ),
        a: TextStyle(
          color: AppThemeColors.primaryAccent,
          decoration: TextDecoration.underline,
        ),
        img: const TextStyle(color: AppThemeColors.accent),
      ),
      builders: {
        'code': CodeBlockBuilder(isUser: isUser),
      },
    );
  }
}

class CodeBlockBuilder extends MarkdownElementBuilder {
  final bool isUser;

  CodeBlockBuilder({this.isUser = false});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.tag != 'pre') return null;
    if (element.children == null) return null;

    String codeText = '';
    String lang = '';
    for (final child in element.children!) {
      if (child is md.Element && child.tag == 'code') {
        codeText = child.textContent;
        lang = child.attributes['class']?.replaceAll('language-', '') ?? '';
        break;
      }
    }

    if (codeText.isEmpty) return null;

    return _CodeBlock(
      code: codeText,
      language: lang,
      isUser: isUser,
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  final String language;
  final bool isUser;

  const _CodeBlock({
    required this.code,
    required this.language,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppThemeColors.neutral850,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
        border: Border.all(color: AppThemeColors.neutral700),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (language.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: AppThemeColors.neutral800,
              child: Row(
                children: [
                  Text(
                    language,
                    style: const TextStyle(
                      color: AppThemeColors.neutral300,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => _copyToClipboard(context),
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: AppThemeColors.neutral300,
                    ),
                  ),
                ],
              ),
            ),
          if (language.isEmpty)
            Positioned(
              top: 6,
              right: 8,
              child: InkWell(
                onTap: () => _copyToClipboard(context),
                child: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppThemeColors.neutral300,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: HighlightView(
              code,
              language: language.isNotEmpty ? language : 'plaintext',
              theme: draculaTheme,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    // ignore: deprecated_member_use
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
