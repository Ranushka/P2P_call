import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../groups/controllers/group_controller.dart';
import '../../groups/models/group.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  static const routeName = '/call';

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isMuted = false;
  bool isCameraOn = true;

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)?.settings.arguments as Group?;
    final participants = group?.participants ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(group?.name ?? 'Call'),
        actions: [
          IconButton(
            tooltip: 'Leave call',
            onPressed: () => _leaveCall(context, group),
            icon: const Icon(Icons.call_end),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: participants.isEmpty ? 1 : participants.length,
              itemBuilder: (context, index) {
                if (participants.isEmpty) {
                  return const _WaitingForPeersTile();
                }
                final name = participants[index];
                return _ParticipantTile(
                  name: name,
                  showCamera: isCameraOn,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CallControlButton(
                  icon: isMuted ? Icons.mic_off : Icons.mic,
                  label: isMuted ? 'Unmute' : 'Mute',
                  onTap: () => setState(() => isMuted = !isMuted),
                ),
                const SizedBox(width: 16),
                _CallControlButton(
                  icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
                  label: isCameraOn ? 'Camera off' : 'Camera on',
                  onTap: () => setState(() => isCameraOn = !isCameraOn),
                ),
                const SizedBox(width: 16),
                _CallControlButton(
                  icon: Icons.call_end,
                  label: 'Leave',
                  isDestructive: true,
                  onTap: () => _leaveCall(context, group),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _leaveCall(BuildContext context, Group? group) {
    if (group != null) {
      context.read<GroupController>().toggleActive(group.id, false);
    }
    Navigator.of(context).popUntil((route) => route.settings.name == '/');
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({
    required this.name,
    required this.showCamera,
  });

  final String name;
  final bool showCamera;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (!showCamera)
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 12,
            bottom: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      showCamera ? Icons.videocam : Icons.volume_up,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaitingForPeersTile extends StatelessWidget {
  const _WaitingForPeersTile();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'Waiting for others to join…',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CallControlButton extends StatelessWidget {
  const _CallControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDestructive ? colorScheme.error : colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
