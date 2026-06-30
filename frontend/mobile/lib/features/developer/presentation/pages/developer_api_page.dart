import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/app_theme_metrics.dart';
import '../../../../core/theme/app_theme_text_styles.dart';
import '../bloc/developer_bloc.dart';

class DeveloperApiPage extends StatelessWidget {
  const DeveloperApiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<DeveloperBloc>(),
      child: const _ApiBody(),
    );
  }
}

class _ApiBody extends StatefulWidget {
  const _ApiBody();

  @override
  State<_ApiBody> createState() => _ApiBodyState();
}

class _ApiBodyState extends State<_ApiBody> {
  String _selectedMethod = 'GET';
  final _endpointController = TextEditingController();
  final _bodyController = TextEditingController();
  final _headersController = TextEditingController();

  final _methods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];

  @override
  void dispose() {
    _endpointController.dispose();
    _bodyController.dispose();
    _headersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DeveloperBloc>().state;

    return Scaffold(
      backgroundColor: AppThemeColors.background,
      appBar: AppBar(
        title: const Text('API Tester'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
        children: [
          _MethodSelector(
            methods: _methods,
            selectedMethod: _selectedMethod,
            onChanged: (method) {
              setState(() => _selectedMethod = method);
            },
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          TextField(
            controller: _endpointController,
            decoration: const InputDecoration(
              labelText: 'Endpoint',
              hintText: '/api/endpoint',
              prefixIcon: Icon(Icons.link),
            ),
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          TextField(
            controller: _headersController,
            decoration: const InputDecoration(
              labelText: 'Headers (JSON)',
              hintText: '{"Authorization": "Bearer ..."}',
              prefixIcon: Icon(Icons.code),
            ),
            maxLines: 2,
          ),
          if (_selectedMethod != 'GET' && _selectedMethod != 'DELETE')
            Column(
              children: [
                const SizedBox(height: AppThemeMetrics.spacingMd),
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Body (JSON)',
                    hintText: '{"key": "value"}',
                    prefixIcon: Icon(Icons.data_object),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          const SizedBox(height: AppThemeMetrics.spacingLg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<DeveloperBloc>().add(
                  TestApiEndpoint(
                    method: _selectedMethod,
                    endpoint: _endpointController.text,
                    headers: _parseHeaders(_headersController.text),
                    body: _bodyController.text.isNotEmpty
                        ? _bodyController.text
                        : null,
                  ),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Send Request'),
            ),
          ),
          if (state.apiTestResult != null) ...[
            const SizedBox(height: AppThemeMetrics.spacingLg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
              decoration: BoxDecoration(
                color: AppThemeColors.surface,
                borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
                border: Border.all(color: AppThemeColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Response',
                    style: AppThemeTextStyles.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppThemeMetrics.spacingSm),
                  SelectableText(
                    state.apiTestResult!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: AppThemeColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, String>? _parseHeaders(String headersJson) {
    if (headersJson.trim().isEmpty) return null;
    try {
      final map = <String, String>{};
      final cleaned = headersJson.trim();
      if (cleaned.startsWith('{') && cleaned.endsWith('}')) {
        final pairs = cleaned
            .substring(1, cleaned.length - 1)
            .split(',');
        for (final pair in pairs) {
          final parts = pair.split(':');
          if (parts.length == 2) {
            final key = parts[0].trim().replaceAll('"', '');
            final value = parts[1].trim().replaceAll('"', '');
            map[key] = value;
          }
        }
      }
      return map.isNotEmpty ? map : null;
    } catch (_) {
      return null;
    }
  }
}

class _MethodSelector extends StatelessWidget {
  final List<String> methods;
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const _MethodSelector({
    required this.methods,
    required this.selectedMethod,
    required this.onChanged,
  });

  Color _methodColor(String method) {
    switch (method) {
      case 'GET':
        return AppThemeColors.success;
      case 'POST':
        return AppThemeColors.info;
      case 'PUT':
        return AppThemeColors.warning;
      case 'PATCH':
        return AppThemeColors.primaryAccent;
      case 'DELETE':
        return AppThemeColors.error;
      default:
        return AppThemeColors.subtitleText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: methods.map((method) {
        final isSelected = method == selectedMethod;
        return Padding(
          padding: const EdgeInsets.only(right: AppThemeMetrics.spacingSm),
          child: ChoiceChip(
            label: Text(method),
            selected: isSelected,
            onSelected: (_) => onChanged(method),
            selectedColor: _methodColor(method).withValues(alpha: 0.2),
            labelStyle: TextStyle(
              color: isSelected ? _methodColor(method) : AppThemeColors.primaryText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected ? _methodColor(method) : AppThemeColors.border,
            ),
          ),
        );
      }).toList(),
    );
  }
}
