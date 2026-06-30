import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/features/documents/domain/entities/user_document.dart';
import 'package:zawjati_mobile/features/documents/presentation/bloc/documents_bloc.dart';
import 'package:intl/intl.dart';

class DocumentDetailPage extends StatelessWidget {
  final String documentId;

  const DocumentDetailPage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
      ),
      body: BlocBuilder<DocumentsBloc, DocumentsState>(
        builder: (context, state) {
          if (state is DocumentsLoaded) {
            final doc = state.documents.where((d) => d.id == documentId).firstOrNull;
            if (doc == null) {
              return Center(
                child: Text(
                  'Document not found',
                  style: TextStyle(color: AppThemeColors.hintText),
                ),
              );
            }
            return _DocumentContent(document: doc);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _DocumentContent extends StatelessWidget {
  final UserDocument document;

  const _DocumentContent({required this.document});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetadataCard(document: document),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          _InfoRow(
            label: 'File name',
            value: document.filename,
          ),
          _InfoRow(
            label: 'Type',
            value: document.type.toUpperCase(),
          ),
          _InfoRow(
            label: 'Size',
            value: document.formattedSize,
          ),
          _InfoRow(
            label: 'Created',
            value: DateFormat('MMM d, y HH:mm').format(document.createdAt),
          ),
          _InfoRow(
            label: 'Chunks',
            value: '${document.chunkCount}',
          ),
          const SizedBox(height: AppThemeMetrics.spacingLg),
          Text(
            'Citations',
            style: TextStyle(
              color: AppThemeColors.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
            decoration: BoxDecoration(
              color: AppThemeColors.inputFill,
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.auto_stories_outlined,
                  color: AppThemeColors.hintText,
                  size: AppThemeMetrics.iconLg * 1.5,
                ),
                const SizedBox(height: AppThemeMetrics.spacingSm),
                Text(
                  'Citations from this document will appear here during conversations.',
                  style: TextStyle(
                    color: AppThemeColors.hintText,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataCard extends StatelessWidget {
  final UserDocument document;

  const _MetadataCard({required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _statusBorderColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
            ),
            child: Icon(
              _typeIcon,
              color: _statusBorderColor,
              size: AppThemeMetrics.iconLg,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppThemeMetrics.spacingXs),
                _StatusBadge(status: document.status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _statusBorderColor {
    switch (document.status) {
      case DocumentStatus.ready:
        return AppThemeColors.success;
      case DocumentStatus.indexing:
        return AppThemeColors.warning;
      case DocumentStatus.error:
        return AppThemeColors.error;
    }
  }

  IconData get _typeIcon {
    switch (document.type.toLowerCase()) {
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
        label = 'Ready for queries';
        icon = Icons.check_circle;
      case DocumentStatus.indexing:
        color = AppThemeColors.warning;
        label = 'Indexing in progress';
        icon = Icons.sync;
      case DocumentStatus.error:
        color = AppThemeColors.error;
        label = 'Indexing failed';
        icon = Icons.error_outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: AppThemeMetrics.spacingXs),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppThemeMetrics.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppThemeColors.hintText,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppThemeColors.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
