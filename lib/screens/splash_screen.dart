
// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../services/hive_service.dart';

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
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 250,
          width: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}