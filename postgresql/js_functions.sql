
CREATE OR REPLACE FUNCTION fn_js_node_q(schemain text, networkin text, nodein text)
RETURNS table
(
	network TEXT,
	node TEXT,
	node_json JSONB
)
AS $$

	var q = "SELECT * FROM "+schemain+".readings WHERE network='" + networkin + "'";
	q += " AND node='" + nodein + "' AND varkey='deviceType'";
  	var json_result = plv8.execute(q);

	for (var r in json_result) {

		var deviceType = json_result[r].value;

		
		q = "SELECT * FROM qforms WHERE POSITION('" + deviceType + "' IN devicetypes)>0";
		q += " OR devicetypes='*' AND condition='true' ORDER BY " + '"order" ASC';
	  	var q_result = plv8.execute(q);

	  	for (var qr in q_result) {

			var jsonr = q_result[qr].qjson;
			jsonr.device = jsonr.device || json_result[r].device;			
			jsonr.vargroup = jsonr.vargroup || json_result[r].vargroup;	
		  
			var obj = q_result.if;   // -- "'testing'.substring(0,2)";
			// -- var oot = Function('"use strict";return (' + obj + ')')();
			var oot = true;
			if (oot) {  
				plv8.return_next( {"network": networkin, "node": nodein, "node_json": jsonr } );
			}
		}
	}
	
	
  
$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION fn_js_dev_q(schemain text, networkin text, nodein text)
RETURNS table
(
	network TEXT,
	node TEXT,
	device TEXT,
	node_json JSONB
)
AS $$

	var q = "SELECT * FROM "+schemain+".readings WHERE network='" + networkin + "'";
	q += " AND node='" + nodein + "' AND varkey='deviceType'";
  	var json_result = plv8.execute(q);

	for (var r in json_result) {

		var deviceType = json_result[r].value;
		var d = json_result[r].device;
		
		q = "SELECT * FROM "+schemain+".readings WHERE network='" + networkin + "'";
		q += " AND node='" + nodein + "' AND device='" + d + "'";
	  	var d_result = plv8.execute(q);
		var d_json = {};
		for (var dr in d_result) {
			if (d_result[dr].value) { d_json[d_result[dr].varkey] = d_result[dr].value; }
		}
		
		q = "SELECT * FROM qforms WHERE POSITION('" + deviceType + "' IN devicetypes)>0";
		q += " OR devicetypes='*' AND condition='true' ORDER BY " + '"order" ASC';
	  	var q_result = plv8.execute(q);

	  	for (var qr in q_result) {

			var jsonr = q_result[qr].qjson;
			jsonr.id = q_result[qr].varkey;	
			jsonr.device = jsonr.device || d;			
			jsonr.vargroup = jsonr.vargroup || q_result[qr].vargroup;	

			if (d_json[jsonr.id]) { jsonr.value = d_json[jsonr.id] }
			
			
			var ifparts = (jsonr.if||"").split("{{");
			var myif = jsonr.if;
			if (ifparts.length>1) {
				myif = "" + ifparts[0];
				for (var ifp in ifparts) {
					var remaining = ifparts[ifp].split("}}")[1] || "";
					var mykey = ifparts[ifp].split("}}")[0];
					var myv = "";
					if (d_json[mykey]) { myv = d_json[mykey]; }
					myif += myv + remaining;
				}
		  	}
			  
			// -- var obj = q_result.if;   // -- "'testing'.substring(0,2)";
			var oot = Function('"use strict";return (' + myif + ')')();
			// -- var oot = true;
			if (oot) {  
				plv8.return_next( {"network": myif, "node": nodein, "device": d, "node_json": jsonr } );
			}
		}
	}
	
	
  
$$ LANGUAGE plv8 IMMUTABLE STRICT;



