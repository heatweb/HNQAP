CREATE EXTENSION timescaledb CASCADE;

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
	UNIQUE (vargroup,varkey)
);


-- This is run for each new controller, mynetwork_mynode, to create time series tables

CREATE TABLE mynetwork_mynode (
	device VARCHAR (32) NOT NULL,
	vargroup VARCHAR (16) NOT NULL,
	varkey VARCHAR (64) NOT NULL,
	value TEXT,
	time TIMESTAMPTZ NOT NULL,
	UNIQUE (device, vargroup, varkey, time)
);

SELECT create_hypertable('mynetwork_mynode', by_range('time'));
