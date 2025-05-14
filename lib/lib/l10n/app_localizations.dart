import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'dailyRoutines': 'Daily Routines',
      'currentStreak': 'Current Streak',
      'noRoutines': 'No routines tracked.',
    },
    'zh': {
      'dailyRoutines': '每日任务',
      'currentStreak': '当前连续',
      'noRoutines': '暂无任务。',
    },
  };

  String get dailyRoutines {
    return _localizedValues[locale.languageCode]!['dailyRoutines']!;
  }

  String get currentStreak {
    return _localizedValues[locale.languageCode]!['currentStreak']!;
  }

  String get noRoutines {
    return _localizedValues[locale.languageCode]!['noRoutines']!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 