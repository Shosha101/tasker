// Renders the screens off-screen with sample tasks, in Arabic and English.
// Run: flutter test --update-goldens tool/screens_golden_test.dart  (PNGs land in tool/shots/)
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasker/model/task_model.dart';
import 'package:tasker/provider/task_provider.dart';
import 'package:tasker/screens/splash_screen.dart';
import 'package:tasker/screens/task_list_screen.dart';
import 'package:tasker/themes/app_theme.dart';

class SeededProvider extends TaskProvider {
  SeededProvider(this.seeded);
  final List<Task> seeded;
  @override
  List<Task> get tasks => seeded;
}

const sample = {
  'ar': [
    ('مراجعة طلب الدمج الخاص بشاشة الدخول', false),
    ('تجهيز عرض السبرنت ليوم الخميس مع لقطات من النسخة الجديدة وملاحظات الفريق', false),
    ('اجتماع الفريق الساعة 10:00', false),
    ('تحديث أيقونة التطبيق', false),
    ('كتابة اختبارات الوحدات', false),
    ('إصلاح تجاوز النص في شاشة الدخول', true),
    ('تدوين ملاحظات الاجتماع', true),
  ],
  'en': [
    ('Review the login screen pull request', false),
    ('Prepare the sprint demo for Thursday with shots of the new build and the team notes', false),
    ('Team meeting at 10:00', false),
    ('Update the app icon', false),
    ('Write unit tests', false),
    ('Fix the login text overflow', true),
    ('Write up the meeting notes', true),
  ],
};
const searchWord = {'ar': 'اجتماع', 'en': 'meeting'};

Future<void> loadFonts() async {
  Future<ByteData> file(String path) async => ByteData.view((await File(path).readAsBytes()).buffer);
  final plex = FontLoader(AppTheme.fontFamily);
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    plex.addFont(file('assets/fonts/IBMPlexSansArabic-$weight.ttf'));
  }
  await plex.load();
  final sdk = File(Platform.resolvedExecutable).parent.parent.parent.parent.path;
  await (FontLoader('MaterialIcons')..addFont(file('$sdk/artifacts/material_fonts/materialicons-regular.otf'))).load();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    await loadFonts();
  });

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    tester.view.padding = const FakeViewPadding(top: 88);
    tester.view.viewPadding = const FakeViewPadding(top: 88);
    addTearDown(tester.view.reset);
  }

  Future<void> pumpApp(WidgetTester tester, String lang, {bool empty = false}) async {
    phone(tester);
    final tasks = [
      if (!empty)
        for (final (title, done) in sample[lang]!) Task(title: title, isCompleted: done),
    ];
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          key: UniqueKey(),
          supportedLocales: const [Locale('ar'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          startLocale: Locale(lang),
          saveLocale: false,
          child: ChangeNotifierProvider<TaskProvider>.value(
            value: SeededProvider(tasks),
            child: Builder(
              builder: (context) => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: TaskListScreen(),
              ),
            ),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$name.png'));
  }

  testWidgets('splash', (tester) async {
    debugDisableShadows = false;
    phone(tester);
    // The splash starts the storage and waits a second; let that run in real time.
    await tester.runAsync(() async {
      await tester.pumpWidget(SplashScreen(onInitializationComplete: () {}));
      await Future<void>.delayed(const Duration(milliseconds: 1500));
    });
    await tester.pump();
    await expectLater(find.byType(SplashScreen), matchesGoldenFile('shots/00-splash.png'));
    debugDisableShadows = true;
  });

  for (final lang in ['ar', 'en']) {
    testWidgets('$lang list, search and details', (tester) async {
      debugDisableShadows = false;
      await pumpApp(tester, lang);
      await shot(tester, '$lang-01-list');

      await tester.tap(find.text(sample[lang]![1].$1));
      await shot(tester, '$lang-02-details');
      await tester.tapAt(const Offset(190, 150));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, searchWord[lang]!);
      await tester.pump(const Duration(milliseconds: 400));
      FocusManager.instance.primaryFocus?.unfocus();
      await shot(tester, '$lang-03-search');
      debugDisableShadows = true;
    });

    testWidgets('$lang empty', (tester) async {
      debugDisableShadows = false;
      await pumpApp(tester, lang, empty: true);
      await shot(tester, '$lang-04-empty');
      debugDisableShadows = true;
    });
  }
}
