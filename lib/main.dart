import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/provider/task_provider.dart';
import 'package:tasker/screens/splash_screen.dart';
import 'package:tasker/screens/task_list_screen.dart';
import 'package:tasker/services/navigation_services.dart';
import 'package:tasker/themes/app_theme.dart';

void main() {
  runApp(SplashScreen(onInitializationComplete: () {
    runApp(MyApp());
  }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        final provider = TaskProvider();
        provider.initialize(); // Ensure TaskProvider initializes Hive
        return provider;
      },
      child: MaterialApp(
        initialRoute: '/main',
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Tasker',
        theme: AppTheme.lightTheme,
        routes: {
          '/main': (BuildContext context) => TaskListScreen(),
        },
      ),
    );
  }
}
