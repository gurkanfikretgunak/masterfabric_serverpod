-- Seed data for app_config_entry table
-- This file contains default configurations for development, staging, and production environments
-- Run this SQL file after applying migrations to populate initial configuration data

BEGIN;

-- Development Environment Configuration
INSERT INTO "app_config_entry" (
    "environment",
    "platform",
    "configJson",
    "createdAt",
    "updatedAt",
    "isActive"
) VALUES (
    'development',
    NULL,
    '{
        "appSettings": {
            "appName": "MasterFabric Serverpod (Dev)",
            "appVersion": "1.0.0-dev",
            "environment": "development",
            "debugMode": true,
            "maintenanceMode": false
        },
        "uiConfiguration": {
            "themeMode": "light",
            "fontScale": 1.0,
            "devModeGrid": true,
            "devModeSpacer": true
        },
        "splashConfiguration": {
            "style": "startup",
            "duration": 2000,
            "backgroundColor": "#FFFFFF",
            "textColor": "#000000",
            "primaryColor": "#0066FF",
            "logoUrl": null,
            "logoWidth": 200,
            "logoHeight": 200,
            "showLoadingIndicator": true,
            "loadingIndicatorSize": 40,
            "loadingText": "Loading...",
            "showAppVersion": true,
            "appVersion": "1.0.0-dev",
            "showCopyright": true,
            "copyrightText": "© 2025 MasterFabric - Development"
        },
        "featureFlags": {
            "onboardingEnabled": false,
            "analyticsEnabled": false
        },
        "navigationConfiguration": {
            "defaultRoute": "/",
            "deepLinkingEnabled": true
        },
        "apiConfiguration": {
            "baseUrl": "http://localhost:8080",
            "timeout": 30000,
            "retryCount": 3
        },
        "permissionsConfiguration": {
            "required": [],
            "optional": []
        },
        "localizationConfiguration": {
            "defaultLocale": "en",
            "supportedLocales": ["en"]
        },
        "storageConfiguration": {
            "localStorageType": "hiveCe",
            "encryptionEnabled": false,
            "cacheEnabled": true
        },
        "pushNotificationConfiguration": {
            "enabled": false,
            "defaultProvider": "onesignal",
            "autoInitialize": false,
            "providersJson": "{\"onesignal\":{\"enabled\":false,\"appId\":\"\"},\"firebase\":{\"enabled\":false,\"vapidKey\":\"\"}}"
        },
        "forceUpdateConfiguration": {
            "latestVersion": "1.0.0-dev",
            "minimumVersion": "1.0.0-dev",
            "releaseNotes": "Development build",
            "features": [],
            "storeUrl": {
                "ios": null,
                "android": null
            },
            "customMessage": "A new version is available!"
        }
    }',
    NOW(),
    NOW(),
    true
)
ON CONFLICT DO NOTHING;

