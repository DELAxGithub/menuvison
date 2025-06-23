import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'config/env_config.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  runApp(const MenuVisionApp());
}

class MenuVisionApp extends StatelessWidget {
  const MenuVisionApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuVision',
      theme: AppTheme.lightTheme,
      home: const MainTabScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.info),
            label: 'About',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomeScreen();
          case 1:
            return const AboutScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}