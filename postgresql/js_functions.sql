
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