CREATE OR REPLACE FUNCTION fn_js_dev_d(schemain text, networkin text, nodein text, devicein text)
RETURNS table
(
	varkey TEXT,
	"value" TEXT,
	units TEXT
)
AS $$

	var q = "SELECT t1.varkey, t1.value, t2.units FROM "+schemain+".readings t1 ";
	q += " LEFT OUTER JOIN public.fields t2 ON t1.varkey=t2.varkey AND t1.vargroup=t2.vargroup ";
	q += " WHERE t1.node ='"+nodein+"' AND t1.device='plot' AND t1.network='" + networkin + "';";
	var qres = plv8.execute(q);

	mydata = qres;
	
	// -- for (var r in qres) {		
	// -- 	plv8.return_next( {"varkey": qres[r].varkey, "value": qres[r].value, "units": qres[r].units } );		
	// -- }
	
	q = "SELECT t1.varkey, t1.value, t2.units FROM "+schemain+".readings t1 ";
	q += " LEFT OUTER JOIN public.fields t2 ON t1.varkey=t2.varkey AND t1.vargroup=t2.vargroup ";
	q += " WHERE t1.node ='"+nodein+"' AND t1.device='"+devicein+"' AND t1.network='" + networkin + "';";
	var qres = plv8.execute(q);
	mydata = mydata.concat(qres);

	q = "SELECT (t1.vargroup||'_'||t1.varkey) AS varkey, t1.value, t2.units FROM "+schemain+".readings t1 ";
	q += " LEFT OUTER JOIN public.fields t2 ON t1.varkey=t2.varkey AND t1.vargroup=t2.vargroup ";
	q += " WHERE t1.node ='"+nodein+"' AND t1.network='" + networkin + "';";
	var qres = plv8.execute(q);
	mydata = mydata.concat(qres);

	q = "SELECT (t1.device||'_'||t1.vargroup||'_'||t1.varkey) AS varkey, t1.value, t2.units FROM "+schemain+".readings t1 ";
	q += " LEFT OUTER JOIN public.fields t2 ON t1.varkey=t2.varkey AND t1.vargroup=t2.vargroup ";
	q += " WHERE (t1.node='"+nodein+"' OR t1.node='global') AND t1.network='" + networkin + "';";
	var qres = plv8.execute(q);
	mydata = mydata.concat(qres);

	q = "SELECT 'today' AS varkey, TO_CHAR(MAX(now()) :: TIMESTAMP, 'dd/mm/yyyy') AS value, '' AS units;";
	var qres = plv8.execute(q);
	mydata = mydata.concat(qres);

	q = "SELECT 'today' AS varkey, TO_CHAR(MAX(now()) :: TIMESTAMP, 'dd/mm/yyyy') AS value, '' AS units;";
	var qres = plv8.execute(q);
	mydata = mydata.concat(qres);

	q = "SELECT 'date' AS varkey, TO_CHAR(timestamp :: TIMESTAMP, 'dd/mm/yyyy') AS value, '' AS units FROM "+schemain+".readings t1 ";
	q += " WHERE t1.node ='"+nodein+"' AND t1.device='"+devicein+"' AND t1.network='" + networkin + "' ORDER BY timestamp DESC LIMIT 1;";
	var qres = plv8.execute(q);
	mydata = mydata.concat(qres);

	if (devicein=='mvhr') {
		q = "SELECT * FROM fn_get_table_values('"+schemain+"','" + networkin + "','"+nodein+"','mvhr','acceptance','extractAir')";
		var qres = plv8.execute(q);
		mydata = mydata.concat(qres);
		
		q = "SELECT * FROM fn_get_table_values('"+schemain+"','" + networkin + "','"+nodein+"','mvhr','acceptance','supplyAir')";
		var qres = plv8.execute(q);
		mydata = mydata.concat(qres);
	}

	q = "SELECT 'photo_'||varkey AS varkey, image AS value, '' AS units FROM "+schemain+".imagedata t1 ";
	q += " WHERE t1.node ='"+nodein+"' AND (t1.device='"+devicein+"' OR t1.device='plot') AND t1.network='" + networkin + "';";
	var qres = plv8.execute(q);
	mydata = mydata.concat(qres);
	

	for (var r in mydata) {		
		plv8.return_next( {"varkey": mydata[r].varkey, "value": mydata[r].value, "units": mydata[r].units } );		
	}
	
  
$$ LANGUAGE plv8 IMMUTABLE STRICT;


-- ---------------------------------------------------------------


