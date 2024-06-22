CREATE OR REPLACE FUNCTION fn_get_value(networkref varchar, noderef varchar, deviceref varchar, vargroupref varchar, varkeyref varchar)
RETURNS table
(
	network character varying(64),
	node character varying(32),
	device character varying(32),
	vargroup character varying(16),
	varkey character varying(64),
	"value" text,
	"time" timestamp,
	age interval,
	"title" text,
	"units" character varying(8)
)
AS $$
BEGIN
	RETURN QUERY
	EXECUTE 'SELECT t1.network, t1.node, t1.device, t1.vargroup, t1.varkey, t1.value, t1.timestamp as time, AGE(t1.timestamp) as age, t2.title, t2.units FROM readings t1'
	|| ' INNER JOIN fields t2 ON t1.varkey = t2.varkey AND t1.vargroup = t2.vargroup'
	|| ' WHERE t1.network = $1 AND t1.node = $2 AND t1.device = $3 AND t1.vargroup = $4 AND t1.varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_get_value(deviceref varchar, varkeyref varchar)
RETURNS table
(
	network character varying(64),
	node character varying(32),
	device character varying(32),
	vargroup character varying(16),
	varkey character varying(64),
	"value" text,
	"time" timestamp,
	age interval,
	"title" text,
	"units" character varying(8)
)
AS $$
BEGIN
	RETURN QUERY
	EXECUTE 'SELECT t1.network, t1.node, t1.device, t1.vargroup, t1.varkey, t1.value, t1.timestamp as time, AGE(t1.timestamp) as age, t2.title, t2.units FROM readings t1'
	|| ' INNER JOIN fields t2 ON t1.varkey = t2.varkey AND t1.vargroup = t2.vargroup'
	|| ' WHERE t1.device = $1 AND t1.varkey = $2'
	USING deviceref, varkeyref;
END;
$$ LANGUAGE plpgsql;


-- SELECT * FROM fn_get_value('mynetwork','node0001','3016031af27a0c25','dat','tHoDHW')
-- SELECT * FROM fn_get_value('3016031af27a0c25','tHoDHW') 
-- SELECT * FROM fn_get_value('3016031af27a0c25','tHoDHW') WHERE vargroup='dat'

-- ---------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_get_values(networknode varchar, device varchar, vargroup varchar, varkey varchar)
RETURNS table
(
	"value" text,
    "time" timestamp with time zone 
)
AS $$
BEGIN
	RETURN QUERY
	EXECUTE 'SELECT value, time FROM '
	|| quote_ident(networknode)
	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3'
	USING device, vargroup, varkey;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_values_ext(networknode varchar, device varchar, vargroup varchar, varkey varchar)
RETURNS table
(
	"value" text,
	"time" timestamp with time zone,
	"title" text,
	"units" character varying(8)
)
AS $$
BEGIN
	RETURN QUERY
	EXECUTE 'SELECT t1.value, t1.time, t2.title, t2.units FROM '
	|| quote_ident(networknode) 
	|| ' t1 INNER JOIN fields t2 ON t1.varkey = t2.varkey AND t1.vargroup = t2.vargroup'
	|| ' WHERE t1.device = $1 AND t1.vargroup = $2 AND t1.varkey = $3'
	USING device, vargroup, varkey;
END;
$$ LANGUAGE plpgsql;



CREATE FUNCTION fn_average(networknode varchar, device varchar, vargroup varchar, varkey varchar) RETURNS FLOAT AS $$
DECLARE
    avg_value FLOAT := 0;
    avg_cnt INTEGER := 0;
    avg_record RECORD;
BEGIN
    FOR avg_record IN
	   SELECT * FROM fn_get_values(networknode, device, vargroup, varkey)
	LOOP
        avg_value := ((avg_value * avg_cnt) + avg_record.value::numeric) / (avg_cnt + 1);
        avg_cnt := avg_cnt + 1;
    END LOOP;

    IF avg_cnt > 0 THEN
        RETURN avg_value;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_weighted_average(networknode varchar, device varchar, vargroup varchar, varkey1 varchar, varkey2 varchar)
RETURNS FLOAT AS $$
DECLARE
	avg_cnt INTEGER := 0;
	avg_record RECORD;
	tot_wv FLOAT := 0;
	tot_w FLOAT := 0;
	last_v FLOAT := 0;
	last_w FLOAT := 0;
	last_time FLOAT := 0;
	period FLOAT := 0;
