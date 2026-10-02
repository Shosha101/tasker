import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/provider/task_provider.dart';
import 'package:tasker/screens/splash_screen.dart';
import 'package:tasker/screens/task_list_screen.dart';
import 'package:tasker/services/navigation_services.dart';
import 'package:tasker/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(SplashScreen(onInitializationComplete: () {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('ar'),
        child: MyApp(),
      ),
    );
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
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routes: {
          '/main': (BuildContext context) => TaskListScreen(),
        },
      ),
    );
  }
}
