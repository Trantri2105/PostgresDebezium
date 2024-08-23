-- Create table
CREATE TABLE account(
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(50)
);

-- Turn on logical replication
ALTER SYSTEM SET wal_level = logical;

--Check logical replication
SELECT name, setting
FROM pg_settings
WHERE name IN ('wal_level', 'max_replication_slots');

-- Create user for debezium source connector
CREATE ROLE debezium_source WITH REPLICATION LOGIN PASSWORD '123456';
CREATE ROLE replication_group;
GRANT replication_group TO admin;
GRANT replication_group TO debezium_source;
GRANT CREATE ON DATABASE source TO debezium_source;

ALTER TABLE account OWNER TO replication_group;

-- Create user for debezium sink connector
CREATE USER debezium_sink WITH PASSWORD '123456';
GRANT CONNECT ON DATABASE target TO debezium_sink;
GRANT USAGE ON SCHEMA public TO debezium_sink;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA public TO debezium_sink;

CREATE ROLE owner_group;
GRANT owner_group TO admin;
GRANT owner_group TO debezium_sink;

ALTER TABLE account OWNER TO owner_group;


