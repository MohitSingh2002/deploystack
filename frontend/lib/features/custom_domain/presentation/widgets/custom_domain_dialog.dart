import 'package:deploystack/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDomainDialog extends StatefulWidget {

  final Function(String, String)? onSave;

  const CustomDomainDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<CustomDomainDialog> createState() => _CustomDomainDialogState();
}

class _CustomDomainDialogState extends State<CustomDomainDialog> {
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  final _subdomainController = TextEditingController();
  bool _useSubdomain = false;
  int _step = 1;

  @override
  void dispose() {
    _domainController.dispose();
    _subdomainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _step == 1 ? _buildStep1() : _buildStep2(),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Domain',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure a custom domain for your project',
            style: TextStyle(
              color: AppColors.white54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _domainController,
            style: const TextStyle(color: AppColors.white),
            decoration: _inputDecoration(label: 'Domain', hint: 'example.com'),
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Domain is required';
              }
              final regex = RegExp(
                r'^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$',
              );
              if (!regex.hasMatch(value.trim())) {
                return 'Enter a valid domain (e.g. example.com)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Use Subdomain',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Switch(
                value: _useSubdomain,
                onChanged: (value) => setState(() => _useSubdomain = value),
                activeTrackColor: AppColors.buttonColor.withValues(alpha: 0.5),
                activeThumbColor: AppColors.buttonColor,
              ),
            ],
          ),
          if (_useSubdomain) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _subdomainController,
              style: const TextStyle(color: AppColors.white),
              decoration: _inputDecoration(label: 'Subdomain', hint: 'www'),
              validator: (value) {
                if (!_useSubdomain) return null;
                if (value == null || value.trim().isEmpty) {
                  return 'Subdomain is required';
                }
                final regex = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$');
                if (!regex.hasMatch(value.trim())) {
                  return 'Enter a valid subdomain';
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.white70),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _step = 2);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final domain = _domainController.text.trim();
    final subdomain = _subdomainController.text.trim();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DNS Configuration',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add the following records to your DNS provider',
          style: TextStyle(
            color: AppColors.white54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Type',
                      style: TextStyle(
                        color: AppColors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: AppColors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Value',
                      style: TextStyle(
                        color: AppColors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.white24, height: 16),
              if (_useSubdomain)
                _dnsRecord(type: 'A', name: subdomain, value: 'Your VPS IPv4')
              else ...[
                _dnsRecord(type: 'A', name: '@', value: 'Your VPS IPv4'),
                const SizedBox(height: 8),
                _dnsRecord(type: 'CNAME', name: 'www', value: domain),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Upon doing this, click Save (Please wait 5 minutes before clicking Save)',
          style: TextStyle(
            color: AppColors.white38,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => setState(() => _step = 1),
              child: const Text(
                'Back',
                style: TextStyle(color: AppColors.white70),
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.white70),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onSave?.call(domain, _useSubdomain ? subdomain : '');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dnsRecord({required String type, required String name, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: AppColors.buttonColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(color: AppColors.white, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.white38, fontSize: 13),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String label, required String hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.white38),
      labelStyle: const TextStyle(color: AppColors.white70),
      filled: true,
      fillColor: AppColors.backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.buttonColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
