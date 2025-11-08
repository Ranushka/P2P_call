import 'package:flutter/material.dart';

import '../../groups/models/group.dart';
import 'call_screen.dart';

class ConnectingScreen extends StatefulWidget {
  const ConnectingScreen({super.key});

  static const routeName = '/connecting';

  @override
  State<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _simulateConnection();
  }

  Future<void> _simulateConnection() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final group = ModalRoute.of(context)?.settings.arguments as Group?;
    Navigator.of(context).pushReplacementNamed(
      CallScreen.routeName,
      arguments: group,
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)?.settings.arguments as Group?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connecting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              group != null
                  ? 'Connecting to ${group.name}...'
                  : 'Setting up the call...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
