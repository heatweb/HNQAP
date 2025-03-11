CREATE EXTENSION timescaledb CASCADE;

-- CHANGE PASSWORD !!!!!!!!!!!!

CREATE USER grafana WITH PASSWORD 'example_password';
REVOKE ALL ON DATABASE defaultdb FROM grafana;
GRANT CONNECT ON DATABASE defaultdb TO grafana;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafana;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO grafana;

-- DROP TABLE IF EXISTS readings;
CREATE TABLE readings (
	id SERIAL PRIMARY KEY,
	network VARCHAR (64) NOT NULL,
	node VARCHAR (32) NOT NULL,
	device VARCHAR (32) NOT NULL,
	vargroup VARCHAR (16) NOT NULL,
	varkey VARCHAR (64) NOT NULL,
	datapolicy VARCHAR (16),
	value TEXT,
	timestamp TIMESTAMP,
	UNIQUE (network, node, device, vargroup, varkey)
);

-- DROP TABLE IF EXISTS fields;
CREATE TABLE fields (
	id SERIAL PRIMARY KEY,
	vargroup VARCHAR (16) NOT NULL,
	varkey VARCHAR (64) NOT NULL,
	device VARCHAR (32),
	title TEXT,
	units VARCHAR (8),
	decimals INTEGER,
	colour VARCHAR (12),
	timestamp TIMESTAMP,
    	kpi boolean DEFAULT false,
	UNIQUE (vargroup,varkey)
);

CREATE TABLE constants (
	id SERIAL PRIMARY KEY,
	varkey VARCHAR (64) NOT NULL,
	value TEXT NOT NULL,
	title TEXT,
	units VARCHAR (8),
	timestamp TIMESTAMP DEFAULT now(),
	UNIQUE (varkey)
);


-- This is run for each new controller, mynetwork_mynode, to create time series tables

-- CREATE TABLE mynetwork_mynode (
-- 	device VARCHAR (32) NOT NULL,
-- 	vargroup VARCHAR (16) NOT NULL,
-- 	varkey VARCHAR (64) NOT NULL,
-- 	value TEXT,
-- 	time TIMESTAMPTZ NOT NULL,
-- 	UNIQUE (device, vargroup, varkey, time)
-- );

-- SELECT create_hypertable('mynetwork_mynode', by_range('time'));





