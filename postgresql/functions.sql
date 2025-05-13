CREATE OR REPLACE FUNCTION fn_n_n(networkin varchar, nodein varchar)
RETURNS text
AS $$
DECLARE
	
BEGIN
		
	RETURN REPLACE(LOWER(networkin||'_'||nodein), '-', '_');
	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;




CREATE OR REPLACE FUNCTION fn_get_numeric_value(networkref varchar, noderef varchar, deviceref varchar, vargroupref varchar, varkeyref varchar)
RETURNS numeric
AS $$
DECLARE
	v NUMERIC;
	avg_record RECORD;
BEGIN
	FOR avg_record IN
	EXECUTE 'SELECT value::numeric FROM readings '
	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref
	LOOP
		
		v = avg_record.value;
	
	END LOOP;

	RETURN v;
	
END;
$$ LANGUAGE plpgsql;


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


CREATE OR REPLACE FUNCTION fn_get_var_values(schemain varchar, networkin varchar, varkeyin varchar, time1 timestamp with time zone, time2 timestamp with time zone)
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
	   	EXECUTE 'SELECT DISTINCT node FROM ' || schemain || '.' || 'readings'
    	|| ' WHERE network = $1 AND varkey = $2'
   		USING networkin, varkeyin
	LOOP
		
		networknode := REPLACE(LOWER(networkin||'_'||avg_record.node), '-', '_');	
		FOR info_record IN
		   	EXECUTE 'SELECT time,device,vargroup,varkey,value FROM '
	    	|| schemain || '.' || networknode
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


