import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/call/screens/call_screen.dart';
import 'features/call/screens/connecting_screen.dart';
import 'features/groups/controllers/group_controller.dart';
import 'features/home/home_screen.dart';
import 'theme/app_theme.dart';

class P2PCallApp extends StatelessWidget {
  const P2PCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupController()..bootstrap(),
      child: MaterialApp(
        title: 'Link P2P Call',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          ConnectingScreen.routeName: (_) => const ConnectingScreen(),
          CallScreen.routeName: (_) => const CallScreen(),
        },
      ),
    );
  }
}