BEGIN
	FOR avg_record IN
		EXECUTE 'SELECT varkey, value, EXTRACT(EPOCH FROM time) AS time FROM '
		|| quote_ident(networknode)
		|| ' WHERE device = $1 AND vargroup = $2 AND (varkey = $3 OR varkey = $4) ORDER BY time ASC'
		USING device, vargroup, varkey1, varkey2
	LOOP
		
		IF avg_cnt > 0 THEN
			period := avg_record.time - last_time;
			tot_wv := tot_wv + (last_v * last_w * period);
			tot_w := tot_w + (last_w * period);
		END IF;
	
		IF avg_record.varkey = varkey1 THEN 
			last_v := avg_record.value::numeric;
		ELSE
			last_w := avg_record.value::numeric;
		END IF;
	
		last_time = avg_record.time;
		avg_cnt := avg_cnt + 1;
	
	END LOOP;
	
    	IF avg_cnt > 0 THEN
		RETURN tot_wv / tot_w;
    	ELSE
		RETURN 0;
    	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_weighted_average(networknode varchar, device varchar, vargroup varchar, varkey1 varchar, varkey2 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
    avg_cnt INTEGER := 0;
    avg_record RECORD;
	tot_wv FLOAT := 0;
	tot_w FLOAT := 0;
	last_v FLOAT := 0;
	last_w FLOAT := 0;
	last_time FLOAT := 0;
	period FLOAT := 0;
BEGIN
    FOR avg_record IN
	   	EXECUTE 'SELECT varkey, value, EXTRACT(EPOCH FROM time) AS time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND (varkey = $3 OR varkey = $4) AND time >= $5 AND time <= $6'
		|| ' ORDER BY time ASC'
   		USING device, vargroup, varkey1, varkey2, time1, time2
	LOOP
		
		IF avg_cnt > 0 THEN
			period := avg_record.time - last_time;
			tot_wv := tot_wv + (last_v * last_w * period);
			tot_w := tot_w + (last_w * period);
		END IF;
	
		IF avg_record.varkey = varkey1 THEN 
			last_v := avg_record.value::numeric;
		ELSE 
			last_w := avg_record.value::numeric;
		END IF;
	
		last_time = avg_record.time;
		avg_cnt := avg_cnt + 1;
	
    END LOOP;

    IF avg_cnt > 0 THEN
		RETURN tot_wv / tot_w;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- SELECT fn_weighted_average('heatweb_network1','3016031af27a0c25','dat','tHoDHW','fHDHW')


CREATE OR REPLACE FUNCTION fn_m3h_to_m3(networknode varchar, device varchar, vargroup varchar, varkey varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
    avg_cnt INTEGER := 0;
    avg_record RECORD;
	tot_wv FLOAT := 0;
	last_v FLOAT := 0;
	last_time FLOAT := 0;
	period FLOAT := 0;
BEGIN
    FOR avg_record IN
	   	EXECUTE 'SELECT varkey, value, EXTRACT(EPOCH FROM time) AS time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
		|| ' ORDER BY time ASC'
   		USING device, vargroup, varkey, time1, time2
	LOOP
		
		IF avg_cnt > 0 THEN
			period := avg_record.time - last_time;
			tot_wv := tot_wv + (last_v * period / (60 * 60));
		END IF;
	
		last_v := avg_record.value::numeric;
			
		last_time = avg_record.time;
		avg_cnt := avg_cnt + 1;
	
    END LOOP;

    IF avg_cnt > 0 THEN
		RETURN tot_wv;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_difference(networknode varchar, device varchar, vargroup varchar, varkey varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
    avg_record RECORD;
	first_v FLOAT := 0;
	last_v FLOAT := 0;
BEGIN
    FOR avg_record IN
	   	EXECUTE 'SELECT varkey, value, EXTRACT(EPOCH FROM time) AS time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
		|| ' ORDER BY time ASC LIMIT 1'
   		USING device, vargroup, varkey, time1, time2
	LOOP		
		first_v := avg_record.value::numeric;	
    END LOOP;
	
    FOR avg_record IN
	   	EXECUTE 'SELECT varkey, value, EXTRACT(EPOCH FROM time) AS time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
		|| ' ORDER BY time DESC LIMIT 1'
   		USING device, vargroup, varkey, time1, time2
	LOOP		
		last_v := avg_record.value::numeric;	
    END LOOP;

    RETURN (last_v - first_v);
    
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_get_nodes(network varchar)
RETURNS table
(
	"node" character varying(32),
    "age" numeric,
	"devices" text
)
AS $$
DECLARE
    avg_record RECORD;
	info_record RECORD;
	devlist TEXT := '';
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT DISTINCT node FROM readings'
    	|| ' WHERE network = $1'
   		USING network
	LOOP		
		node := avg_record.node;	

		FOR info_record IN
		   	EXECUTE 'SELECT (EXTRACT(EPOCH FROM NOW()) - EXTRACT(EPOCH FROM timestamp)) AS age FROM readings WHERE network = $1 AND node = $2 ORDER BY age ASC LIMIT 1'
	   		USING network, node
		LOOP		
			age := info_record.age;	
	    END LOOP;

		devlist := '';
		FOR info_record IN
		   	EXECUTE 'SELECT DISTINCT device FROM readings WHERE network = $1 AND node = $2 ORDER BY device ASC'
	   		USING network, node
		LOOP		
			devlist := devlist||info_record.device||', ';	
	    END LOOP;
		devices := devlist;
	
		RETURN NEXT;
    END LOOP;
	
	
END;
$$ LANGUAGE plpgsql;