CREATE OR REPLACE FUNCTION public.fn_get_var_values_inc_before(
	networkin character varying,
	varkeyin character varying,
	time1 timestamp with time zone,
	time2 timestamp with time zone)
    RETURNS TABLE(node character varying, device character varying, vargroup character varying, varkey character varying, value text, "time" timestamp with time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
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
	    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time < $4'
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

		FOR info_record IN
		   	EXECUTE 'SELECT time,device,vargroup,varkey,value FROM '
	    	|| quote_ident(networknode)
	    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
			USING avg_record.device, avg_record.vargroup, varkeyin, time1, time2
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
$BODY$;



CREATE OR REPLACE FUNCTION public.fn_get_var_values_inc_before(
	schemain character varying,
	networkin character varying,
	varkeyin character varying,
	time1 timestamp with time zone,
	time2 timestamp with time zone)
    RETURNS TABLE(node character varying, device character varying, vargroup character varying, varkey character varying, value text, "time" timestamp with time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	networknode TEXT := '';
	avg_record RECORD;
	info_record RECORD;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT DISTINCT node,device,vargroup,varkey FROM '||schemain||'.readings'
    	|| ' WHERE network = $1 AND varkey = $2'
   		USING networkin, varkeyin
	LOOP
		
		networknode := REPLACE(LOWER(networkin||'_'||avg_record.node), '-', '_');	
		FOR info_record IN
		   	EXECUTE 'SELECT time,device,vargroup,varkey,value FROM '||schemain||'.'||networknode
	    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time < $4'
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

		FOR info_record IN
		   	EXECUTE 'SELECT time,device,vargroup,varkey,value FROM '||schemain||'.'||networknode
	    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
			USING avg_record.device, avg_record.vargroup, varkeyin, time1, time2
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
$BODY$;






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




CREATE OR REPLACE FUNCTION fn_average_val(v1 float, v2 float)
RETURNS FLOAT AS $$
BEGIN
    
	RETURN (v1 + v2) / 2;
    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_average_nzval(v1 float, v2 float)
RETURNS FLOAT AS $$
BEGIN

	IF (v1 != 0.0) AND (v2 != 0.0) THEN
		RETURN (v1 + v2) / 2.0;
    ELSEIF (v1 != 0.0) THEN
		RETURN v1;
    ELSEIF (v2 != 0.0) THEN
		RETURN v2;
	ELSE
		RETURN (0.0);
	END IF;
	
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

CREATE OR REPLACE FUNCTION fn_max(networknode varchar, device varchar, vargroup varchar, varkey varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
    avg_record RECORD;
	max_v FLOAT := 0;
BEGIN
    FOR avg_record IN
	   	EXECUTE 'SELECT MAX(value::numeric) AS mvalue FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
   		USING device, vargroup, varkey, time1, time2
	LOOP		
		max_v := avg_record.mvalue;	
    END LOOP;
	
    
    RETURN (max_v);
    
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_max(schemain varchar, networknode varchar, device varchar, vargroup varchar, varkey varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
    avg_record RECORD;
	max_v FLOAT := 0;
BEGIN
    FOR avg_record IN
	   	EXECUTE 'SELECT MAX(value::numeric) AS mvalue FROM '
    	|| schemain || '.' || networknode
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
   		USING device, vargroup, varkey, time1, time2
	LOOP		
		max_v := avg_record.mvalue;	
    END LOOP;
	
    
    RETURN (max_v);
    
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
	
    	IF avg_cnt > 0 AND tot_w > 0 THEN
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

    IF avg_cnt > 0 AND tot_w > 0 THEN
		RETURN tot_wv / tot_w;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- SELECT fn_weighted_average('heatweb_network1','3016031af27a0c25','dat','tHoDHW','fHDHW')

CREATE OR REPLACE FUNCTION fn_weighted_average(network varchar, node varchar, device varchar, vargroup1 varchar, varkey1 varchar, vargroup2 varchar, varkey2 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
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
	networknode TEXT:= REPLACE(LOWER(network||'_'||node), '-', '_');	
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT value FROM readings'
    	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5 AND timestamp <= $6'
   		USING network, node, device, vargroup2, varkey2, time1
	LOOP
		last_w := avg_record.value::numeric;
	
	END LOOP;
	
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

    IF avg_cnt > 0 AND tot_w > 0 THEN
		RETURN tot_wv / tot_w;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_time_average(schemain varchar, networknode varchar, device varchar, vargroup varchar, varkey1 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
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
    	|| schemain || '.' || networknode
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

    IF avg_cnt > 0 AND tot_w > 0 THEN
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

-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_phe_efficicency(network varchar, node varchar, device varchar, vargroup1 varchar, tfprim varchar, trprim varchar, trsec varchar, vargroup2 varchar, varkey2 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	oot FLOAT := 0;
	trsecv FLOAT := 0;
	trprimv FLOAT := 0;
	tfprimv FLOAT := 0;
BEGIN

	trsecv = fn_weighted_average(network,node,device,vargroup1,trsec,vargroup2,varkey2,time1, time2);
	tfprimv = fn_weighted_average(network,node,device,vargroup1,tfprim,vargroup2,varkey2, time1, time2);
	trprimv = fn_weighted_average(network,node,device,vargroup1,trprim,vargroup2,varkey2,time1, time2);

	IF (tfprimv - trsecv) > 0.0 THEN
		oot = 1.0 - ((trprimv - trsecv)/(tfprimv - trsecv));
	ELSE
		oot = 0.0;
	END IF;

	RETURN oot;
    
END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_ds439(N numeric)
RETURNS FLOAT AS $$
BEGIN
	RETURN ((1.19 * N) + (18.8 * POWER(N,0.5)) + 17.6);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_htg_diversity(N numeric)
RETURNS FLOAT AS $$
BEGIN
	RETURN ((0.38 / N) + 0.62);
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_first_time_when_not(network varchar, node varchar, device varchar, vargroup varchar, varkey varchar, whenis varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS timestamp with time zone AS $$
DECLARE
	last_time timestamp with time zone;
    avg_record RECORD;
	avg_cnt INTEGER := 0;
	networknode TEXT:= REPLACE(LOWER(network||'_'||node), '-', '_');	
BEGIN

    FOR avg_record IN
	   	EXECUTE 'SELECT time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND value != $4 AND time >= $5 AND time <= $6'
		|| ' ORDER BY time ASC LIMIT 1'
   		USING device, vargroup, varkey, whenis, time1, time2
	LOOP
		
		last_time := avg_record.time;
		avg_cnt := avg_cnt + 1;
    END LOOP;

    IF (avg_cnt > 0) THEN
		
		RETURN last_time ;
    ELSE
        RETURN null;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_first_time_when(network varchar, node varchar, device varchar, vargroup varchar, varkey varchar, whenis varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS timestamp with time zone AS $$
DECLARE
	last_time timestamp with time zone;
    avg_record RECORD;
	avg_cnt INTEGER := 0;
	networknode TEXT:= REPLACE(LOWER(network||'_'||node), '-', '_');	
BEGIN

    FOR avg_record IN
	   	EXECUTE 'SELECT time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND value = $4 AND time >= $5 AND time <= $6'
		|| ' ORDER BY time ASC LIMIT 1'
   		USING device, vargroup, varkey, whenis, time1, time2
	LOOP
		
		last_time := avg_record.time;
		avg_cnt := avg_cnt + 1;
    END LOOP;

    IF (avg_cnt > 0) THEN
		
		RETURN last_time ;
    ELSE
        RETURN null;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_first_time(network varchar, node varchar, device varchar, vargroup varchar, varkey varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS timestamp with time zone AS $$
DECLARE
	last_time timestamp with time zone;
    avg_record RECORD;
	avg_cnt INTEGER := 0;
	networknode TEXT:= REPLACE(LOWER(network||'_'||node), '-', '_');	
BEGIN

    FOR avg_record IN
	   	EXECUTE 'SELECT time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
		|| ' ORDER BY time ASC LIMIT 1'
   		USING device, vargroup, varkey, time1, time2
	LOOP
		
		last_time := avg_record.time;
		avg_cnt := avg_cnt + 1;
    END LOOP;

    IF (avg_cnt > 0) THEN
		
		RETURN last_time ;
    ELSE
        RETURN null;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_devices_property(networkin varchar, varkeyin varchar)
RETURNS table
(
	"__text" text,
	"__value" text
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

		__text := avg_record.device; 
		__value := avg_record.device;
		
		networknode := REPLACE(LOWER(networkin||'_'||avg_record.node), '-', '_');	
		FOR info_record IN
		   	EXECUTE 'SELECT DISTINCT value FROM readings'
    		|| ' WHERE network = $1 AND device = $2 AND varkey = $3'
			USING networkin, avg_record.device, 'property'
		LOOP
			
		   
			__text := info_record.value;
			
		
	    END LOOP;

	RETURN NEXT;
	
    END LOOP;

	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_name(schemain varchar, networkin varchar, device varchar)
RETURNS text
AS $$
DECLARE
	info_record RECORD;
	oot TEXT := device;
BEGIN
		
		FOR info_record IN
		   	EXECUTE 'SELECT value FROM ' || schemain || '.readings'
    		|| ' WHERE network = $1 AND device = $2 AND vargroup = $3 AND varkey = $4'
			USING networkin, device, 'system', 'name'
		LOOP
			
		   
			oot = info_record.value;
		
	    END LOOP;

	RETURN oot;
	
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_get_name(schemain varchar, networkin varchar, nodein varchar, device varchar)
RETURNS text
AS $$
DECLARE
	info_record RECORD;
	oot TEXT := device;
BEGIN
		
		FOR info_record IN
		   	EXECUTE 'SELECT value FROM ' || schemain || '.readings'
    		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
			USING networkin, nodein, device, 'system', 'name'
		LOOP
			
		   
			oot = info_record.value;
		
	    END LOOP;

		RETURN oot;
	
  

	
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_get_named_networks()
RETURNS table
(
	"__text" text,
	"__value" text
)
AS $$
DECLARE
	avg_record RECORD;
	info_record RECORD;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT DISTINCT network FROM readings'
   		USING ''
	LOOP

		__text := avg_record.network; 
		__value := avg_record.network;
		
		
		FOR info_record IN
		   	EXECUTE 'SELECT DISTINCT value FROM readings'
    		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
			USING avg_record.network, 'global', 'network', 'system', 'name'
		LOOP
			
		   
			__text := info_record.value;
			
		
	    END LOOP;

		RETURN NEXT;
	
    END LOOP;

	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_qcalcs_cc(schemain varchar, networkin varchar, nodein varchar, device varchar, vargroup varchar, varkey varchar)
RETURNS BOOLEAN AS $$
DECLARE
    avg_record RECORD;
	mwhere TEXT;
	devicetype TEXT := 'unknown';
	devicetypes TEXT;
	res BOOLEAN := false;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT * FROM ' || schemain || '.readings WHERE '
		   || 'network=$1 AND node=$2 AND device=$3 AND vargroup=$4 AND varkey=$5' 
   		USING networkin, nodein, device, 'system', 'deviceType'
	LOOP
		devicetype = avg_record.value;			
    END LOOP;

    FOR avg_record IN
	   	EXECUTE 'SELECT * FROM qcalcs WHERE vargroup=$1 AND varkey=$2' 
   		USING vargroup, varkey
	LOOP		
		mwhere := avg_record.condition;
		devicetypes := avg_record.devicetypes;
    END LOOP;

	IF devicetypes!='*' AND POSITION((','||devicetype||',') IN (','||devicetypes||','))=0 THEN 
		RETURN (false);
	END IF;
	 

	IF POSITION('{{' IN mwhere)=1 AND POSITION('}}' IN mwhere)=(length(mwhere)-1) THEN

		mwhere = CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || CHR(39) 
		|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || 'false' || CHR(39)
		|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || 'No' || CHR(39)
		|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || 'no' || CHR(39)
		|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || '0' || CHR(39);
		
	END IF;

	FOR avg_record IN
	   	EXECUTE 'SELECT * FROM ' || schemain || '.readings WHERE '
		   || 'network=$1 AND node=$2 AND device=$3 AND vargroup=$4' 
   		USING networkin, nodein, device, vargroup
	LOOP		

		mwhere = REPLACE(mwhere, '{{'||avg_record.varkey||'}}', avg_record.value);	
		
    END LOOP;

	IF POSITION('{{' IN mwhere)=0 THEN
	
		FOR avg_record IN
		   	EXECUTE 'SELECT 1 AS value WHERE ' || mwhere
	   		USING 1
		LOOP		
			res := true;	
	    END LOOP;

	END IF;
    
    RETURN (res);
    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_run_calc_from(schemain varchar, networkin varchar, nodein varchar, devicein varchar, vargroupin varchar, ftable varchar)
RETURNS table
(
	network character varying(64),
	node character varying(32),
	device character varying(64),
	vargroup character varying(16),
	varkey character varying(64),
	calculation text,
	"value" text,
	"title" text,
	"units" character varying(16)
)
AS $$
DECLARE
    avg_record RECORD;
	calc_record RECORD;
	mwhere TEXT;
	devicetype TEXT := 'unknown';
	devicetypes TEXT;
	res BOOLEAN := false;
	passes BOOLEAN := true;
	calculations JSONB := '{}'::jsonb;
BEGIN

	network := networkin;
	node := nodein;
	device := devicein;
	vargroup = vargroupin;

	FOR avg_record IN
	   	EXECUTE 'SELECT * FROM ' || schemain || '.readings WHERE '
		   || 'network=$1 AND node=$2 AND device=$3 AND vargroup=$4 AND varkey=$5' 
   		USING networkin, nodein, device, 'system', 'deviceType'
	LOOP
		devicetype = avg_record.value;			
    END LOOP;

    FOR calc_record IN
	   	EXECUTE 'SELECT * FROM public.' || ftable || ' WHERE vargroup=$1 ORDER BY "order"' 
   		USING vargroupin
	LOOP		

		varkey = calc_record.varkey;
		value = calc_record.calculation;
		units = calc_record.units;
		title = calc_record.title;
		calculation = calc_record.calculation;
		
		mwhere := calc_record.condition;
		devicetypes := calc_record.devicetypes;
		passes = false;

		IF devicetypes='*' OR POSITION((','||devicetype||',') IN (','||devicetypes||','))>0 THEN 
			
			
			IF POSITION('{{' IN mwhere)=1 AND POSITION('}}' IN mwhere)=(length(mwhere)-1) THEN
		
				mwhere = CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || CHR(39) 
				|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || 'false' || CHR(39)
				|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || 'No' || CHR(39)
				|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || 'no' || CHR(39)
				|| ' AND ' || CHR(39) || mwhere || CHR(39) || '!=' || CHR(39) || '0' || CHR(39);
				
			END IF;
		
			FOR avg_record IN
			   	EXECUTE 'SELECT * FROM ' || schemain || '.readings WHERE '
				   || 'network=$1 AND node=$2 AND device=$3 AND vargroup=$4' 
		   		USING networkin, nodein, device, vargroup
			LOOP		
		
				mwhere = REPLACE(mwhere, '{{'||avg_record.varkey||'}}', avg_record.value);	
				value = REPLACE(value, '{{'||avg_record.varkey||'}}', avg_record.value);	
				
		    END LOOP;


			FOR avg_record IN
			
			   	EXECUTE 'select * from json_each_text($1)'
				USING calculations::json
		
			LOOP		
				mwhere = REPLACE(mwhere, '{{'||avg_record.key||'}}', avg_record.value);	
				value = REPLACE(value, '{{'||avg_record.key||'}}', avg_record.value);	
				
		    END LOOP;

	
			IF POSITION('{{' IN mwhere)=0 THEN
			
				FOR avg_record IN
				   	EXECUTE 'SELECT 1 AS value WHERE ' || mwhere
			   		USING 1
				LOOP		
					passes := true;	
			    END LOOP;
		
			END IF;

			--varkey IN ('density','pPP','boilerkWPeak') AND 
			IF POSITION('{{' IN value)=0 AND POSITION('?' IN value)=0 AND POSITION('parse' IN value)=0  AND POSITION('Math' IN value)=0 THEN
			
				FOR avg_record IN
				   	EXECUTE 'SELECT ROUND((' || value || ')::numeric,1)::text AS value '
			   		USING 1
				LOOP		
					value := avg_record.value;	
			    END LOOP;					

			END IF;

			
		    IF passes = true THEN 

				calculations = calculations || ('{"' || varkey || '":"'|| value || '"}')::jsonb;
				RETURN NEXT;
			END IF;
		
			
		END IF;
		
    END LOOP;
	
    
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.fn_all_faults()
    RETURNS TABLE(schemaname character varying, network character varying, node character varying, device character varying, vargroup character varying, varkey character varying, value text, "time" timestamp with time zone, response float, date character varying, deadline character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	networknode TEXT := '';
	avg_record RECORD;
	info_record RECORD;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT nspname as schema_name FROM  pg_namespace WHERE nspname NOT LIKE ($1) AND nspname != $2'
   		USING '%\_%', 'public'
	LOOP
		
		FOR info_record IN
		   	EXECUTE 'SELECT t1.*, (t1.timestamp + t2.responsetime) AS deadline, '
			   || '(EXTRACT(epoch FROM t2.responsetime)/(3600 * 24)) AS response, '
			   || 'TO_CHAR(t1.timestamp :: DATE, $1) AS date FROM ' || avg_record.schema_name ||  '.readings t1 '
			   || 'LEFT OUTER JOIN faults t2 ON t1.varkey = t2.varkey WHERE t1.vargroup=$2 ANd LOWER(value) NOT LIKE ($3)'
			USING 'dd/mm/yyyy', 'fault', 'ok%'
		LOOP
			
		    time := info_record.timestamp;
			network := info_record.network;
			device := info_record.device;
			node := info_record.node;
			vargroup := info_record.vargroup;
			varkey := info_record.varkey;
			value := ''||info_record.value;
			response := ''||info_record.response;
			date := ''||info_record.date;
			deadline := ''||info_record.deadline;
			schemaname := ''||avg_record.schema_name;
			RETURN NEXT;
		
	    END LOOP;

	
    END LOOP;

	
END;
$BODY$;


CREATE OR REPLACE FUNCTION public.fn_all_faults_plus()
    RETURNS TABLE(schemaname character varying, network character varying, node character varying, device character varying, vargroup character varying, varkey character varying, value text, "time" timestamp with time zone, response float, date character varying, parts_required character varying, next_action character varying, assigned_to character varying, photo character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	networknode TEXT := '';
	avg_record RECORD;
	info_record RECORD;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT nspname as schema_name FROM  pg_namespace WHERE nspname NOT LIKE ($1) AND nspname != $2'
   		USING '%\_%', 'public'
	LOOP
		
		FOR info_record IN
			EXECUTE 'WITH t3 AS (SELECT t1.*, (EXTRACT(epoch FROM t2.responsetime)/(3600 * 24)) AS stdresponse,  '
			|| 'TO_CHAR(t1.timestamp :: DATE, $1) AS date FROM ' || avg_record.schema_name ||  '.readings t1  '
			|| 'LEFT OUTER JOIN faults t2 ON t1.varkey = t2.varkey WHERE t1.vargroup=$2 AND LOWER(t1.value) NOT LIKE ($3) AND LOWER(t1.value)!=$11) '
			|| 'SELECT t3.*, t3.node||$12||t3.device AS nodedev, coalesce((t4.json->>$4)::numeric,  '
			|| 't3.stdresponse) AS response, t4.json->>$5 AS parts_required,  '
			|| 't4.json->>$6 AS next_action, t4.json->>$7 AS assigned_to, '
			|| '$8 || (t4.json->>$9) AS photo '
			|| 'FROM t3 LEFT OUTER JOIN ' || avg_record.schema_name ||  '.jsondata t4 ON t3.network = t4.network AND t3.node = t4.node AND t3.device = t4.device '
			|| 'AND t3.vargroup = t4.vargroup AND t3.varkey = t4.varkey '
			|| 'ORDER BY timestamp DESC; '
			   
			USING 'dd/mm/yyyy', 'fault', 'ok%', 'response', 'parts_required', 'next_action', 'assigned_to', 'https://heatweb.b-cdn.net/servicedata/uploads/', 'photo', '', 'healthy','.'
		LOOP
			
		    time := info_record.timestamp;
			network := info_record.network;
			device := info_record.device;
			node := info_record.node;
			vargroup := info_record.vargroup;
			varkey := info_record.varkey;
			value := ''||info_record.value;
			response := ''||info_record.response;
			date := ''||info_record.date;
			parts_required := coalesce(info_record.parts_required,'');
			next_action := coalesce(info_record.next_action,'');
			assigned_to := coalesce(info_record.assigned_to,'');
			photo := coalesce(info_record.photo,'');
			schemaname := coalesce(avg_record.schema_name,'');
			RETURN NEXT;
		
	    END LOOP;

	
    END LOOP;

	
END;
$BODY$;
