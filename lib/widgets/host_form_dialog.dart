import 'package:flutter/material.dart';
import 'package:ssh_tool/models/ssh_host.dart';

class HostFormDialog extends StatefulWidget {
  final SshHost? host;
  final Function(SshHost) onSave;

  const HostFormDialog({
    super.key,
    this.host,
    required this.onSave,
  });

  @override
  State<HostFormDialog> createState() => _HostFormDialogState();
}

class _HostFormDialogState extends State<HostFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _groupController;
  late TextEditingController _keyController;

  String _authMethod = 'password';
  String _selectedColor = 'blue';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.host?.name ?? '');
    _hostController = TextEditingController(text: widget.host?.host ?? '');
    _portController = TextEditingController(text: widget.host?.port.toString() ?? '22');
    _usernameController = TextEditingController(text: widget.host?.username ?? '');
    _passwordController = TextEditingController(text: widget.host?.password ?? '');
    _groupController = TextEditingController(text: widget.host?.group ?? 'default');
    _keyController = TextEditingController(text: widget.host?.privateKey ?? '');
    
    if (widget.host?.privateKey != null) {
      _authMethod = 'key';
    }
    
    _selectedColor = widget.host?.color ?? 'blue';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _groupController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        hint: 'My Server',
                        icon: Icons.label_outline,
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _hostController,
                        label: 'Host',
                        hint: '192.168.1.1 or example.com',
                        icon: Icons.computer,
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              hint: 'root',
                              icon: Icons.person_outline,
                              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _portController,
                              label: 'Port',
                              hint: '22',
                              icon: Icons.settings_ethernet,
                              keyboardType: TextInputType.number,
                              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildAuthMethodSelector(),
                      const SizedBox(height: 16),
                      if (_authMethod == 'password')
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: true,
                        ),
                      if (_authMethod == 'key')
                        _buildTextField(
                          controller: _keyController,
                          label: 'Private Key',
                          icon: Icons.vpn_key,
                          maxLines: 5,
                        ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _groupController,
                        label: 'Group',
                        hint: 'default',
                        icon: Icons.folder_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildColorSelector(),
                    ],
                  ),
                ),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 12),
          Text(
            widget.host == null ? 'Add SSH Host' : 'Edit SSH Host',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      validator: validator,
    );
  }

  Widget _buildAuthMethodSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(
          value: 'password',
          label: Text('Password'),
          icon: Icon(Icons.lock_outline),
        ),
        ButtonSegment(
          value: 'key',
          label: Text('SSH Key'),
          icon: Icon(Icons.vpn_key),
        ),
      ],
      selected: {_authMethod},
      onSelectionChanged: (Set<String> selection) {
        setState(() {
          _authMethod = selection.first;
        });
      },
    );
  }

  Widget _buildColorSelector() {
    final colors = [
      'blue', 'indigo', 'purple', 'pink', 'red',
      'orange', 'yellow', 'green', 'teal', 'cyan',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            final isSelected = _selectedColor == color;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getColor(color),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 3,
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColor(String colorName) {
    final colors = {
      'blue': Colors.blue,
      'indigo': Colors.indigo,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'red': Colors.red,
      'orange': Colors.orange,
      'yellow': Colors.amber,
      'green': Colors.green,
      'teal': Colors.teal,
      'cyan': Colors.cyan,
    };
    return colors[colorName] ?? Colors.blue;
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final host = SshHost(
      id: widget.host?.id ?? '',
      name: _nameController.text,
      host: _hostController.text,
      port: int.parse(_portController.text),
      username: _usernameController.text,
      password: _authMethod == 'password' ? _passwordController.text : null,
      privateKey: _authMethod == 'key' ? _keyController.text : null,
      group: _groupController.text,
      color: _selectedColor,
      createdAt: widget.host?.createdAt,
      lastConnected: widget.host?.lastConnected,
      connectionCount: widget.host?.connectionCount ?? 0,
    );

    widget.onSave(host);
    Navigator.pop(context);
  }
}
