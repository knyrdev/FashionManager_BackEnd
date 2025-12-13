CREATE TABLE "tenants" (
    "id" VARCHAR PRIMARY KEY,
    "status" BOOLEAN,
    "db_name" VARCHAR,
    "db_host" VARCHAR,
    "db_port" VARCHAR,
    "db_user" VARCHAR,
    "db_pass" VARCHAR,
    "db_dialect" VARCHAR,
    "db_sync" VARCHAR,
    "created_at" TIMESTAMP,
    "updated_at" TIMESTAMP
);

CREATE TABLE "users" (
    "id" integer PRIMARY KEY,
    "tenant_id" VARCHAR,
    "user_id" integer,
    "username" varchar,
    "password" varchar
);

CREATE TABLE "sessions" (
    "id" integer PRIMARY KEY,
    "user_id" integer,
    "device" varchar,
    "refresh_token" varchar,
    "active" bool
);

ALTER TABLE "users" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "sessions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

INSERT INTO tenants (id, status, db_name, db_host, db_port, db_user, db_pass, db_dialect, db_sync, created_at, updated_at)
VALUES ('R1V3R5', TRUE, '', '', '', '', '', '', '', NOW(), NOW());

SELECT * FROM tenants;