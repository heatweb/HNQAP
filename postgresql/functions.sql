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


CREATE OR REPLACE FUNCTION fn_get_var_values(networkin varchar, varkeyin varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS table
(
	"node" character varying(32),
	"device" character varying(32),
	"vargroup" character varying(16),
	"varkey" character varying(64),
	"value" text,
    "time" timestamp with time zone
)
AS $$
DECLARE
	networknode TEXT := '';
	avg_record RECORD;
	info_record RECORD;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT DISTINCT node FROM readings'
    	|| ' WHERE network = $1 AND varkey = $2'
   		USING networkin, varkeyin
	LOOP
		
		networknode := REPLACE(LOWER(networkin||'_'||avg_record.node), '-', '_');	
		FOR info_record IN
		   	EXECUTE 'SELECT time,device,vargroup,varkey,value FROM '
	    	|| quote_ident(networknode)
	    	|| ' WHERE varkey = $1 AND time >= $2 AND time <= $3'
			USING varkeyin, time1, time2
		LOOP
			
		    time := info_record.time;
			device := info_record.device;
			node := avg_record.node;
			vargroup := info_record.vargroup;
			varkey := info_record.varkey;
			value := info_record.value;
			RETURN NEXT;
		
	    END LOOP;
	
    END LOOP;

	
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_get_var_values_before(networkin varchar, varkeyin varchar, time1 timestamp with time zone)
RETURNS table
(
	"node" character varying(32),
	"device" character varying(32),
	"vargroup" character varying(16),
	"varkey" character varying(64),
	"value" text,
    "time" timestamp with time zone
)
AS $$
DECLARE
	networknode TEXT := '';
	avg_record RECORD;
	info_record RECORD;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT DISTINCT node,device,vargroup,varkey FROM readings'
    	|| ' WHERE network = $1 AND varkey = $2'
   		USING networkin, varkeyin
	LOOP
		
		networknode := REPLACE(LOWER(networkin||'_'||avg_record.node), '-', '_');	
		FOR info_record IN
		   	EXECUTE 'SELECT time,device,vargroup,varkey,value FROM '
	    	|| quote_ident(networknode)
	    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time <= $4'
	    	|| ' ORDER BY time DESC LIMIT 1'
			USING avg_record.device, avg_record.vargroup, varkeyin, time1
		LOOP
			
		    time := time1;
			device := info_record.device;
			node := avg_record.node;
			vargroup := info_record.vargroup;
			varkey := info_record.varkey;
			value := ''||info_record.value;
			RETURN NEXT;
		
	    END LOOP;
	
    END LOOP;

	
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

CREATE OR REPLACE FUNCTION fn_weighted_average(networknode varchar, device varchar, vargroup1 varchar, varkey1 varchar, vargroup2 varchar, varkey2 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
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
    	|| ' WHERE device = $1 AND ((vargroup = $2 AND varkey = $3) OR (vargroup = $4 AND varkey = $5)) AND time >= $6 AND time <= $7'
		|| ' ORDER BY time ASC'
   		USING device, vargroup1, varkey1, vargroup2, varkey2, time1, time2
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

    IF (avg_cnt > 0) AND (tot_w > 0) THEN
	RETURN tot_wv / tot_w;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_time_average(networknode varchar, device varchar, vargroup varchar, varkey1 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
    avg_cnt INTEGER := 0;
    avg_record RECORD;
	tot_wv FLOAT := 0;
	tot_w FLOAT := 0;
	last_v FLOAT := 0;
	last_time FLOAT := 0;
	period FLOAT := 0;
BEGIN
    FOR avg_record IN
	   	EXECUTE 'SELECT varkey, value, EXTRACT(EPOCH FROM time) AS time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND (varkey = $3) AND time >= $4 AND time <= $5'
		|| ' ORDER BY time ASC'
   		USING device, vargroup, varkey1, time1, time2
	LOOP
		
		IF avg_cnt > 0 THEN
			period := avg_record.time - last_time;
			tot_wv := tot_wv + (last_v * period);
			tot_w := tot_w + (period);
		END IF;
	
		last_v := avg_record.value::numeric;		
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


CREATE OR REPLACE FUNCTION public.fn_kwh_from_dhw(
	networknode character varying,
	device character varying,
	vargroup character varying,
	varkey1 character varying,
	varkey2 character varying,
	cold double precision,
	time1 timestamp with time zone,
	time2 timestamp with time zone)
    RETURNS double precision
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
		
		IF (avg_cnt > 0 AND last_w > 0) THEN
			period := avg_record.time - last_time;
			tot_wv := tot_wv + ((last_v - cold) * (last_w / 60) * period * 4.2 / 3600);
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
		RETURN tot_wv;
    ELSE
        RETURN 0;
    END IF;
END;
$BODY$;



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


-- -Gas Boiler Counters IN TESTING------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_counter_to_rate(networknode varchar, devicein varchar, vargroup varchar, varkey varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS table
(
	"value" text,
    "time" timestamp with time zone,
	"device" character varying(32) 
)
AS $$
DECLARE
    avg_record RECORD;
	info_record RECORD;
	avg_cnt INTEGER := 0;
	last_time FLOAT := 0;
	period FLOAT := 0;
	delta FLOAT := 0;
	tot_wv FLOAT := 0;
	last_v FLOAT := 0;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT varkey, value, time as timestamp, EXTRACT(EPOCH FROM time) AS time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
		|| ' ORDER BY time ASC'
   		USING devicein, vargroup, varkey, time1, time2
	LOOP		
		IF avg_cnt > 0 THEN
	
			period := avg_record.time - last_time;
			delta := avg_record.value::numeric - last_v;

			value := 0;
			IF (period > 0) AND (delta > 0) THEN
				value := delta / period;
			END IF;
	
			time := avg_record.timestamp;
			device := devicein;

			RETURN NEXT;
	
		END IF;
	
		last_v := avg_record.value::numeric;			
		last_time := avg_record.time;
		avg_cnt := avg_cnt + 1;		
	
		
    END LOOP;
	
	
END;
$$ LANGUAGE plpgsql;

-- not quite working
CREATE OR REPLACE FUNCTION fn_pulses_per_device_per_hour(networknode varchar, vargroup varchar, varkey varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS table
(
	"value" text,
    "time" timestamp with time zone,
	"device" character varying(32) 
)
AS $$
DECLARE
    avg_record RECORD;
	info_record RECORD;
	avg_cnt INTEGER := 0;
	last_time FLOAT := 0;
	period FLOAT := 0;
	delta FLOAT := 0;
	tot_wv FLOAT := 0;
	last_v FLOAT := 0;
	last_dev TEXT := '';
BEGIN

	
	FOR avg_record IN
	   	EXECUTE 'SELECT varkey, device, value, time as timestamp, EXTRACT(EPOCH FROM time) AS time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE vargroup = $1 AND varkey = $2 AND time >= $3 AND time <= $4'
		|| ' ORDER BY time ASC'
   		USING vargroup, varkey, time1, time2
	LOOP		


		IF avg_cnt > 0 THEN

			IF (last_dev != avg_record.device) THEN

				last_v := avg_record.value::numeric;
				last_time := avg_record.time;
				tot_wv := 0;
	
			END IF;
	
	
			period := avg_record.time - last_time;
			delta := avg_record.value::numeric - last_v;

			
			IF (delta > 0) THEN
				tot_wv := tot_wv + delta;
			END IF;
	
			IF (period >= 3600) THEN						
	
				time := avg_record.timestamp;
				device := last_dev;
				value := tot_wv;
	
				RETURN NEXT;

				last_v := avg_record.value::numeric;
				last_time := avg_record.time;
				tot_wv := 0;
	
			END IF;
	
	ELSE
	
		last_v := avg_record.value::numeric;
		last_time := avg_record.time;
	
	END IF;
	
		last_dev := avg_record.device;		
		
		avg_cnt := avg_cnt + 1;		
	
		
    END LOOP;
	
	
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_get_nodes(network varchar)
RETURNS table
(
	"node" character varying(32),
    "age" numeric,
	"devices" text,
	"tablesize" text
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

		FOR info_record IN
		   	EXECUTE 'SELECT pg_size_pretty(pg_total_relation_size('''
			|| quote_ident(REPLACE(LOWER(network||'_'||node), '-', '_'))
			|| '''))'
		LOOP		
			tablesize := info_record.pg_size_pretty;	
	    END LOOP;

	
		RETURN NEXT;
    END LOOP;
	
	
END;
$$ LANGUAGE plpgsql;


-- -------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_kpi_point_count(networkin varchar)
RETURNS INTEGER AS $$
DECLARE
	avg_record RECORD;
	oot INTEGER := 0;
BEGIN
	FOR avg_record IN
	   	EXECUTE 'SELECT COUNT(t1.timestamp) as value FROM readings t1'
		|| ' INNER JOIN fields t2 ON t1.varkey = t2.varkey AND t1.vargroup = t2.vargroup'
		|| ' WHERE t2.kpi = true AND network = $1' 
   		USING networkin
	LOOP		
		oot := avg_record.value;	
    	END LOOP;
	
    	RETURN (oot);
    
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_total_days_in_period(time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
    	avg_record RECORD;
	oot FLOAT := 0;
BEGIN
	FOR avg_record IN
	   	EXECUTE 'SELECT (EXTRACT(EPOCH FROM $2) - EXTRACT(EPOCH FROM $1)) AS value'
   		USING time1, time2
	LOOP		
		oot := avg_record.value;	
	END LOOP;
	
	RETURN (oot / (60*60*24));
    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_kpi_connectivity(networknode varchar, devicein varchar, vargroupin varchar, varkeyin varchar, intervalin interval, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT
AS $$
DECLARE
    avg_record RECORD;
	info_record RECORD;
	devlist TEXT := '';
	runtime1 timestamp with time zone;
	runtime2 timestamp with time zone;
	total_days_in_period INTEGER;
	lcnt INTEGER := 0;
BEGIN

	runtime1 := time1;
	runtime2 := runtime1 + intervalin;
	
	total_days_in_period := fn_total_days_in_period(time1,time2)::integer;
	FOR cnt IN 1..total_days_in_period LOOP
		
	  	IF varkeyin = '*' THEN
	
			FOR avg_record IN
				EXECUTE 'SELECT COUNT(time) AS value FROM '
				|| quote_ident(networknode)
				|| ' WHERE device = $1 AND vargroup = $2 AND time>=$4 AND time<$5'
				USING devicein, vargroupin, varkeyin, runtime1, runtime2
			LOOP		
	
				IF avg_record.value > 0 THEN
					lcnt := lcnt + 1;
				END IF;
		
		    END LOOP;

		ELSE

			FOR avg_record IN
				EXECUTE 'SELECT COUNT(time) AS value FROM '
				|| quote_ident(networknode)
				|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time>=$4 AND time<$5'
				USING devicein, vargroupin, varkeyin, runtime1, runtime2
			LOOP		
	
				IF avg_record.value > 0 THEN
					lcnt := lcnt + 1;
				END IF;
		
		    END LOOP;

		END IF;
		
		runtime1 := runtime1 + intervalin;
		runtime2 := runtime1 + intervalin;
	
	END LOOP;
	
	RETURN (100 * lcnt/total_days_in_period);
	
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_kpi_connectivity(networkin varchar, intervalin interval, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	avg_record RECORD;
	oot FLOAT := 0;
	loopcnt INTEGER := 0;
BEGIN
	FOR avg_record IN
	   	EXECUTE 'SELECT t1.network,t1.node,t1.device,t1.vargroup,t1.varkey FROM readings t1'
		|| ' INNER JOIN fields t2 ON t1.varkey = t2.varkey AND t1.vargroup = t2.vargroup'
		|| ' WHERE t2.kpi = true AND network = $1' 
   		USING networkin
	LOOP		
		loopcnt := loopcnt + 1;
		oot := oot + fn_kpi_connectivity(REPLACE(LOWER(avg_record.network||'_'||avg_record.node), '-', '_'), avg_record.device, avg_record.vargroup, avg_record.varkey, intervalin, time1, time2);	
	
    END LOOP;
	
    RETURN (oot / loopcnt);
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_kpi_device_connectivity(networkin varchar, intervalin interval, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	avg_record RECORD;
	oot FLOAT := 0;
	loopcnt INTEGER := 0;
BEGIN
	FOR avg_record IN
	   	EXECUTE 'SELECT t1.network,t1.node,t1.device,t1.vargroup,t1.varkey FROM readings t1'
		|| ' INNER JOIN fields t2 ON t1.varkey = t2.varkey AND t1.vargroup = t2.vargroup'
		|| ' WHERE t2.kpi = true AND network = $1' 
   		USING networkin
	LOOP		
		loopcnt := loopcnt + 1;
		oot := oot + fn_kpi_connectivity(REPLACE(LOWER(avg_record.network||'_'||avg_record.node), '-', '_'), avg_record.device, avg_record.vargroup, '*', intervalin, time1, time2);	
	
    END LOOP;
	
    RETURN (oot / loopcnt);
    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_kpi_operational(networknode varchar, devicein varchar, vargroupin varchar, varkeyin varchar, intervalin interval, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT
AS $$
DECLARE
    avg_record RECORD;
	info_record RECORD;
	devlist TEXT := '';
	runtime1 timestamp with time zone;
	runtime2 timestamp with time zone;
	total_days_in_period INTEGER;
	lcnt INTEGER := 1;
BEGIN

	
	FOR avg_record IN
		EXECUTE 'SELECT COUNT(time) AS value FROM '
		|| quote_ident(networknode)
		|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time>=$4 AND time<$5 AND value::numeric<0'
		USING devicein, vargroupin, varkeyin, runtime1, runtime2
	LOOP		

		IF avg_record.value > 0 THEN
			lcnt := 0;
		END IF;

	END LOOP;

	
	RETURN (100 * lcnt);
	
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_kpi_operational(networkin varchar, intervalin interval, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	avg_record RECORD;
	oot FLOAT := 0;
	loopcnt INTEGER := 0;
BEGIN
	FOR avg_record IN
	   	EXECUTE 'SELECT t1.network,t1.node,t1.device,t1.vargroup,t1.varkey FROM readings t1'
		|| ' INNER JOIN fields t2 ON t1.varkey = t2.varkey AND t1.vargroup = t2.vargroup'
		|| ' WHERE t2.kpi = true AND network = $1' 
   		USING networkin
	LOOP		
		loopcnt := loopcnt + 1;
		oot := oot + fn_kpi_operational(REPLACE(LOWER(avg_record.network||'_'||avg_record.node), '-', '_'), avg_record.device, avg_record.vargroup, avg_record.varkey, intervalin, time1, time2);	
	
    END LOOP;
	
    RETURN (oot / loopcnt);
    
END;
$$ LANGUAGE plpgsql;



