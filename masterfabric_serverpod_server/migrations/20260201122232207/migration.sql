BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_verification_preferences" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "preferredChannel" text NOT NULL,
    "phoneNumber" text,
    "telegramChatId" text,
    "whatsappVerified" boolean NOT NULL,
    "telegramLinked" boolean NOT NULL,
    "backupChannel" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_verification_prefs_user_idx" ON "user_verification_preferences" USING btree ("userId");
CREATE INDEX "user_verification_prefs_phone_idx" ON "user_verification_preferences" USING btree ("phoneNumber");
CREATE INDEX "user_verification_prefs_telegram_idx" ON "user_verification_preferences" USING btree ("telegramChatId");


--
-- MIGRATION VERSION FOR masterfabric_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('masterfabric_serverpod', '20260201122232207', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260201122232207', "timestamp" = now();

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
