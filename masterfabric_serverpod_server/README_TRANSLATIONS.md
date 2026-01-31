# Translation Seeding Guide

This guide explains how to upload language JSON files to the database for the multi-language service.

## Quick Start

### Method 1: Using Serverpod Script Command (Recommended)

```bash
# Seed all translations from assets/i18n/
serverpod run seed-translations

# Seed specific locale
serverpod run seed-translations -- en

# Seed with namespace
serverpod run seed-translations -- tr widgets
```

### Method 2: Using Shell Scripts

**Linux/Mac:**
```bash
# Seed all translations
bash scripts/seed_translations.sh --all

# Seed specific locale
bash scripts/seed_translations.sh en

# Seed with namespace
bash scripts/seed_translations.sh tr widgets
```

**Windows PowerShell:**
```powershell
# Seed all translations
.\scripts\seed_translations.ps1 --all

# Seed specific locale
.\scripts\seed_translations.ps1 en

# Seed with namespace
.\scripts\seed_translations.ps1 tr widgets
```

### Method 3: Direct Dart Script

```bash
# Seed all translations
dart bin/seed_translations.dart --all

# Seed specific locale
dart bin/seed_translations.dart en

# Seed with namespace
dart bin/seed_translations.dart tr widgets

# Show help
dart bin/seed_translations.dart --help
```

## JSON File Format

### File Location

Place your translation JSON files in: `assets/i18n/`

### File Naming Convention

- **Standard**: `<locale>.i18n.json` (e.g., `en.i18n.json`, `tr.i18n.json`)
- **Namespaced**: `<namespace>_<locale>.i18n.json` (e.g., `widgets_en.i18n.json`)

### JSON Format (Slang Compatible)

The JSON files should follow the slang format:

```json
{
  "welcome": {
    "title": "Welcome $name",
    "subtitle": "Get started"
  },
  "login": {
    "success": "Logged in successfully",
    "fail": "Login failed"
  },
  "common": {
    "save": "Save",
    "cancel": "Cancel"
  }
}
```

### Supported Locales

The service supports any locale code. Common examples:
- `en` - English
- `tr` - Turkish
- `de` - German
- `fr` - French
- `es` - Spanish
- `zh` - Chinese
- `ja` - Japanese
- `ko` - Korean

## Examples

### Example 1: Seed English Translations

```bash
# Create file: assets/i18n/en.i18n.json
{
  "welcome": {
    "title": "Welcome",
    "subtitle": "Get started"
  }
}

# Seed it
dart bin/seed_translations.dart en
```

### Example 2: Seed Turkish Translations

```bash
# Create file: assets/i18n/tr.i18n.json
{
  "welcome": {
    "title": "Hoş geldiniz",
    "subtitle": "Başlayın"
  }
}

# Seed it
dart bin/seed_translations.dart tr
```

### Example 3: Seed Namespaced Translations

```bash
# Create file: assets/i18n/widgets_en.i18n.json
{
  "button": {
    "submit": "Submit",
    "cancel": "Cancel"
  }
}

# Seed it
dart bin/seed_translations.dart en widgets
```

### Example 4: Seed All Translations at Once

```bash
# Place all JSON files in assets/i18n/
# - en.i18n.json
# - tr.i18n.json
# - de.i18n.json

# Seed all
dart bin/seed_translations.dart --all
```

## Using the API Endpoint

You can also upload translations programmatically using the endpoint:

```dart
// From Flutter client
final translations = {
  'welcome': {
    'title': 'Welcome \$name',
    'subtitle': 'Get started'
  }
};

await client.translation.saveTranslations(
  locale: 'en',
  translations: translations,
);
```

## Verifying Translations

After seeding, you can verify translations are loaded:

```dart
// Get translations
final response = await client.translation.getTranslations(locale: 'en');
final translations = jsonDecode(response.translationsJson);
print(translations);
```

Or via HTTP:

```bash
curl http://localhost:8080/api/translations/en
```

## Troubleshooting

### Error: Translation file not found

**Solution**: Make sure your JSON file is in `assets/i18n/` directory with the correct naming:
- `en.i18n.json` for English
- `tr.i18n.json` for Turkish
- `widgets_en.i18n.json` for namespaced translations

### Error: Invalid JSON

**Solution**: Validate your JSON file using a JSON validator:
- Online: https://jsonlint.com/
- VS Code: Install JSON extension

### Error: Database connection failed

**Solution**: Make sure your server is running and database is accessible:
```bash
docker compose up -d
serverpod run start
```

## File Structure

```
masterfabric_serverpod_server/
├── assets/
│   └── i18n/
│       ├── en.i18n.json          # English translations
│       ├── tr.i18n.json          # Turkish translations
│       ├── de.i18n.json          # German translations
│       └── widgets_en.i18n.json # Namespaced translations
├── bin/
│   └── seed_translations.dart    # Seeding script
└── scripts/
    ├── seed_translations.sh      # Shell script (Linux/Mac)
    └── seed_translations.ps1     # PowerShell script (Windows)
```

## Next Steps

1. Create your translation JSON files in `assets/i18n/`
2. Run the seeding script
3. Test translations via the endpoint
4. Translations will be auto-detected based on user's IP (Cloudflare headers)

For more information, see the [main README](../README.md).
