import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';

class PersonalityCreatePage extends StatefulWidget {
  const PersonalityCreatePage({super.key});

  @override
  State<PersonalityCreatePage> createState() => _PersonalityCreatePageState();
}

class _PersonalityCreatePageState extends State<PersonalityCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _promptController = TextEditingController();

  double _warmth = 0.5;
  double _humor = 0.5;
  double _creativity = 0.5;
  double _responseLength = 0.5;
  double _emojiFrequency = 0.5;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Personality'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Create'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g. Mentor, Sage, Buddy',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe this personality',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextFormField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'System Prompt',
                  hintText: 'Instructions for how this personality behaves',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: AppTheme.spacingXl),
              Text(
                'Tone Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _buildSlider('Warmth', _warmth, Icons.whatshot_outlined),
              _buildSlider('Humor', _humor, Icons.emoji_emotions_outlined),
              _buildSlider('Creativity', _creativity, Icons.auto_fix_high),
              _buildSlider(
                  'Response Length', _responseLength, Icons.text_fields),
              _buildSlider(
                  'Emoji Frequency', _emojiFrequency, Icons.emoji_emotions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppThemeMetrics.iconSm),
              const SizedBox(width: AppTheme.spacingSm),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            onChanged: (v) {
              setState(() {
                switch (label) {
                  case 'Warmth':
                    _warmth = v;
                  case 'Humor':
                    _humor = v;
                  case 'Creativity':
                    _creativity = v;
                  case 'Response Length':
                    _responseLength = v;
                  case 'Emoji Frequency':
                    _emojiFrequency = v;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Custom personality created')),
    );
    Navigator.pop(context);
  }
}
