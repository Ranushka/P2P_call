import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../call/screens/connecting_screen.dart';
import '../../groups/controllers/group_controller.dart';
import '../../groups/models/group.dart';

class JoinLinkBottomSheet extends StatefulWidget {
  const JoinLinkBottomSheet({super.key});

  @override
  State<JoinLinkBottomSheet> createState() => _JoinLinkBottomSheetState();
}

class _JoinLinkBottomSheetState extends State<JoinLinkBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();
  final _nameController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _linkController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + viewInsets,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join group via link',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: 'Invite link',
                hintText: 'https://p2p.call/room/xyz123',
                errorText: _error,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a room link';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your name (optional)',
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _join,
                child: const Text('Join'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _join() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final controller = context.read<GroupController>();
    final Group? group = controller.joinByLink(
      _linkController.text.trim(),
      participant: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
    );

    if (group == null) {
      setState(() {
        _error = 'No group matches this link';
      });
      return;
    }

    setState(() {
      _error = null;
    });

    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(
      ConnectingScreen.routeName,
      arguments: group,
    );
  }
}
