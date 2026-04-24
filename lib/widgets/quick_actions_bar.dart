import 'package:flutter/material.dart';

class QuickActionsBar extends StatelessWidget {
  final VoidCallback onDisconnect;
  final VoidCallback onClear;
  final VoidCallback onRefresh;

  const QuickActionsBar({
    super.key,
    required this.onDisconnect,
    required this.onClear,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.refresh,
            label: 'Refresh',
            onTap: onRefresh,
          ),
          _buildActionButton(
            icon: Icons.clear_all,
            label: 'Clear',
            onTap: onClear,
          ),
          _buildActionButton(
            icon: Icons.content_copy,
            label: 'Copy',
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.link_off,
            label: 'Disconnect',
            onTap: onDisconnect,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
