import 'package:flutter/material.dart';

import '../../groups/models/group.dart';

class GroupListTile extends StatelessWidget {
  const GroupListTile({
    super.key,
    required this.group,
    required this.onTap,
    required this.onToggleActive,
  });

  final Group group;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggleActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _buildSubtitle(),
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: group.isActive,
              onChanged: onToggleActive,
            ),
            const SizedBox(height: 4),
            Text(
              group.isActive ? 'Active' : 'Idle',
              style: TextStyle(
                fontSize: 12,
                color: group.isActive
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final count = group.participants.length;
    if (count == 0) {
      return 'No participants yet';
    }
    if (count <= 3) {
      return group.participants.join(', ');
    }
    final truncated = group.participants.take(3).join(', ');
    return '$truncated +${count - 3} more';
  }
}
