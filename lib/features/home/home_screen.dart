import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../call/screens/connecting_screen.dart';
import '../groups/controllers/group_controller.dart';
import '../groups/models/group.dart';
import 'widgets/create_group_dialog.dart';
import 'widgets/group_list_tile.dart';
import 'widgets/join_link_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GroupController>();
    final groups = controller.groups;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groups'),
        actions: [
          IconButton(
            tooltip: 'Join via link',
            icon: const Icon(Icons.link),
            onPressed: () => _showJoinLinkSheet(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: groups.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return GroupListTile(
                    group: group,
                    onTap: () => _openConnecting(context, group),
                    onToggleActive: (value) =>
                        context.read<GroupController>().toggleActive(group.id, value),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Create Group'),
      ),
    );
  }

  void _openCreateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const CreateGroupDialog(),
    );
  }

  void _showJoinLinkSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const JoinLinkBottomSheet(),
    );
  }

  void _openConnecting(BuildContext context, Group group) {
    Navigator.of(context).pushNamed(
      ConnectingScreen.routeName,
      arguments: group,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          const Text(
            'No groups yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new room or join with a link to get started.',
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