CREATE OR REPLACE FUNCTION public.fn_js_minutes(
	schemain text,
	networkin text,
	vargroupin text,
	time1 timestamp with time zone,
	time2 timestamp with time zone)
    RETURNS TABLE(network text, node text, device text, d_json jsonb) 
    LANGUAGE 'plv8'
    COST 100
    IMMUTABLE STRICT PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	var q = "SELECT * FROM "+schemain+".readings WHERE network='" + networkin + "'";
	q += " AND vargroup='" + vargroupin + "' AND varkey = 'minutesProgress' ORDER BY network,node,device";
  	var json_result = plv8.execute(q);

	 

	for (var r in json_result) {

		var d = json_result[r].device;
		var nodein = json_result[r].node;
		var varkeyin = json_result[r].varkey;
		var d_json = {};

		
		d_json[json_result[r].varkey] = json_result[r].value;

		var nn = (networkin + "_" + nodein).replaceAll("-","_").toLowerCase();

		var datestr1 = new Date(time1).toISOString();
		var datestr2 = new Date(time2).toISOString();
		
		var d_result;
		
		q = "SELECT * FROM "+schemain+"." + nn + " WHERE device='" + d + "'";
		q += " AND vargroup='" + vargroupin + "' AND varkey='" + varkeyin + "'";
		q += " AND time<='" + datestr1 + "'::timestamp ";		
		q += " ORDER BY time DESC LIMIT 1";				
	  	try {  d_result = plv8.execute(q);   
		  
		  	// -- d_json.q = q;		
			if (d_result && d_result[0] && d_result[0].value) { d_json["minutesStart"] = parseFloat(d_result[0].value); }
			else  { d_json["minutesStart"] = 0; }
			
		  } catch {  d_json["minutesStart"] = 0; }		
		

		q = "SELECT * FROM "+schemain+"." + nn + " WHERE device='" + d + "'";
		q += " AND vargroup='" + vargroupin + "' AND varkey='" + varkeyin + "'";
		q += " AND time<='" + datestr2 + "'::timestamp ORDER BY time DESC LIMIT 1";				
	  	try {  d_result = plv8.execute(q);   
		  
		  	if (d_result && d_result[0] && d_result[0].value) { d_json["minutesEnd"] = parseFloat(d_result[0].value); }
			else  { d_json["minutesEnd"] = d_json["minutesStart"]; }
			
		  } catch { d_json["minutesEnd"] = d_json["minutesStart"]; }

		 d_json["minutesChange"] = d_json["minutesEnd"] - d_json["minutesStart"];

		
		
		plv8.return_next( {"network": networkin, "node": nodein, "device": d,"d_json": d_json } );
	}
	  
$BODY$;



CREATE OR REPLACE FUNCTION public.fn_js_element_pc_operational(
    topic text,
    stime timestamptz,
    etime timestamptz
)
RETURNS double precision
LANGUAGE plv8
VOLATILE
PARALLEL UNSAFE
AS $$


function intervalToSeconds(interval) {
  return plv8.execute(
    `SELECT EXTRACT(EPOCH FROM $1::interval) AS sec`,
    [interval]
  )[0].sec;
}


/* -----------------------------
   Variable declarations
----------------------------- */
let vout = 0.0;

let rcount = 0;
let okcount = 0;
let expcount = 0;
let mpdcount = 0;

let vmin = 0;
let vmax = 55000;

/* -----------------------------
   Time calculations
----------------------------- */
let dstime = new Date(stime);
dstime.setUTCHours(0,0,0,0);

let detime = new Date(etime);
detime.setUTCHours(0,0,0,0);
detime.setUTCDate(detime.getUTCDate() + 1);

let pepoch = (detime - dstime) / 1000;

/* -----------------------------
   Topic parsing
----------------------------- */
let parts = topic.split('/');
let networkref = parts[0]?.trim();
let noderef    = parts[1]?.trim();
let deviceref  = parts[2]?.trim();
let varkeyref  = 'elementType';

/* -----------------------------
   avg_record loop
----------------------------- */
var q = "WITH t1 AS (SELECT r.network, r.node, r.device, p.element_type, p.point_id, p.min_frequency, p.title AS monitoring_point FROM readings r ";
q+= "INNER JOIN element_monitoring_points p ON r.value = p.element_type WHERE varkey = '" + varkeyref + "' AND network = '" + networkref + "' AND node = '" + noderef + "') ";
q+= "SELECT * FROM t1 ORDER BY network, node, device, element_type, point_id";

