# App Config Seeding Guide

This guide explains how to seed the `app_config_entry` table with initial configuration data.

## 🚀 Quick Start (Easiest Method)

**Using Serverpod script command:**

```bash
# Linux/Mac
serverpod run seed-app-config

# Or directly
bash scripts/seed_app_config.sh

# Windows PowerShell
serverpod run seed-app-config

# Or directly
powershell -ExecutionPolicy Bypass -File scripts\seed_app_config.ps1
```

The script will:
- ✅ Check if PostgreSQL container is running
- ✅ Start it if needed
- ✅ Execute the seed SQL file
- ✅ Verify the seeded data

## Option 1: Direct SQL Injection (Manual)

### Using psql command line:

```bash
# Connect to your database and run the seed file
psql -U serverpod -d serverpod -f migrations/seed_app_config.sql

# Or if using docker-compose
docker-compose exec postgres psql -U serverpod -d serverpod -f /path/to/migrations/seed_app_config.sql
```

### Using docker-compose:

```bash
# Copy the seed file into the container and execute
docker-compose exec postgres psql -U serverpod -d serverpod < migrations/seed_app_config.sql
```

### Manual SQL execution:

1. Connect to your PostgreSQL database
2. Open `migrations/seed_app_config.sql`
3. Copy and paste the SQL into your database client
4. Execute the SQL

## Option 2: Using Docker Compose (if database is in container)

```bash
# From the project root
docker-compose exec postgres psql -U serverpod -d serverpod -c "$(cat migrations/seed_app_config.sql)"
```

## Option 3: Using Serverpod Script (Dart)

If you prefer using Dart code:

```bash
# Run the seeding script
dart bin/seed_app_config.dart

# Clear existing data and reseed
dart bin/seed_app_config.dart --clear

# Seed only specific environment
dart bin/seed_app_config.dart --environment=production
```

## What Gets Seeded

The seed file creates default configurations for:

1. **Development Environment**
   - Debug mode: enabled
   - API URL: http://localhost:8080
   - Analytics: disabled
   - Encryption: disabled

2. **Staging Environment**
   - Debug mode: disabled
   - API URL: https://staging-api.examplepod.com
   - Analytics: disabled
   - Encryption: disabled

3. **Production Environment**
   - Debug mode: disabled
   - API URL: https://api.examplepod.com
   - Analytics: enabled
   - Encryption: enabled
   - Push notifications: enabled

## Customizing Seed Data

Edit `migrations/seed_app_config.sql` to customize:
- API URLs
- App names and versions
- Feature flags
- Store URLs
- Push notification providers
- Any other configuration values

## Verifying Seed Data

After seeding, verify the data was inserted:

```sql
SELECT 
    "environment",
    "platform",
    "isActive",
    "createdAt"
FROM "app_config_entry"
ORDER BY "environment", "platform";
```

## Updating Existing Configurations

The seed file uses `ON CONFLICT DO NOTHING` to prevent duplicates. To update existing configurations:

1. Delete existing entries:
```sql
DELETE FROM "app_config_entry" WHERE "environment" = 'production';
```

2. Re-run the seed file, or

3. Use the admin endpoint/script to update configurations programmatically.