-- Staging Environment Configuration
INSERT INTO "app_config_entry" (
    "environment",
    "platform",
    "configJson",
    "createdAt",
    "updatedAt",
    "isActive"
) VALUES (
    'staging',
    NULL,
    '{
        "appSettings": {
            "appName": "MasterFabric Serverpod (Staging)",
            "appVersion": "1.0.0-staging",
            "environment": "staging",
            "debugMode": false,
            "maintenanceMode": false
        },
        "uiConfiguration": {
            "themeMode": "light",
            "fontScale": 1.0,
            "devModeGrid": false,
            "devModeSpacer": false
        },
        "splashConfiguration": {
            "style": "startup",
            "duration": 2000,
            "backgroundColor": "#FFFFFF",
            "textColor": "#000000",
            "primaryColor": "#0066FF",
            "logoUrl": null,
            "logoWidth": 200,
            "logoHeight": 200,
            "showLoadingIndicator": true,
            "loadingIndicatorSize": 40,
            "loadingText": "Loading...",
            "showAppVersion": true,
            "appVersion": "1.0.0-staging",
            "showCopyright": true,
            "copyrightText": "© 2025 MasterFabric - Staging"
        },
        "featureFlags": {
            "onboardingEnabled": true,
            "analyticsEnabled": false
        },
        "navigationConfiguration": {
            "defaultRoute": "/",
            "deepLinkingEnabled": true
        },
        "apiConfiguration": {
            "baseUrl": "https://staging-api.examplepod.com",
            "timeout": 30000,
            "retryCount": 3
        },
        "permissionsConfiguration": {
            "required": [],
            "optional": []
        },
        "localizationConfiguration": {
            "defaultLocale": "en",
            "supportedLocales": ["en"]
        },
        "storageConfiguration": {
            "localStorageType": "hiveCe",
            "encryptionEnabled": false,
            "cacheEnabled": true
        },
        "pushNotificationConfiguration": {
            "enabled": false,
            "defaultProvider": "onesignal",
            "autoInitialize": false,
            "providersJson": "{\"onesignal\":{\"enabled\":false,\"appId\":\"\"},\"firebase\":{\"enabled\":false,\"vapidKey\":\"\"}}"
        },
        "forceUpdateConfiguration": {
            "latestVersion": "1.0.0-staging",
            "minimumVersion": "1.0.0-staging",
            "releaseNotes": "Staging build for testing",
            "features": [],
            "storeUrl": {
                "ios": null,
                "android": null
            },
            "customMessage": "A new version is available!"
        }
    }',
    NOW(),
    NOW(),
    true
)
ON CONFLICT DO NOTHING;

-- Production Environment Configuration
INSERT INTO "app_config_entry" (
    "environment",
    "platform",
    "configJson",
    "createdAt",
    "updatedAt",
    "isActive"
) VALUES (
    'production',
    NULL,
    '{
        "appSettings": {
            "appName": "MasterFabric Serverpod",
            "appVersion": "1.0.0",
            "environment": "production",
            "debugMode": false,
            "maintenanceMode": false
        },
        "uiConfiguration": {
            "themeMode": "light",
            "fontScale": 1.0,
            "devModeGrid": false,
            "devModeSpacer": false
        },
        "splashConfiguration": {
            "style": "startup",
            "duration": 2000,
            "backgroundColor": "#FFFFFF",
            "textColor": "#000000",
            "primaryColor": "#0066FF",
            "logoUrl": null,
            "logoWidth": 200,
            "logoHeight": 200,
            "showLoadingIndicator": true,
            "loadingIndicatorSize": 40,
            "loadingText": "Loading...",
            "showAppVersion": true,
            "appVersion": "1.0.0",
            "showCopyright": true,
            "copyrightText": "© 2025 MasterFabric"
        },
        "featureFlags": {
            "onboardingEnabled": true,
            "analyticsEnabled": true
        },
        "navigationConfiguration": {
            "defaultRoute": "/",
            "deepLinkingEnabled": true
        },
        "apiConfiguration": {
            "baseUrl": "https://api.examplepod.com",
            "timeout": 30000,
            "retryCount": 3
        },
        "permissionsConfiguration": {
            "required": [],
            "optional": []
        },
        "localizationConfiguration": {
            "defaultLocale": "en",
            "supportedLocales": ["en"]
        },
        "storageConfiguration": {
            "localStorageType": "hiveCe",
            "encryptionEnabled": true,
            "cacheEnabled": true
        },
        "pushNotificationConfiguration": {
            "enabled": true,
            "defaultProvider": "onesignal",
            "autoInitialize": true,
            "providersJson": "{\"onesignal\":{\"enabled\":true,\"appId\":\"\"},\"firebase\":{\"enabled\":false,\"vapidKey\":\"\"}}"
        },
        "forceUpdateConfiguration": {
            "latestVersion": "1.0.0",
            "minimumVersion": "1.0.0",
            "releaseNotes": "Production release",
            "features": [],
            "storeUrl": {
                "ios": null,
                "android": null
            },
            "customMessage": "A new version is available!"
        }
    }',
    NOW(),
    NOW(),
    true
)
ON CONFLICT DO NOTHING;

COMMIT;

-- Verify the seed data
SELECT 
    "environment",
    "platform",
    "isActive",
    "createdAt"
FROM "app_config_entry"
ORDER BY "environment", "platform";
