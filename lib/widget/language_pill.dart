import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

/// Switches between Arabic and English; the label names the other language.
class LanguagePill extends StatelessWidget {
  const LanguagePill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Material(
      color: AppColors.primarySoft,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.setLocale(Locale(isArabic ? 'en' : 'ar')),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                context.tr('other_language'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
