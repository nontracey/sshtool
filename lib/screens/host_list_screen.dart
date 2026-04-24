import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssh_tool/models/ssh_host.dart';
import 'package:ssh_tool/providers/hosts_provider.dart';

class HostListScreen extends ConsumerStatefulWidget {
  const HostListScreen({super.key});

  @override
  ConsumerState<HostListScreen> createState() => _HostListScreenState();
}

class _HostListScreenState extends ConsumerState<HostListScreen> {
  String _selectedGroup = 'all';

  @override
  Widget build(BuildContext context) {
    final hosts = ref.watch(hostsProvider);
    final groups = ref.read(hostsProvider.notifier).getGroups();
    
    final filteredHosts = _selectedGroup == 'all' 
        ? hosts 
        : hosts.where((h) => h.group == _selectedGroup).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildGroupFilter(groups),
          Expanded(
            child: filteredHosts.isEmpty
                ? _buildEmptyState()
                : _buildHostList(filteredHosts),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHostDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGroupFilter(List<String> groups) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip('all', 'All', Icons.list),
          ...groups.map((group) => _buildFilterChip(group, group, Icons.folder)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: _selectedGroup == value,
        onSelected: (selected) {
          setState(() {
            _selectedGroup = value;
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.computer, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No SSH Hosts',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first SSH host by tapping the + button',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostList(List<SshHost> hosts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hosts.length,
      itemBuilder: (context, index) {
        final host = hosts[index];
        return _buildHostCard(host);
      },
    );
  }

  Widget _buildHostCard(SshHost host) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _connectToHost(host),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _parseColor(host.color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.computer,
                      color: _parseColor(host.color),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          host.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${host.username}@${host.host}:${host.port}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, host),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Last connected: ${_formatDate(host.lastConnected)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Icon(Icons.link, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${host.connectionCount} connections',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return Theme.of(context).primaryColor;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Theme.of(context).primaryColor;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _connectToHost(SshHost host) {
    Navigator.pushNamed(
      context,
      '/terminal',
      arguments: host,
    );
  }

  void _handleMenuAction(String action, SshHost host) {
    switch (action) {
      case 'edit':
        _showEditHostDialog(host);
        break;
      case 'duplicate':
        ref.read(hostsProvider.notifier).addHost(
          host.copyWith(
            id: '',
            name: '${host.name} (Copy)',
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmDialog(host);
        break;
    }
  }

  void _showAddHostDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddHostDialog(),
    );
  }

  void _showEditHostDialog(SshHost host) {
    showDialog(
      context: context,
      builder: (context) => AddHostDialog(host: host),
    );
  }

  void _showDeleteConfirmDialog(SshHost host) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Host'),
        content: Text('Are you sure you want to delete "${host.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(hostsProvider.notifier).deleteHost(host.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AddHostDialog extends StatefulWidget {
  final SshHost? host;
  
  const AddHostDialog({super.key, this.host});

  @override
  State<AddHostDialog> createState() => _AddHostDialogState();
}

class _AddHostDialogState extends State<AddHostDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _groupController;
  
  String _authMethod = 'password';
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.host?.name ?? '');
    _hostController = TextEditingController(text: widget.host?.host ?? '');
    _portController = TextEditingController(text: widget.host?.port.toString() ?? '22');
    _usernameController = TextEditingController(text: widget.host?.username ?? '');
    _passwordController = TextEditingController(text: widget.host?.password ?? '');
    _groupController = TextEditingController(text: widget.host?.group ?? 'default');
    
    if (widget.host?.privateKey != null) {
      _authMethod = 'key';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.host == null ? 'Add SSH Host' : 'Edit SSH Host'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'My Server',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Host',
                  hintText: '192.168.1.1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a host';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  hintText: '22',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a port';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'root',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'password', label: Text('Password')),
                  ButtonSegment(value: 'key', label: Text('Key')),
                ],
                selected: {_authMethod},
                onSelectionChanged: (Set<String> selection) {
                  setState(() {
                    _authMethod = selection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_authMethod == 'password')
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _groupController,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  hintText: 'default',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveHost,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveHost() {
    if (!_formKey.currentState!.validate()) return;
    
    final host = SshHost(
      id: widget.host?.id ?? '',
      name: _nameController.text,
      host: _hostController.text,
      port: int.parse(_portController.text),
      username: _usernameController.text,
      password: _authMethod == 'password' ? _passwordController.text : null,
      group: _groupController.text,
      createdAt: widget.host?.createdAt,
    );
    
    final notifier = ProviderScope.containerOf(context).read(hostsProvider.notifier);
    if (widget.host == null) {
      notifier.addHost(host);
    } else {
      notifier.updateHost(host);
    }
    
    Navigator.pop(context);
  }
}
