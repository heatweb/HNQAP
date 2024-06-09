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


SELECT * FROM fn_get_values('eon_fulhamrs1','3016031af27a0c25','dat','tHoDHW')


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

SELECT * FROM fn_average('eon_fulhamrs1','3016031af27a0c25','dat','tHoDHW')



