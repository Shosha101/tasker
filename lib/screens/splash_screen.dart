
// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../services/hive_service.dart';
import '../themes/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({required this.onInitializationComplete, Key? key})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late HiveService getHiveService = GetIt.instance.get<HiveService>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final Logger logger = Logger();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    try {
      _registerServices();
      await getHiveService.intitializeHive();
      logger.i("Services registered successfully and Hive initialized.");
    } catch (e) {
      logger.e("Error initializing Hive: $e");
    }

    await Future.delayed(const Duration(seconds: 1));
    widget.onInitializationComplete();
  }

  void _registerServices() {
    final hiveService = HiveService();
    GetIt.instance.registerSingleton<HiveService>(hiveService);
  }

  @override
  Widget build(BuildContext context) {
    // Shown before the app (and its MaterialApp) exists, so it sets its own
    // text direction and font.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: AppColors.background,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 68,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tasker',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}