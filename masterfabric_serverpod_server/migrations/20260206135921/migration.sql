BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE IF NOT EXISTS "user_verification_preferences" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "preferredChannel" text NOT NULL,
    "phoneNumber" text,
    "telegramChatId" text,
    "whatsappVerified" boolean NOT NULL,
    "telegramLinked" boolean NOT NULL,
    "backupChannel" text,
    "locale" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes for user_verification_preferences
CREATE UNIQUE INDEX IF NOT EXISTS "user_verification_prefs_user_idx" ON "user_verification_preferences" USING btree ("userId");
CREATE INDEX IF NOT EXISTS "user_verification_prefs_phone_idx" ON "user_verification_preferences" USING btree ("phoneNumber");
CREATE INDEX IF NOT EXISTS "user_verification_prefs_telegram_idx" ON "user_verification_preferences" USING btree ("telegramChatId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE IF NOT EXISTS "paired_devices" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "deviceId" text NOT NULL,
    "deviceName" text NOT NULL,
    "platform" text NOT NULL,
    "deviceFingerprint" text,
    "ipAddress" text,
    "userAgent" text,
    "isActive" boolean NOT NULL,
    "isTrusted" boolean NOT NULL,
    "deviceMode" text NOT NULL,
    "lastSeenAt" timestamp without time zone NOT NULL,
    "pairedAt" timestamp without time zone NOT NULL,
    "metadata" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE IF NOT EXISTS "user_app_settings" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "pushNotifications" boolean NOT NULL,
    "emailNotifications" boolean NOT NULL,
    "notificationSound" boolean NOT NULL,
    "analytics" boolean NOT NULL,
    "crashReports" boolean NOT NULL,
    "twoFactorEnabled" boolean NOT NULL,
    "accountDeletionRequested" boolean,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX IF NOT EXISTS "user_app_settings_user_id_idx" ON "user_app_settings" USING btree ("userId");

--
-- MIGRATION VERSION FOR masterfabric_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('masterfabric_serverpod', '20260206135921', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260206135921', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
