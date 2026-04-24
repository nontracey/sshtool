import 'package:flutter/material.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final String? message;

  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    required this.isConnecting,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(width: 8),
          Text(
            _getStatusText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getTextColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (isConnecting) {
      return SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.orange.shade700,
          ),
        ),
      );
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (isConnecting) {
      return Colors.orange.shade50;
    }
    return isConnected
        ? Colors.green.shade50
        : Theme.of(context).colorScheme.surfaceContainerHigh;
  }

  Color _getTextColor(BuildContext context) {
    if (isConnecting) {
      return Colors.orange.shade700;
    }
    return isConnected
        ? Colors.green.shade700
        : Theme.of(context).colorScheme.onSurfaceVariant;
  }

  String _getStatusText() {
    if (isConnecting) {
      return 'Connecting...';
    }
    return isConnected ? 'Connected' : 'Disconnected';
  }
}
