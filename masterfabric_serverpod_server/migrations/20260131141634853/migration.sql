BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_audit_log" (
    "id" bigserial PRIMARY KEY,
    "userId" text,
    "eventType" text NOT NULL,
    "eventData" text NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    "timestamp" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "permission" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "resource" text NOT NULL,
    "action" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "role" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "permissions" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "isActive" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "two_factor_secret" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "secret" text NOT NULL,
    "backupCodes" json NOT NULL,
    "enabled" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_role" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "roleId" bigint NOT NULL,
    "assignedAt" timestamp without time zone NOT NULL,
    "assignedBy" text
);


--
-- MIGRATION VERSION FOR masterfabric_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('masterfabric_serverpod', '20260131141634853', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260131141634853', "timestamp" = now();

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
