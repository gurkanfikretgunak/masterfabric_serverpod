import 'dart:io';
import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../lib/src/generated/protocol.dart';
import '../lib/src/generated/endpoints.dart';
import '../lib/src/services/translations/translation_service.dart';

/// Script to seed translations from JSON files
/// 
/// Usage:
///   dart bin/seed_translations.dart [locale] [namespace]
///   dart bin/seed_translations.dart en
///   dart bin/seed_translations.dart tr widgets
///   dart bin/seed_translations.dart --all
///   dart bin/seed_translations.dart --clear
/// 
/// JSON files should be in: assets/i18n/\<locale\>.i18n.json
/// Or: assets/i18n/\<namespace\>_\<locale\>.i18n.json for namespaced translations

void main(List<String> args) async {
  // Initialize Serverpod
  final serverpod = Serverpod(
    [],
    Protocol(),
    Endpoints(),
  );

  try {
    await serverpod.start();

    final session = await serverpod.createSession();
    final service = TranslationService();

    try {
      // Parse arguments
      if (args.contains('--help') || args.contains('-h')) {
        printUsage();
        return;
      }

      if (args.contains('--clear')) {
        await clearAllTranslations(session, service);
        return;
      }

      if (args.contains('--all')) {
        await seedAllTranslations(session, service);
        return;
      }

      // Seed specific locale
      if (args.isEmpty) {
        print('❌ Error: Please specify a locale or use --all to seed all locales');
        printUsage();
        exit(1);
      }

      final locale = args[0];
      final namespace = args.length > 1 ? args[1] : null;

      await seedTranslation(session, service, locale, namespace: namespace);
    } finally {
      await session.close();
    }
  } finally {
    await serverpod.shutdown();
  }
}

void printUsage() {
  print('''
🌍 Translation Seeder

Usage:
  dart bin/seed_translations.dart <locale> [namespace]
  dart bin/seed_translations.dart --all
  dart bin/seed_translations.dart --clear
  dart bin/seed_translations.dart --help

Examples:
  dart bin/seed_translations.dart en
  dart bin/seed_translations.dart tr widgets
  dart bin/seed_translations.dart --all

Options:
  <locale>          Locale code (e.g., en, tr, de)
  [namespace]       Optional namespace identifier
  --all             Seed all JSON files from assets/i18n/
  --clear           Clear all translations from database
  --help, -h        Show this help message

JSON File Locations:
  assets/i18n/<locale>.i18n.json
  assets/i18n/<namespace>_<locale>.i18n.json
''');
}

Future<void> seedTranslation(
  Session session,
  TranslationService service,
  String locale, {
  String? namespace,
}) async {
  try {
    print('📦 Loading translations for locale: $locale${namespace != null ? ' (namespace: $namespace)' : ''}');

    // Determine file path
    final fileName = namespace != null
        ? 'assets/i18n/${namespace}_$locale.i18n.json'
        : 'assets/i18n/$locale.i18n.json';

    final file = File(fileName);
    if (!file.existsSync()) {
      print('❌ Error: Translation file not found: $fileName');
      print('💡 Tip: Create the file or check the path');
      exit(1);
    }

    // Read and parse JSON
    final jsonString = await file.readAsString();
    final translations = jsonDecode(jsonString) as Map<String, dynamic>;

    print('✅ Loaded ${translations.length} translation keys');

    // Save to database
    final entry = await service.saveTranslations(
      session,
      locale,
      translations,
      namespace: namespace,
      isActive: true,
    );

    print('✅ Successfully saved translations!');
    print('   Locale: $locale');
    if (namespace != null) print('   Namespace: $namespace');
    print('   Entry ID: ${entry.id}');
    print('   Version: ${entry.version}');
    print('   Keys: ${translations.length}');
  } catch (e, stackTrace) {
    print('❌ Error seeding translations: $e');
    if (e is FormatException) {
      print('💡 Tip: Check that your JSON file is valid');
    }
    print('Stack trace: $stackTrace');
    exit(1);
  }
}

Future<void> seedAllTranslations(
  Session session,
  TranslationService service,
) async {
  print('🌍 Seeding all translations from assets/i18n/...\n');

  final i18nDir = Directory('assets/i18n');
  if (!i18nDir.existsSync()) {
    print('❌ Error: Directory not found: assets/i18n');
    print('💡 Tip: Create the directory and add your JSON files');
    exit(1);
  }

  final files = i18nDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.i18n.json'))
      .toList();

  if (files.isEmpty) {
    print('❌ Error: No .i18n.json files found in assets/i18n/');
    print('💡 Tip: Add translation files like: en.i18n.json, tr.i18n.json');
    exit(1);
  }

  print('Found ${files.length} translation file(s):\n');

  int successCount = 0;
  int errorCount = 0;

  for (final file in files) {
    try {
      // Parse filename: <namespace>_<locale>.i18n.json or <locale>.i18n.json
      final fileName = file.path.split('/').last;
      final baseName = fileName.replaceAll('.i18n.json', '');

      String locale;
      String? namespace;

      // Check if it's namespaced (contains underscore)
      if (baseName.contains('_')) {
        final parts = baseName.split('_');
        namespace = parts[0];
        locale = parts.sublist(1).join('_'); // Handle locales like zh-CN
      } else {
        locale = baseName;
      }

      print('📦 Processing: $fileName');
      await seedTranslation(session, service, locale, namespace: namespace);
      successCount++;
      print('');
    } catch (e) {
      print('❌ Failed to process ${file.path}: $e\n');
      errorCount++;
    }
  }

  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('✅ Successfully seeded: $successCount file(s)');
  if (errorCount > 0) {
    print('❌ Failed: $errorCount file(s)');
  }
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}

Future<void> clearAllTranslations(
  Session session,
  TranslationService service,
) async {
  print('🗑️  Clearing all translations from database...');

  try {
    // This would require a method in TranslationService to delete all
    // For now, we'll just print a message
    print('⚠️  Clear functionality not yet implemented');
    print('💡 Tip: Manually delete from translation_entry table or implement clear method');
  } catch (e) {
    print('❌ Error clearing translations: $e');
    exit(1);
  }
}
