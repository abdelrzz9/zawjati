import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/features/documents/presentation/bloc/documents_bloc.dart';
import 'package:zawjati_mobile/features/documents/presentation/widgets/document_card.dart';
import 'package:zawjati_mobile/features/documents/presentation/widgets/upload_dialog.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<DocumentsBloc>().add(LoadDocuments());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppThemeMetrics.spacingMd,
              AppThemeMetrics.spacingSm,
              AppThemeMetrics.spacingMd,
              AppThemeMetrics.spacingSm,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search documents...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppThemeMetrics.spacingMd,
                  vertical: AppThemeMetrics.spacingSm,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DocumentsBloc, DocumentsState>(
              builder: (context, state) {
                if (state is DocumentsInitial || state is DocumentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DocumentsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_off_outlined,
                            size: AppThemeMetrics.iconLg * 2,
                            color: AppThemeColors.hintText,
                          ),
                          const SizedBox(height: AppThemeMetrics.spacingMd),
                          Text(
                            state.message,
                            style: TextStyle(color: AppThemeColors.hintText),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppThemeMetrics.spacingLg),
                          ElevatedButton(
                            onPressed: () {
                              context.read<DocumentsBloc>().add(LoadDocuments());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is DocumentsLoaded) {
                  final filtered = state.documents.where((d) {
                    if (_searchQuery.isEmpty) return true;
                    return d.filename.toLowerCase().contains(_searchQuery);
                  }).toList();

                  if (filtered.isEmpty && state.documents.isNotEmpty) {
                    return Center(
                      child: Text(
                        'No documents match "$_searchQuery"',
                        style: TextStyle(color: AppThemeColors.hintText),
                      ),
                    );
                  }

                  if (state.documents.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_open_outlined,
                              size: AppThemeMetrics.iconLg * 2,
                              color: AppThemeColors.hintText,
                            ),
                            const SizedBox(height: AppThemeMetrics.spacingMd),
                            Text(
                              'No documents yet',
                              style: TextStyle(
                                color: AppThemeColors.secondaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppThemeMetrics.spacingSm),
                            Text(
                              'Upload PDF, DOCX, TXT or MD files.',
                              style: TextStyle(
                                color: AppThemeColors.hintText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppThemeMetrics.spacingMd,
                          0,
                          AppThemeMetrics.spacingMd,
                          AppThemeMetrics.spacingXxl * 2,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppThemeMetrics.spacingSm),
                        itemBuilder: (context, index) {
                          final doc = filtered[index];
                          return DocumentCard(
                            document: doc,
                            onTap: () => context.push('/documents/${doc.id}'),
                            onDelete: () => _confirmDelete(doc.id, doc.filename),
                          );
                        },
                      ),
                      if (state.isUploading)
                        Positioned(
                          left: AppThemeMetrics.spacingMd,
                          right: AppThemeMetrics.spacingMd,
                          bottom: AppThemeMetrics.spacingXxl + AppThemeMetrics.spacingMd,
                          child: Container(
                            padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
                            decoration: BoxDecoration(
                              color: AppThemeColors.surface,
                              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
                              border: Border.all(color: AppThemeColors.border),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppThemeColors.primaryAccent,
                                  ),
                                ),
                                const SizedBox(width: AppThemeMetrics.spacingMd),
                                Text(
                                  'Uploading...',
                                  style: TextStyle(color: AppThemeColors.secondaryText),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await UploadDialog.show(context);
          if (result != null && mounted) {
            context.read<DocumentsBloc>().add(UploadDocument(
              filePath: result['path']!,
              filename: result['name']!,
            ));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(String id, String filename) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "$filename"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DocumentsBloc>().add(DeleteDocument(id));
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppThemeColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