let avgRecords = plv8.execute(q);

for (let avg of avgRecords) {
    let setInterval = avg.min_frequency;
	expcount = pepoch / intervalToSeconds(avg.min_frequency);

	
    /* -----------------------------
       info_record loop
    ----------------------------- */
    let infoRecords = plv8.execute(
      `SELECT *
       FROM element_data_points
       WHERE mpid = $1
         AND vargroup != $2
         AND vargroup != $3`,
      [avg.point_id, 'design', 'setpoint']
    );

	var slotsok = {};
	var columncount = 0;
	// --rcount += expcount;
	
	
    for (let info of infoRecords) {

        /* Resolve topic */
        let t = plv8.execute(
          `SELECT fn_resolve_topic($1) AS t`,
          [`${networkref}/${noderef}/${avg.device}/${info.vargroup}/${info.varkey}`]
        )[0].t;

        let tp = t.split('/');
        let networkref2 = tp[0]?.trim();
        let noderef2    = tp[1]?.trim();
        let deviceref2  = tp[2]?.trim();
        let vargroupref2= tp[3]?.trim();
        let varkeyref2  = tp[4]?.trim();

        let networknode = plv8.execute(
          `SELECT fn_n_n($1,$2) AS n`,
          [networkref2, noderef2]
        )[0].n;

		columncount++;
		
        /* -----------------------------
           Total record count
        ----------------------------- */
        if (columncount==1) {
			
			let rRes = plv8.execute(
	        `WITH t1 AS (
	           SELECT time_bucket($6, time) AS ts,
	                  COUNT(value) AS value
	           FROM ${networknode}
	           WHERE device = $1
	             AND vargroup = $2
	             AND varkey = $3
	             AND time >= $4
	             AND time <= $5
	           GROUP BY ts
	        )
	        SELECT COUNT(value) AS cnt FROM t1`,
	        [deviceref2, vargroupref2, varkeyref2, dstime, detime, setInterval]
	        );
	
	        rcount += Number(rRes[0]?.cnt || 0);
	        // -- mpdcount += expcount;
		}
		
        /* -----------------------------
           vmax logic
        ----------------------------- */
        vmin = 0;
        let units = (info.units || '').toLowerCase();

        if (units.startsWith('m') && units.includes('h')) {
            vmax = 100.0;
        } else if (units.startsWith('m')) {
            vmax = 1000 * 10000.0;
        } else if (units.endsWith('c')) {
            vmax = 200.0;
        } else if (units === 'kwh') {
            vmax = 1000 * 55000.0;
        } else if (units === 'kw') {
            vmax = 1000 * 1000.0;
        } else if (units === 'kpa') {
            vmax = 2000.0;
        } else if (units === 'bar') {
            vmax = 20.0;
        }

        /* -----------------------------
           OK record count
        ----------------------------- */
        let okRes = plv8.execute(
        `SELECT time_bucket($6, time) AS ts,
                  COUNT(value) AS value
           FROM ${networknode}
           WHERE device = $1
             AND vargroup = $2
             AND varkey = $3
             AND time >= $4
             AND time <=  $5
             AND value::numeric >= $7
             AND value::numeric <= $8
           GROUP BY ts`,
        [deviceref2, vargroupref2, varkeyref2, dstime, detime, setInterval, vmin, vmax]
        );

		var cnt = 0;
		for (let dpoint of okRes) {
			cnt++;
			slotsok[dpoint.ts] = (slotsok[dpoint.ts] ||0) +1;
		}
        
    }

	// -- var cnt = 0;
	for (var tpoint in slotsok) {
		if (slotsok[tpoint] == columncount) { okcount++;  }
		// --rcount++;
	}
	// -- okcount = okcount + cnt;
}

/* -----------------------------
   Final calculation
----------------------------- */
if (rcount > 0) {
    vout = 100.0 * okcount / rcount;
}

// -- vout = rcount ;

return Math.round(vout * 100) / 100;
$$;

