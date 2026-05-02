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



CREATE OR REPLACE FUNCTION fn_unit_json(vargroup text, varkey text)
RETURNS JSONB
AS $$
DECLARE
	vout JSONB := '{"vargroup":"' || vargroup || '","varkey":"' || varkey || '"}';
	vjson JSONB;
	avg_record RECORD;
	info_record RECORD;
BEGIN	

	FOR avg_record IN
	EXECUTE 'SELECT * FROM fields '
	|| ' WHERE vargroup = $1 AND varkey = $2 LIMIT 1'
	USING vargroup, varkey
	LOOP
		
		vout = jsonb_insert(vout, '{title}', ('"'||avg_record.title||'"')::jsonb);
		vout = jsonb_insert(vout, '{units}', ('"'||avg_record.units||'"')::jsonb);
	
	END LOOP;


	FOR info_record IN
	EXECUTE 'SELECT * FROM unit_limits '
	|| ' WHERE units = $1'
	USING vout->>'units'
	LOOP

		vjson = '{"min":' || info_record.min || ',"max":' || info_record.max || '}';
		vout = vout || vjson;
		
	END LOOP;

	RETURN vout;
	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_year_factor(stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
BEGIN	

	vout = EXTRACT(EPOCH FROM (etime - stime));
	vout = vout / (60 * 60 * 24);
	vout = 365 / vout;

	RETURN vout;
	
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_hours_in(time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS numeric AS $$
DECLARE
    avg_record RECORD;
	oot numeric := 0.0;
	oot1 numeric := 0.0;
BEGIN
	FOR avg_record IN
	   	EXECUTE 'SELECT (EXTRACT(EPOCH FROM $2) - EXTRACT(EPOCH FROM $1)) AS value'
   		USING time1, time2
	LOOP		
		oot := avg_record.value;	
	END LOOP;
	
	RETURN round((oot / 3600)::numeric, 2);
    
END;
$$ LANGUAGE plpgsql;



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




CREATE OR REPLACE FUNCTION fn_get_table_values(schemain varchar, networkin varchar, nodein varchar, devicein varchar, vargroupin varchar, varkeyin varchar)
RETURNS table
(
	"varkey" character varying(64),
	"value" text
)
AS $$
DECLARE
	networknode TEXT := '';
	nnd TEXT := '';
	loopcnt NUMERIC :=0;
	avg_record RECORD;
	info_record RECORD;
BEGIN

	FOR avg_record IN
	   	EXECUTE 'WITH t1 AS (SELECT t2.value FROM ' || schemain || '.readings t1 
				INNER JOIN json_array_elements(t1.value::json) t2 ON 1=1
				WHERE t1.network =$2 AND t1.node=$3 AND t1.device=$4 AND t1.vargroup=$5 AND t1.varkey=$6)
				SELECT * FROM t1;'
   		USING schemain, networkin, nodein, devicein, vargroupin, varkeyin
	LOOP
		
		loopcnt = 0;
		
		FOR info_record IN
		EXECUTE 'SELECT * FROM json_each_text($1::json);'
   		USING avg_record.value
		   
		LOOP			

			loopcnt = loopcnt + 1;
			IF (loopcnt=1) THEN
			
				nnd = devicein||'_' || vargroupin || '_' || varkeyin || '_' ||  info_record.value;
				
			ELSE
				
				varkey := REPLACE(nnd || '_' ||  info_record.key, ' ', ''); 
				value := info_record.value;
				RETURN NEXT;
				
			END IF;
			
		
	    END LOOP;		
		
		
    END LOOP;

	
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_get_topic_value(topic text)
RETURNS TEXT
AS $$
DECLARE
	v TEXT := '';
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN

	networkref = TRIM(SPLIT_PART(topic, '/', 1));
	noderef = TRIM(SPLIT_PART(topic, '/', 2));
	deviceref = TRIM(SPLIT_PART(topic, '/', 3));
	vargroupref = TRIM(SPLIT_PART(topic, '/', 4));
	varkeyref = TRIM(SPLIT_PART(topic, '/', 5));

	FOR avg_record IN
	EXECUTE 'SELECT value FROM readings '
	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref
	LOOP
		
		v = avg_record.value;
	
	END LOOP;

	RETURN v;
	
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION fn_resolve_topic(topic text)
RETURNS TEXT
AS $$
DECLARE
	v TEXT := '';
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
	t = topic;
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));

	FOR avg_record IN
	EXECUTE 'SELECT value FROM readings '
	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref
	LOOP
		
		v = avg_record.value;
	
	END LOOP;

	IF (v='_lookup') THEN

		v=null;

		FOR avg_record IN
		EXECUTE 'SELECT json FROM jsondata '
		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
		USING networkref, noderef, deviceref, vargroupref, varkeyref
		LOOP			
			t = TRIM(((avg_record.json->'lookup')::text),'''');
			t = TRIM(t,'"');
		END LOOP;		
	END IF;
	RETURN t;

END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION fn_get_topic_value(dtopic text, topic text)
RETURNS TEXT
AS $$
DECLARE
	v TEXT := '';
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
	t = topic;
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<1) THEN
		t = 'reading' || '/' || t;
	END IF;

	IF (lv<2) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 3)) || '/' || t;
	END IF;
	
	IF (lv<3) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 2)) || '/' || t;
	END IF;
	
	IF (lv<4) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 1)) || '/' || t;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));

	FOR avg_record IN
	EXECUTE 'SELECT value FROM readings '
	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref
	LOOP
		
		v = avg_record.value;
	
	END LOOP;

	IF (v='_lookup') THEN
		
		v=null;
		FOR avg_record IN
		EXECUTE 'SELECT json FROM jsondata '
		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
		USING networkref, noderef, deviceref, vargroupref, varkeyref
		LOOP			
			t = TRIM(((avg_record.json->'lookup')::text),'"');
		END LOOP;
	
		networkref = TRIM(SPLIT_PART(t, '/', 1));
		noderef = TRIM(SPLIT_PART(t, '/', 2));
		deviceref = TRIM(SPLIT_PART(t, '/', 3));
		vargroupref = TRIM(SPLIT_PART(t, '/', 4));
		varkeyref = TRIM(SPLIT_PART(t, '/', 5));
	
		FOR avg_record IN
		EXECUTE 'SELECT value FROM readings '
		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
		USING networkref, noderef, deviceref, vargroupref, varkeyref
		LOOP			
			v = avg_record.value;
		
		END LOOP;
	
	
	END IF;

	RETURN v;
	

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_topic_reading(dtopic text, topic text)
RETURNS table
(
	"node" character varying(32),
	"device" character varying(32),
	"vargroup" character varying(16),
	"varkey" character varying(64),
	"value" text,
    "timestamp" timestamp with time zone
)
AS $$
DECLARE
	v TEXT := '';
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
	t = topic;
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<1) THEN
		t = 'reading' || '/' || t;
	END IF;

	IF (lv<2) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 3)) || '/' || t;
	END IF;
	
	IF (lv<3) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 2)) || '/' || t;
	END IF;
	
	IF (lv<4) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 1)) || '/' || t;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));

	FOR avg_record IN
	EXECUTE 'SELECT * FROM readings '
	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref
	LOOP		
		    timestamp := avg_record.timestamp;
			device := avg_record.device;
			node := avg_record.node;
			vargroup := avg_record.vargroup;
			varkey := avg_record.varkey;
			value := avg_record.value;
			--RETURN NEXT;
	
	END LOOP;

	IF (value='_lookup') THEN

		value := null;
		
		FOR avg_record IN
		EXECUTE 'SELECT json FROM jsondata '
		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
		USING networkref, noderef, deviceref, vargroupref, varkeyref
		LOOP			
			t = TRIM(((avg_record.json->'lookup')::text),'"');
		END LOOP;
	
		networkref = TRIM(SPLIT_PART(t, '/', 1));
		noderef = TRIM(SPLIT_PART(t, '/', 2));
		deviceref = TRIM(SPLIT_PART(t, '/', 3));
		vargroupref = TRIM(SPLIT_PART(t, '/', 4));
		varkeyref = TRIM(SPLIT_PART(t, '/', 5));
	
		FOR avg_record IN
		EXECUTE 'SELECT * FROM readings '
		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
		USING networkref, noderef, deviceref, vargroupref, varkeyref
		LOOP		
		
			timestamp := avg_record.timestamp;
			device := avg_record.device;
			node := avg_record.node;
			vargroup := avg_record.vargroup;
			varkey := avg_record.varkey;
			value := avg_record.value;	
			--RETURN NEXT;	
		
		END LOOP;
	
	
	END IF;

	RETURN NEXT;
	

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_topic_ref(dtopic text, topic text)
RETURNS TEXT
AS $$
DECLARE
	v TEXT := '';
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
	t = topic;
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<1) THEN
		t = 'reading' || '/' || t;
	END IF;

	IF (lv<2) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 3)) || '/' || t;
	END IF;
	
	IF (lv<3) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 2)) || '/' || t;
	END IF;
	
	IF (lv<4) THEN
		t = TRIM(SPLIT_PART(dtopic, '/', 1)) || '/' || t;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));

	FOR avg_record IN
	EXECUTE 'SELECT value FROM readings '
	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref
	LOOP
		
		v = avg_record.value;
	
	END LOOP;

	IF (v='_lookup') THEN
		
		v=null;
		FOR avg_record IN
		EXECUTE 'SELECT json FROM jsondata '
		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
		USING networkref, noderef, deviceref, vargroupref, varkeyref
		LOOP			
			t = TRIM(((avg_record.json->'lookup')::text),'"');
		END LOOP;	
	
	
	END IF;

	RETURN t;
	

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_calc_using(calcin text, dtopic text, usingin text)
RETURNS TEXT
AS $$
DECLARE
	v TEXT := '';
	calc TEXT := '';
	to_text TEXT;
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
	calc = calcin;
	to_text = '';
	
	lv = (CHAR_LENGTH(calcin) - CHAR_LENGTH(REPLACE(calcin, '$', ''))) / CHAR_LENGTH('$');

	IF (POSITION('$1' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 1));
		to_text = fn_get_topic_value(dtopic, to_text);		
		calc = REPLACE(calc, '$1', to_text);
	END IF;

	IF (POSITION('$2' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 2));
		to_text = fn_get_topic_value(dtopic, to_text);		
		calc = REPLACE(calc, '$2', to_text);
	END IF;
	
	IF (POSITION('$3' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 3));
		to_text = fn_get_topic_value(dtopic, to_text);		
		calc = REPLACE(calc, '$3', to_text);
	END IF;
	
	IF POSITION('{{' IN calc)=0 AND POSITION('?' IN calc)=0 AND POSITION('$' IN calc)=0  AND POSITION('Math' IN calc)=0 THEN
			
		FOR avg_record IN
			EXECUTE 'SELECT ROUND((' || calc || ')::numeric,1)::text AS value '
			USING 1
		LOOP		
			v := avg_record.value;	
		END LOOP;					

	END IF;

	RETURN v;
	
EXCEPTION
    WHEN OTHERS THEN
        RETURN v;	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_calc_using(calcin text, dtopic text, usingin text, stime timestamp, etime timestamp)
RETURNS TEXT
AS $$
DECLARE
	v TEXT := '';
	calc TEXT := '';
	to_text TEXT;
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
	calc = calcin;
	to_text = '';
	
	IF (calcin='') THEN
		RETURN null;
	END IF;

	IF (calcin IS NULL) THEN
		RETURN null;
	END IF;
	IF (POSITION('$F' IN calc)>0) THEN
		calc = REPLACE(calc, '$F', '''' || stime || '''');
	END IF;

	IF (POSITION('$T' IN calc)>0) THEN
		calc = REPLACE(calc, '$T', '''' || etime || '''');
	END IF;

	IF (POSITION('#1' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 1));		
		calc = REPLACE(calc, '#1', '''' || to_text || '''');
	END IF;

	IF (POSITION('#2' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 2));		
		calc = REPLACE(calc, '#2', '''' || to_text || '''');
	END IF;

	IF (POSITION('@1' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 1));		
		to_text = fn_get_topic_ref(dtopic, to_text);			
		calc = REPLACE(calc, '@1', '''' || to_text || '''');
	END IF;

	IF (POSITION('@2' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 2));		
		to_text = fn_get_topic_ref(dtopic, to_text);			
		calc = REPLACE(calc, '@2', '''' || to_text || '''');
	END IF;

	IF (POSITION('@3' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 3));		
		to_text = fn_get_topic_ref(dtopic, to_text);			
		calc = REPLACE(calc, '@3', '''' || to_text || '''');
	END IF;

	IF (POSITION('@4' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 4));		
		to_text = fn_get_topic_ref(dtopic, to_text);			
		calc = REPLACE(calc, '@4', '''' || to_text || '''');
	END IF;

	IF (POSITION('$1' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 1));
		to_text = fn_get_topic_value(dtopic, to_text);		
		calc = REPLACE(calc, '$1', to_text);
	END IF;

	IF (POSITION('$2' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 2));
		to_text = fn_get_topic_value(dtopic, to_text);		
		calc = REPLACE(calc, '$2', to_text);
	END IF;
	
	IF (POSITION('$3' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 3));
		to_text = fn_get_topic_value(dtopic, to_text);		
		calc = REPLACE(calc, '$3', to_text);
	END IF;
	
	IF (POSITION('$4' IN calc)>0) THEN
		to_text = TRIM(SPLIT_PART(usingin, ',', 4));
		to_text = fn_get_topic_value(dtopic, to_text);		
		calc = REPLACE(calc, '$4', to_text);
	END IF;
	
	IF POSITION('{{' IN calc)=0 AND POSITION('?' IN calc)=0 AND POSITION('$' IN calc)=0  AND POSITION('Math' IN calc)=0 THEN
			
		FOR avg_record IN
			EXECUTE 'SELECT (' || calc || ')::text AS value '
			USING 1
		LOOP		
			v := avg_record.value;	
		END LOOP;					

	END IF;

	RETURN v;
	
EXCEPTION
    WHEN OTHERS THEN
        RETURN v;	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_pc_topic_above_v(topic text, v numeric, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
	n numeric;
	tc numeric;
	txt TEXT;
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networknode TEXT;
BEGIN
	t = topic;
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));

	FOR avg_record IN
	EXECUTE 'SELECT value FROM readings '
	|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
	USING networkref, noderef, deviceref, vargroupref, varkeyref
	LOOP
		
		txt = avg_record.value;
	
	END LOOP;

	IF (txt='_lookup') THEN
		
		FOR avg_record IN
		EXECUTE 'SELECT json FROM jsondata '
		|| ' WHERE network = $1 AND node = $2 AND device = $3 AND vargroup = $4 AND varkey = $5'
		USING networkref, noderef, deviceref, vargroupref, varkeyref
		LOOP			
			t = TRIM(((avg_record.json->'lookup')::text),'"');
		END LOOP;
	
		networkref = TRIM(SPLIT_PART(t, '/', 1));
		noderef = TRIM(SPLIT_PART(t, '/', 2));
		deviceref = TRIM(SPLIT_PART(t, '/', 3));
		vargroupref = TRIM(SPLIT_PART(t, '/', 4));
		varkeyref = TRIM(SPLIT_PART(t, '/', 5));
	
	END IF;

	networknode = fn_n_n(networkref, noderef);
	
	FOR avg_record IN
	EXECUTE 'SELECT COUNT(value) AS value FROM '
	|| quote_ident(networknode)
	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
	USING deviceref, vargroupref, varkeyref, stime, etime
	LOOP			
		tc = avg_record.value;	
	END LOOP;


	IF (tc=0) THEN
		return null;
	END IF;


	FOR avg_record IN
	EXECUTE 'SELECT COUNT(value) AS value FROM '
	|| quote_ident(networknode)
	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
	|| ' AND pg_input_is_valid(value, ''numeric'') AND value::numeric > $6'
	USING deviceref, vargroupref, varkeyref, stime, etime, v
	LOOP			
		n = avg_record.value;	
	END LOOP;

	RETURN ROUND(100.0 * n / tc, 1);
	

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_pc_topic_in_range(topic text, v numeric, tolerance numeric, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
	n numeric;
	tc numeric;
	txt TEXT;
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networknode TEXT;
BEGIN
	t = fn_resolve_topic(topic);
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));

	networknode = fn_n_n(networkref, noderef);
	
	FOR avg_record IN
	EXECUTE 'SELECT COUNT(value) AS value FROM '
	|| quote_ident(networknode)
	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
	USING deviceref, vargroupref, varkeyref, stime, etime
	LOOP			
		tc = avg_record.value;	
	END LOOP;


	IF (tc=0) THEN
		return null;
	END IF;


	FOR avg_record IN
	EXECUTE 'SELECT COUNT(value) AS value FROM '
	|| quote_ident(networknode)
	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4 AND time <= $5'
	|| ' AND pg_input_is_valid(value, ''numeric'') AND value::numeric > ($6-$7) AND value::numeric < ($6+$7)'
	USING deviceref, vargroupref, varkeyref, stime, etime, v, tolerance
	LOOP			
		n = avg_record.value;	
	END LOOP;

	RETURN ROUND(100.0 * n / tc, 1);
	

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_delta(topic text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
	first_v numeric := -1;
	last_v numeric := -1;
	txt TEXT;
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networknode TEXT;
	unit_json JSONB;
	vmin NUMERIC := 0;
	vmax NUMERIC := 1000000;
BEGIN
		
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;

	vargroupref = TRIM(SPLIT_PART(topic, '/', 4));
	varkeyref = TRIM(SPLIT_PART(topic, '/', 5));
	unit_json = fn_unit_json(vargroupref, varkeyref);
	vmin =  unit_json->'min';
	vmax =  unit_json->'max';
	
	t = fn_resolve_topic(topic);
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));

	networknode = fn_n_n(networkref, noderef);

	

	FOR avg_record IN
	   	EXECUTE 'SELECT value, time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time <= $4'
		|| ' AND value::numeric >= $6 AND value::numeric <= $7'	
		|| ' ORDER BY time DESC LIMIT 1'
   		USING deviceref, vargroupref, varkeyref, stime, etime, vmin, vmax
	LOOP		
		first_v := avg_record.value::numeric;	
    END LOOP;

	

	IF (first_v<0) THEN

		FOR avg_record IN
		   	EXECUTE 'SELECT value, time FROM '
	    	|| quote_ident(networknode)
	    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time > $4'
			|| ' AND value::numeric >= $6 AND value::numeric <= $7'		
			|| ' ORDER BY time ASC LIMIT 1'
	   		USING deviceref, vargroupref, varkeyref, stime, etime, vmin, vmax
		LOOP		
			first_v := avg_record.value::numeric;	
	    END LOOP;
	
	END IF;
 
	--|| ' AND value::numeric >= $6 AND value::numeric <= $7'
	
    FOR avg_record IN
	   	EXECUTE 'SELECT value, time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time <= $5'
		|| ' AND value::numeric >= $6 AND value::numeric <= $7'	
		|| ' ORDER BY time DESC LIMIT 1'
   		USING deviceref, vargroupref, varkeyref, stime, etime, vmin, vmax
	LOOP		
		last_v := avg_record.value::numeric;	
    END LOOP;

    RETURN (last_v - first_v);	

EXCEPTION WHEN others THEN
     RETURN 0;

END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION fn_weighted_average(topic text, topic2 text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
	first_v numeric;
	last_v numeric;
	txt TEXT;
	t TEXT := '';
	t2 TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networknode TEXT;
	varkeyref2 varchar;
BEGIN
	t = fn_resolve_topic(topic);
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));	
	networknode = fn_n_n(networkref, noderef);

	t2 = fn_resolve_topic(topic2);
	varkeyref2 = TRIM(SPLIT_PART(t2, '/', 5));	
	
	FOR avg_record IN	
	   	EXECUTE 'SELECT fn_weighted_average($1,$2,$3,$4,$5,$6,$7) as value;'
   		USING networknode, deviceref, vargroupref, varkeyref, varkeyref2, stime, etime
	LOOP		
		first_v := avg_record.value::numeric;	
    END LOOP;	

    RETURN ROUND(first_v,1);	

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_topic_variance(topic text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
	first_v numeric;
	last_v numeric;
	txt TEXT;
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networknode TEXT;
BEGIN
	t = fn_resolve_topic(topic);
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));	

	networknode = fn_n_n(networkref, noderef);

	FOR avg_record IN
	   	EXECUTE 'SELECT MIN(value) AS value FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4  AND time <= $5'
		|| ' AND pg_input_is_valid(value, ''numeric'')'
   		USING deviceref, vargroupref, varkeyref, stime, etime
	LOOP		
		first_v := avg_record.value::numeric;	
    END LOOP;
	
    FOR avg_record IN
	   	EXECUTE 'SELECT MAX(value) AS value FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time >= $4  AND time <= $5'
		|| ' AND pg_input_is_valid(value, ''numeric'')'
   		USING deviceref, vargroupref, varkeyref, stime, etime
	LOOP		
		last_v := avg_record.value::numeric;	
    END LOOP;

    RETURN (last_v - first_v);	

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_topic_time_average_diff(topic text, topic2 text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	rcnt numeric := 0;
	last_t timestamp;
	v1 numeric := 0.0;
	v2 numeric := 0.0;
	txt TEXT;
	t TEXT := '';
	t2 TEXT := '';
	lv NUMERIC := 0;
	avg_cnt INTEGER := 0;
	avg_tot numeric := 0.0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networknode TEXT;
	deviceref2 varchar;
	vargroupref2 varchar;
	varkeyref2 varchar;
BEGIN
	t = fn_resolve_topic(topic);
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));	
	
	networknode = fn_n_n(networkref, noderef);

	t2 = fn_resolve_topic(topic2);
	deviceref2 = TRIM(SPLIT_PART(t2, '/', 3));
	vargroupref2 = TRIM(SPLIT_PART(t2, '/', 4));
	varkeyref2 = TRIM(SPLIT_PART(t2, '/', 5));	


	
	FOR avg_record IN
	   	EXECUTE 'SELECT time_bucket(INTERVAL ''5 minutes'', time) AS times, varkey, AVG(value::numeric) AS value FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE ((device = $1 AND vargroup = $3 AND varkey = $4) OR (device = $2 AND vargroup = $5 AND varkey = $6)) AND time >= $7 AND time <= $8'
		|| ' GROUP BY times,varkey ORDER BY times ASC'
   		USING deviceref, deviceref2, vargroupref, varkeyref, vargroupref2, varkeyref2, stime, etime
	LOOP

		IF avg_record.times != last_t THEN
			rcnt = 1;
			v1 = avg_record.value;
		END IF;

		IF avg_record.times = last_t AND rcnt = 1 THEN
			rcnt = 2;
			v2 = avg_record.value;

			avg_cnt = avg_cnt + 1;

			IF avg_record.varkey = varkeyref THEN
				avg_tot = avg_tot + (v1 - v2);
			ELSE
				avg_tot = avg_tot + (v2 - v1);
			END IF;
			
			
		END IF;

		last_t = avg_record.times;
	
    END LOOP;

    IF (avg_cnt > 0) THEN
		RETURN ROUND(avg_tot / avg_cnt, 1);
    ELSE
        RETURN 0;
    END IF;

END;
$$ LANGUAGE plpgsql;



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


CREATE OR REPLACE FUNCTION fn_get_value_before(schemain varchar, networkin varchar, nodein varchar, devicein varchar, vargroupin varchar, varkeyin varchar, time1 timestamp with time zone)
RETURNS text
AS $$
DECLARE
	networknode TEXT := '';
	avg_record RECORD;
	info_record RECORD;
	oot TEXT := '';
BEGIN	
		networknode := REPLACE(LOWER(networkin||'_'||nodein), '-', '_');	
		FOR info_record IN
		   	EXECUTE 'SELECT value FROM '
	    	|| schemain || '.' || networknode
	    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time <= $4'
	    	|| ' ORDER BY time DESC LIMIT 1'
			USING devicein, vargroupin, varkeyin, time1
		LOOP
			
		    oot := ''||info_record.value;
			
	    END LOOP;

	RETURN (oot);
	
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



CREATE OR REPLACE FUNCTION fn_span_interval(network varchar, node varchar, device varchar, vargroup1 varchar, varkey1 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
RETURNS INTERVAL AS $$
DECLARE
    avg_record RECORD;
	t_first TIMESTAMP;
	t_last TIMESTAMP;
	networknode TEXT:= REPLACE(LOWER(network||'_'||node), '-', '_');	
BEGIN

	FOR avg_record IN
	   	EXECUTE 'SELECT time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time > $4'
		|| ' ORDER BY time ASC LIMIT 1'
   		USING device, vargroup1, varkey1, time1, time2
	LOOP
		t_first := avg_record.time;
	
	END LOOP;

	FOR avg_record IN
	   	EXECUTE 'SELECT time FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time < $5'
		|| ' ORDER BY time DESC LIMIT 1'
   		USING device, vargroup1, varkey1, time1, time2
	LOOP
		t_last := avg_record.time;
	
	END LOOP;
   
	RETURN t_last - t_first;
    
END;
$$ LANGUAGE plpgsql;


-- -------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_vwatd(kwh numeric, m3 numeric)
RETURNS numeric
AS $$
DECLARE x NUMERIC;
	
BEGIN

	IF (m3 > 0.0) THEN
		RETURN (kwh*3600.0/(4200.0*m3));
	ELSE
		RETURN (0.0);
	END IF;	
	
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_vwatd(topic text, topic2 text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
	kwh numeric;
	m3 numeric;
	avg_record RECORD;
BEGIN
	
	
	FOR avg_record IN	
	   	EXECUTE 'SELECT fn_delta($1,$2,$3) as value;'
   		USING topic, stime, etime
	LOOP		
		kwh := avg_record.value::numeric;	
    END LOOP;	
	
	FOR avg_record IN	
	   	EXECUTE 'SELECT fn_delta($1,$2,$3) as value;'
   		USING topic2, stime, etime
	LOOP		
		m3 := avg_record.value::numeric;	
    END LOOP;	

  
    RETURN ROUND(fn_vwatd(kwh,m3),1);	

END;
$$ LANGUAGE plpgsql;




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


CREATE OR REPLACE FUNCTION fn_delta_weighted_average(network varchar, node varchar, device varchar, vargroup1 varchar, varkey1 varchar, vargroup2 varchar, varkey2 varchar, time1 timestamp with time zone, time2 timestamp with time zone)
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
	   	EXECUTE 'SELECT value FROM '
    	|| quote_ident(networknode)
    	|| ' WHERE device = $1 AND vargroup = $2 AND varkey = $3 AND time < $6'
		|| ' ORDER BY time DESC LIMIT 1'
   		USING device, vargroup1, varkey1, vargroup2, varkey2, time1, time2
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
			last_w := avg_record.value::numeric - last_w;
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


CREATE OR REPLACE FUNCTION fn_delta_weighted_average(topic text, topic2 text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vout numeric;
	first_v numeric;
	last_v numeric;
	txt TEXT;
	t TEXT := '';
	t2 TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networknode TEXT;
	vargroupref2 varchar;
	varkeyref2 varchar;
BEGIN
	t = fn_resolve_topic(topic);
	lv = (CHAR_LENGTH(topic) - CHAR_LENGTH(REPLACE(topic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;
	
	networkref = TRIM(SPLIT_PART(t, '/', 1));
	noderef = TRIM(SPLIT_PART(t, '/', 2));
	deviceref = TRIM(SPLIT_PART(t, '/', 3));
	vargroupref = TRIM(SPLIT_PART(t, '/', 4));
	varkeyref = TRIM(SPLIT_PART(t, '/', 5));	
	--networknode = fn_n_n(networkref, noderef);

	t2 = fn_resolve_topic(topic2);
	varkeyref2 = TRIM(SPLIT_PART(t2, '/', 5));
	vargroupref2 = TRIM(SPLIT_PART(t2, '/', 4));	
	
	FOR avg_record IN	
	   	EXECUTE 'SELECT fn_delta_weighted_average($1,$2,$3,$4,$5,$6,$7,$8,$9) as value;'
   		USING networkref, noderef, deviceref, vargroupref, varkeyref, vargroupref2, varkeyref2, stime, etime
	LOOP		
		first_v := avg_record.value::numeric;	
    END LOOP;	

    RETURN ROUND(first_v,1);	

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



CREATE OR REPLACE FUNCTION fn_element_pc_connectivity(topic text, stime timestamp with time zone, etime timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	v TEXT := '';
	vout FLOAT := 0.0;
	avg_record RECORD;
	info_record RECORD;
	r_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	pdays numeric;
	isr numeric := 0;
	rcount numeric := 0;
	mpcount numeric := 0;
	mpdcount numeric := 0;
	dstime timestamp with time zone;
	detime timestamp with time zone;
	
BEGIN

	pdays = fn_total_days_in_period(stime, etime);

	networkref = TRIM(SPLIT_PART(topic, '/', 1));
	noderef = TRIM(SPLIT_PART(topic, '/', 2));
	deviceref = TRIM(SPLIT_PART(topic, '/', 3));
	vargroupref = 'elementType';


	FOR avg_record IN
	EXECUTE 'WITH t1 AS (SELECT r.network,r.node,r.device,p.element_type, p.point_id,p.min_frequency,p.title AS monitoring_point
	FROM readings r INNER JOIN element_monitoring_points p ON r.value=p.element_type 
	WHERE varkey=$4 AND network=$1 AND node=$2 AND device=$3)
	SELECT t1.* FROM t1 
	ORDER BY network,node,device,element_type,point_id;'	
	USING networkref, noderef, deviceref, vargroupref, '/', stime, etime
	LOOP

		mpcount = mpcount + 1;
		
		FOR counter in 1..pdays LOOP

			mpdcount = mpdcount + 1;

			-- search for any reading during the day. on success, increment successful days and quit loop 
			
			dstime = stime + ((counter-1)::text||'d')::interval;		
			detime = dstime + INTERVAL '1d';			

			FOR info_record IN
			EXECUTE 'SELECT * FROM element_data_points WHERE mpid=$1;'	
			USING avg_record.point_id
			LOOP	

				isr = 0;
				FOR r_record IN
				EXECUTE 'SELECT * FROM fn_get_topic_values_inc_before($1||$6||$2||$6||$3||$6||$4||$6||$5, $7, $8) LIMIT 2;'	
				USING networkref, noderef, avg_record.device, info_record.vargroup, info_record.varkey, '/', dstime, detime, ''
				LOOP	

					isr = isr + 1;		
					
				END LOOP;
								
				IF isr > 1 THEN
					rcount = rcount + 1;
					EXIT;		
				END IF;				
			
			END LOOP;
			
		END LOOP;	
	
	END LOOP;

	IF rcount > 0 THEN
		vout = 100.0;			
	END IF;
	
	IF mpdcount > 0 THEN
		vout = 100.0 * rcount / mpdcount;	
		vout = ROUND(vout::numeric, 2);
	END IF;

	RETURN vout;
	
    
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



CREATE OR REPLACE FUNCTION public.fn_element_pc_completeness(
	topic text,
	stime timestamp with time zone,
	etime timestamp with time zone)
    RETURNS double precision
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	v TEXT := '';
	vout FLOAT := 0.0;
	avg_record RECORD;
	info_record RECORD;
	r_record RECORD;
	networkref varchar;
	networkref2 varchar;
	noderef varchar;	
	noderef2 varchar;
	deviceref varchar;
	deviceref2 varchar;
	vargroupref varchar;
	vargroupref2 varchar;
	varkeyref varchar;
	varkeyref2 varchar;
	pdays numeric;
	isr numeric := 0;
	rcount numeric := 0;
	expcount numeric := 0.0;
	mpdcount numeric := 0;
	columncount numeric := 0;
	columnrowcount numeric := 0;
	dstime timestamp with time zone;
	detime timestamp with time zone;
	networknode TEXT;
	pepoch numeric;
	set_interval interval;
	t TEXT;
	debugtxt TEXT := '';

	
BEGIN

	dstime = DATE_TRUNC('day', stime);
	detime = DATE_TRUNC('day', etime) + interval '24 hours';
	
	pepoch = EXTRACT(EPOCH FROM (detime - dstime)); --fn_total_days_in_period(stime, etime);
	pdays = fn_total_days_in_period(stime, etime);
	
	networkref = TRIM(SPLIT_PART(topic, '/', 1));
	noderef = TRIM(SPLIT_PART(topic, '/', 2));
	deviceref = TRIM(SPLIT_PART(topic, '/', 3));
	varkeyref = 'elementType';
	
	
	FOR avg_record IN
	EXECUTE 'WITH t1 AS (SELECT r.network,r.node,r.device,p.element_type, p.point_id,p.min_frequency,p.title AS monitoring_point
	FROM readings r INNER JOIN element_monitoring_points p ON r.value=p.element_type 
	WHERE varkey=$4 AND network=$1 AND node=$2)
	SELECT t1.* FROM t1 
	ORDER BY network,node,device,element_type,point_id;'	
	USING networkref, noderef, deviceref, varkeyref, '/', dstime, detime
	LOOP
			set_interval = avg_record.min_frequency;	
				
			expcount = (1.0 * pdays) / ( EXTRACT(EPOCH FROM set_interval) / (60*60*24) );
			mpdcount = mpdcount + expcount;

			columncount = 0;
			columnrowcount = 0;

			debugtxt = debugtxt || expcount::text ||', ';
			
			FOR info_record IN
			EXECUTE 'SELECT * FROM element_data_points WHERE mpid=$1 AND vargroup !=$2 AND vargroup !=$3;'	
			USING avg_record.point_id, 'design', 'setpoint'
			LOOP					

				columncount = columncount + 1;

				t = fn_resolve_topic(networkref||'/'||noderef||'/'||avg_record.device||'/'||info_record.vargroup||'/'||info_record.varkey);
				networkref2 = TRIM(SPLIT_PART(t, '/', 1));
				noderef2 = TRIM(SPLIT_PART(t, '/', 2));
				deviceref2 = TRIM(SPLIT_PART(t, '/', 3));
				vargroupref2 = TRIM(SPLIT_PART(t, '/', 4));
				varkeyref2 = TRIM(SPLIT_PART(t, '/', 5));

				networknode = fn_n_n(networkref2, noderef2);
	
				FOR r_record IN
				EXECUTE 'WITH t1 AS (SELECT device,vargroup,varkey,time_bucket($6, time) AS timestamp, COUNT(value) AS value FROM '
					|| quote_ident(networknode)
					|| ' WHERE device=$1 AND vargroup=$2 AND varkey=$3 AND time>=$4 AND time<=$5
						GROUP BY device,vargroup,varkey,timestamp
						ORDER BY timestamp)
						SELECT COUNT(value) AS cnt FROM t1;'
				USING deviceref2, vargroupref2, varkeyref2, dstime, detime, set_interval
				LOOP	

					columnrowcount = columnrowcount +  r_record.cnt;

					debugtxt = debugtxt || varkeyref2 || ' ' || r_record.cnt::text ||',, ';
								
				END LOOP;
				
				
			END LOOP;

			-- total number of values / number of columns = average number of rows.
			rcount = rcount + (columnrowcount / columncount);		

	
	END LOOP;

	IF rcount > 0 THEN
		vout = 100.0;			
	END IF;
	
	IF mpdcount > 0 THEN
		vout = 100.0 * rcount / mpdcount;	
		vout = ROUND(vout::numeric, 2);
	END IF;

	-- vout = mpdcount;		

	RETURN vout; --debugtxt; --
	
    
END;
$BODY$;



CREATE OR REPLACE FUNCTION fn_element_pc_operational(topic text, kpi_id numeric, stime timestamp with time zone, etime timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	v TEXT := '';
	vout FLOAT := 0.0;
	avg_record RECORD;
	info_record RECORD;
	r_record RECORD;
	r_record2 RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networkref2 varchar;
	noderef2 varchar;
	deviceref2 varchar;
	vargroupref2 varchar;
	varkeyref2 varchar;
	pepoch numeric;
	isr numeric := 0;
	rcount numeric := 0;
	expcount numeric := 0.0;
	okcount numeric := 0;
	mpdcount numeric := 0;
	dstime timestamp with time zone;
	detime timestamp with time zone;
	networknode TEXT;
	set_interval interval; 
	vmin numeric := 0;
	vmax numeric := 55000;
	t TEXT;
	
BEGIN

	dstime = DATE_TRUNC('day', stime);
	detime = DATE_TRUNC('day', etime) + interval '24 hours';
	
	pepoch = EXTRACT(EPOCH FROM (detime - dstime)); --fn_total_days_in_period(stime, etime);
		
	networkref = TRIM(SPLIT_PART(topic, '/', 1));
	noderef = TRIM(SPLIT_PART(topic, '/', 2));
	deviceref = TRIM(SPLIT_PART(topic, '/', 3));
	varkeyref = 'elementType';	
	
	FOR avg_record IN
	EXECUTE 'WITH t1 AS (SELECT r.network,r.node,r.device,p.element_type, p.point_id,p.min_frequency,p.title AS monitoring_point
	FROM readings r INNER JOIN element_monitoring_points p ON r.value=p.element_type 
	WHERE varkey=$4 AND network=$1 AND node=$2)
	SELECT t1.* FROM t1 
	ORDER BY network,node,device,element_type,point_id;'	
	USING networkref, noderef, deviceref, varkeyref, '/', dstime, detime
	LOOP
			IF kpi_id > 1 THEN
				set_interval = avg_record.min_frequency;	
			ELSE
				set_interval = interval '1 day';
			END IF; 
			
			expcount = pepoch / EXTRACT(EPOCH FROM set_interval) ;
			
			FOR info_record IN
			EXECUTE 'SELECT * FROM element_data_points WHERE mpid=$1 AND vargroup !=$2 AND vargroup !=$3;'	
			USING avg_record.point_id, 'design', 'setpoint'
			LOOP					

				t = fn_resolve_topic(networkref||'/'||noderef||'/'||avg_record.device||'/'||info_record.vargroup||'/'||info_record.varkey);
				networkref2 = TRIM(SPLIT_PART(t, '/', 1));
				noderef2 = TRIM(SPLIT_PART(t, '/', 2));
				deviceref2 = TRIM(SPLIT_PART(t, '/', 3));
				vargroupref2 = TRIM(SPLIT_PART(t, '/', 4));
				varkeyref2 = TRIM(SPLIT_PART(t, '/', 5));

				networknode = fn_n_n(networkref2, noderef2);
	
				FOR r_record IN
				EXECUTE 'WITH t1 AS (SELECT device,vargroup,varkey,time_bucket($6, time) AS timestamp, COUNT(value) AS value FROM '
					|| quote_ident(networknode)
					|| ' WHERE device=$1 AND vargroup=$2 AND varkey=$3 AND time>=$4 AND time<$5
						GROUP BY device,vargroup,varkey,timestamp
						ORDER BY timestamp)
						SELECT COUNT(value) AS cnt FROM t1;'
				USING deviceref2, vargroupref2, varkeyref2, dstime, detime, set_interval
				LOOP	
					rcount = rcount + r_record.cnt;					
				END LOOP;
				
				mpdcount = mpdcount + expcount;

				IF kpi_id = 3 THEN

					vmin = 0.0;
					IF info_record.units LIKE 'm%h%' THEN
						vmax = 100.0;
					ELSEIF info_record.units LIKE 'm%' THEN
						vmax = 10000.0;
					ELSEIF LOWER(info_record.units) LIKE '%c' THEN
						vmax = 200.0;
					ELSEIF LOWER(info_record.units) = 'kwh' THEN
						vmax = 55000.0;
					ELSEIF LOWER(info_record.units) = 'kw' THEN
						vmax = 1000.0;
					ELSEIF LOWER(info_record.units) = 'kpa' THEN
						vmax = 2000.0;
					ELSEIF LOWER(info_record.units) = 'bar' THEN
						vmax = 20.0;
					END IF;

					FOR r_record2 IN
					EXECUTE 'WITH t1 AS (SELECT device,vargroup,varkey,time_bucket($6, time) AS timestamp, COUNT(value) AS value FROM '
						|| quote_ident(networknode)
						|| ' WHERE device=$1 AND vargroup=$2 AND varkey=$3 AND time>=$4 AND time<$5
							AND (value::numeric > $7) AND (value::numeric <= $8)
							GROUP BY device,vargroup,varkey,timestamp
							ORDER BY timestamp)
							SELECT COUNT(value) AS cnt FROM t1;'
					USING deviceref2, vargroupref2, varkeyref2, dstime, detime, set_interval, vmin, vmax
					LOOP	
						okcount = okcount + r_record2.cnt;						
					END LOOP;					
				END IF; 				
			END LOOP;	
	END LOOP;

	IF rcount > 0 THEN
		vout = 100.0;	
		
		IF kpi_id = 3 THEN
			vout = 100.0 * okcount / rcount;		
		END IF;		
	END IF;

	IF kpi_id < 3 THEN		
		IF mpdcount > 0 THEN
			vout = 100.0 * rcount / mpdcount;	
		END IF;		
	END IF; 	
	vout = ROUND(vout::numeric, 2);

	RETURN vout;	
    
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

CREATE OR REPLACE FUNCTION fn_element_losses(etopic text, topic text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vin numeric := 0;
	vout numeric := 0;
	child_v numeric := 0;
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
		
	
	lv = (CHAR_LENGTH(etopic) - CHAR_LENGTH(REPLACE(etopic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;

	networkref = TRIM(SPLIT_PART(etopic, '/', 1));
	noderef = TRIM(SPLIT_PART(etopic, '/', 2));
	deviceref = TRIM(SPLIT_PART(etopic, '/', 3));
	
	vargroupref = TRIM(SPLIT_PART(topic, '/', 1));
	varkeyref = TRIM(SPLIT_PART(topic, '/', 2));
	
	vin = fn_delta(networkref || ' / ' || noderef || ' / ' || deviceref || ' / ' || vargroupref || ' / ' || varkeyref, stime, etime);

	FOR avg_record IN
	   	EXECUTE 'SELECT network,node,device FROM readings WHERE varkey = $1 AND (value = $2 OR value = $3)'	
   		USING 'parentElement', noderef || '/' || deviceref, noderef || ' / ' || deviceref
	LOOP		
		child_v = fn_delta(avg_record.network || ' / ' || avg_record.node || ' / ' || avg_record.device || ' / ' || vargroupref || ' / ' || varkeyref, stime, etime);
		vout = vout + child_v;
		
    END LOOP;

    RETURN ROUND(vin - vout, 1);	

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_element_h_total(etopic text, topic text, stime timestamp, etime timestamp)
RETURNS numeric
AS $$
DECLARE
	vin numeric := 0;
	vout numeric := 0;
	child_v numeric := 0;
	t TEXT := '';
	lv NUMERIC := 0;
	avg_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
BEGIN
		
	
	lv = (CHAR_LENGTH(etopic) - CHAR_LENGTH(REPLACE(etopic, '/', ''))) / CHAR_LENGTH('/');

	IF (lv<4) THEN
		return null;
	END IF;

	networkref = TRIM(SPLIT_PART(etopic, '/', 1));
	noderef = TRIM(SPLIT_PART(etopic, '/', 2));
	deviceref = TRIM(SPLIT_PART(etopic, '/', 3));
	
	vargroupref = TRIM(SPLIT_PART(topic, '/', 1));
	varkeyref = TRIM(SPLIT_PART(topic, '/', 2));
	
	--vin = fn_delta(networkref || ' / ' || noderef || ' / ' || deviceref || ' / ' || vargroupref || ' / ' || varkeyref, stime, etime);

	FOR avg_record IN
	   	EXECUTE 'SELECT network,node,device FROM readings WHERE network=$1 AND node=$2 AND varkey = $3 AND value = $4'	
   		USING networkref, noderef, 'elementType', 'EC-HG'
	LOOP		
		child_v = fn_delta(avg_record.network || ' / ' || avg_record.node || ' / ' || avg_record.device || ' / ' || vargroupref || ' / ' || varkeyref, stime, etime);
		vout = vout + child_v;
		
    END LOOP;

    RETURN ROUND(vout, 1);	

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_element_interruptions(ttopic text, tlow numeric, dptopic text, dplow numeric, stime timestamp with time zone, etime timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	vout FLOAT := 0.0;
	
BEGIN
	
	vout = fn_element_interruptions(ttopic, tlow::text, dptopic, dplow::text, stime, etime);
	RETURN vout;	
    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_element_interruptions(ttopic text, tlow text, dptopic text, dplow text, stime timestamp with time zone, etime timestamp with time zone)
RETURNS FLOAT AS $$
DECLARE
	v TEXT := '';
	vout FLOAT := 0.0;
	r_record RECORD;
	networkref varchar;
	noderef varchar;
	deviceref varchar;
	vargroupref varchar;
	varkeyref varchar;
	networkref2 varchar;
	noderef2 varchar;
	deviceref2 varchar;
	vargroupref2 varchar;
	varkeyref2 varchar;
	rcount numeric := 0;
	outcount numeric := 0;
	hdowncount numeric := 0;
	dstime timestamp with time zone;
	detime timestamp with time zone;
	networknode TEXT;
	networknode2 TEXT;
	set_interval interval; 
	tmin numeric;
	dpmin numeric;
	t TEXT;
	
BEGIN

	tmin = tlow::numeric;
	dpmin = dplow::numeric;	

	dstime = DATE_TRUNC('hour', stime);
	detime = DATE_TRUNC('hour', etime) + interval '1 hour';
	
	networkref = TRIM(SPLIT_PART(ttopic, '/', 1));
	noderef = TRIM(SPLIT_PART(ttopic, '/', 2));
	deviceref = TRIM(SPLIT_PART(ttopic, '/', 3));
	vargroupref = TRIM(SPLIT_PART(ttopic, '/', 4));
	varkeyref = TRIM(SPLIT_PART(ttopic, '/', 5));
	networknode = fn_n_n(networkref, noderef);
	
	networkref2 = TRIM(SPLIT_PART(dptopic, '/', 1));
	noderef2 = TRIM(SPLIT_PART(dptopic, '/', 2));
	deviceref2 = TRIM(SPLIT_PART(dptopic, '/', 3));
	vargroupref2 = TRIM(SPLIT_PART(dptopic, '/', 4));
	varkeyref2 = TRIM(SPLIT_PART(dptopic, '/', 5));
	networknode2 = fn_n_n(networkref2, noderef2);
	
	set_interval = interval '1 hour';
	
	FOR r_record IN
	EXECUTE 'WITH t1 AS (SELECT device,vargroup,varkey,time_bucket($6, time) AS timestamp, MAX(value::numeric) AS value FROM '
		|| quote_ident(networknode)
		|| ' WHERE device=$1 AND vargroup=$2 AND varkey=$3 AND time>=$4 AND time<$5
			GROUP BY device,vargroup,varkey,timestamp
			ORDER BY timestamp),
			t2 AS (SELECT device,vargroup,varkey,time_bucket($6, time) AS timestamp, MAX(value::numeric) AS value FROM '
		|| quote_ident(networknode2)
		|| ' WHERE device=$7 AND vargroup=$8 AND varkey=$9 AND time>=$4 AND time<$5
			GROUP BY device,vargroup,varkey,timestamp
			ORDER BY timestamp)
			SELECT t1.value AS temp, t2.value AS dp, t1.timestamp FROM t1
			FULL OUTER JOIN t2 ON t1.timestamp=t2.timestamp
			ORDER BY timestamp;'
	USING deviceref, vargroupref, varkeyref, dstime, detime, set_interval, deviceref2, vargroupref2, varkeyref2
	LOOP	
		
		IF (r_record.temp > 0 AND r_record.temp < tmin) OR (r_record.dp > 0 AND r_record.dp < dpmin) THEN
			hdowncount = hdowncount + 1;	
		ELSE
			hdowncount = 0;
		END IF;

		IF (hdowncount = 13) THEN
			outcount = outcount + 1;	
		END IF;
	
		rcount = rcount + 1;
		
	END LOOP;

	vout = outcount; --ROUND(vout::numeric, 2);

	RETURN vout;
	
    
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



-- -------------------------------------------------------------


CREATE OR REPLACE FUNCTION public.fn_plot_json(
	schemain text,
	networkin text)
    RETURNS TABLE(node text, plot_json jsonb) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	vout JSONB;
	vjson JSONB;
	avg_record RECORD;
	info_record RECORD;
	info_record2 RECORD;
	d_list TEXT :='';
	cnt NUMERIC :=0;
	html_issues TEXT :='';
	nn TEXT :='';
BEGIN	

	FOR avg_record IN
	EXECUTE 'SELECT DISTINCT node, timestamp FROM ' || schemain || '.readings '
	|| ' WHERE network = $2 AND varkey=$3'
	USING schemain, networkin, 'deviceType'
	LOOP

		node = avg_record.node;
		html_issues = '';
		
		vout = '{"network":"' || networkin || '","node":"' || node || '"}';
		vout = jsonb_insert(vout, '{timestamp}', ('"'||avg_record.timestamp||'"')::jsonb);

		vjson = '{"status":"Unknown"}';
		vout = vout || vjson;

		-- plot readings
		FOR info_record IN
		EXECUTE 'SELECT * FROM ' || schemain || '.readings '
		|| ' WHERE network = $2 AND node = $3 AND device = $4 AND (varkey = $5 OR varkey = ''address'')'
		USING schemain, networkin, node, 'plot', 'status'
		LOOP
		
			vjson = '{"' ||info_record.varkey || '":"' || info_record.value || '"}';
			vout = vout || vjson;
			
		END LOOP;

		-- For each device in node
		FOR info_record IN
		EXECUTE 'SELECT * FROM ' || schemain || '.readings '
		|| ' WHERE network = $2 AND node = $3 AND (varkey = $4)'
		USING schemain, networkin, node, 'deviceType'
		LOOP
		
			vjson = '{"url' ||info_record.device || '":"' || schemain || '/' || networkin  || '/' || node  || '/' || info_record.device  || '"}';
			vout = vout || vjson;		

			vjson = '{"form_' ||info_record.device || '":"' || info_record.value  || '"}';
			vout = vout || vjson;
			
		END LOOP;

		FOR info_record IN
		EXECUTE 'SELECT * FROM ' || schemain || '.readings '
		|| ' WHERE network = $2 AND node = $3 AND varkey LIKE $4'
		USING schemain, networkin, node, 'failure%'
		LOOP
		
			vjson = '{"' ||info_record.device||'_'||info_record.varkey || '":"' || info_record.value  || '"}';
			vout = vout || vjson;

			IF (info_record.varkey='failureList') THEN
				html_issues = html_issues || info_record.device || ': ' || info_record.value || '\n '; -- '<br>\n';
			END IF;
			
		END LOOP;
				
		
		-- progress old
		FOR info_record IN
		EXECUTE 'SELECT * FROM ' || schemain || '.readings '
		|| ' WHERE network = $2 AND node = $3 AND (varkey LIKE $4) '
		USING schemain, networkin, node, 'progress%'
		LOOP
		
			vjson = '{"' || info_record.device||'_'||info_record.varkey || '_%":"' || info_record.value || '"}';
			vout = vout || vjson;
			
		END LOOP;	

		-- progress new
		FOR info_record IN
		EXECUTE 'SELECT varkey, AVG(value::numeric) AS value FROM ' || schemain || '.readings '
		|| ' WHERE network = $2 AND node = $3 AND (varkey LIKE $4) GROUP BY varkey'
		USING schemain, networkin, node, 'progress%'
		LOOP
		
			vjson = '{"' || info_record.varkey || '_%":"' || info_record.value || '"}';
			vout = vout || vjson;
			
		END LOOP;	

		-- minutes
		FOR info_record IN
		EXECUTE 'SELECT * FROM ' || schemain || '.readings '
		|| ' WHERE network = $2 AND node = $3 AND (varkey LIKE $4) '
		USING schemain, networkin, node, 'minutes%'
		LOOP
		
			--vjson = '{"' || info_record.device||'_'||info_record.varkey || '":"' || info_record.value || '"}';
			
			vjson = '{"' || info_record.device||'_'||info_record.varkey || '":"' || info_record.value || '"}';
			vout = vout || vjson;
			
		END LOOP;	

		-- sharepoint
		cnt=0;
		FOR info_record IN
		EXECUTE 'SELECT * FROM ' || schemain || '.readings '
		|| ' WHERE network = $2 AND node = $3 AND vargroup = $4 '
		USING schemain, networkin, node, 'sharepoint'
		LOOP
			cnt = cnt + 1;
			vjson = '{"sharepoint_'|| cnt || '":"' || info_record.value  || '"}';
			vout = vout || vjson;
			vjson = '{"filename_'|| cnt || '":"' || info_record.varkey  || '"}';
			vout = vout || vjson;
			
		END LOOP;	

	

		nn = fn_n_n(networkin, node);
		cnt=0;
		FOR info_record IN
		EXECUTE 'SELECT EXISTS ( '
		|| ' SELECT FROM information_schema.tables '
		|| ' WHERE table_schema = $1 AND table_name = $2);'
		USING schemain, nn
		LOOP
			IF info_record.exists=true THEN 
				cnt=1;
			END IF;
		END LOOP;	
		
		   
		IF (cnt=1) THEN
		
			nn = fn_n_n(networkin, node);
			FOR info_record IN
			EXECUTE 'SELECT * FROM ' || schemain || '.' || nn
			|| ' WHERE varkey = $4 AND value!= $5 ORDER BY time DESC LIMIT 1'
			USING schemain, networkin, node, 'engineerName', 'Richard Hanson-Graville'
			LOOP
				vjson = '{"engineerName":"' || info_record.value  || '"}';
				vout = vout || vjson;
				
			END LOOP;	
		END IF;

		

		vjson = '{"issues":"' || html_issues || '"}';
		vout = vout || vjson;

		plot_json = vout;
		RETURN NEXT;
	
	END LOOP;

	
	
END;
$BODY$;
























