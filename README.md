# HNQAP
Heat Network Quality Assurance Publications

This project contains documents, tools and data used in quality assurance procedures relating to heat networks and zero-carbon building services technologies.

As well as guidance documents, the project provides JSON and SQL data that describe objects, fields and procedures. 

HTML browserware is provided to allow procedures to be followed and recorded using a web browser on any device.    

PostgreSQL functions are provided to setup a standardised database structure, and to enable KPI functions to be run on heat network data.  These can be pasted and run on a fresh database to fully implement HNQAP in one step.

Quality assurance procedures are grouped by objects (object oriented), by which a set of procedures apply to a specific item in a heat network, often with a heat or water meter at entry and/or exit.  The object list is as follows.

* Network (top level object)
* Boilers
* Heat Pumps
* Buffer Storage
* Hydraulic Circuit (Primary or Secondary)
* Circulation Pump Sets
* Communal DHW Supply / Circuit
* Substation
* Property
* HIU
* BMS System 
* AMR System
* Compliance System
  
It is the aim to avoid duplication of KPIs between objects.  In this way, objects can be assembled, and a complete list of indexed KPIs obtained.

The HNQAP project builds on three key open-source technologies:

* MQTT for transporting data between devices and to subscribers
* PostgreSQL databases for storing data, including time-series data (using timescaleDB plugin), and for defining stastistical functions on data
* Grafana for visualising data and generating alarms

In addition, Node-RED or Python is used to ingest data into databases, from MQTT into PostgreSQL, and JavaScript is used for software tools (browserware).

As such, all HNQAP functions can be replicated without barriers, licences or copyright, and where needed run using freemium services.

Through the use of MQTT, HNQAP is designed to be fully compatible with existing B(E)MS systems, and is layered on top of existing hardware without a need for any additional hardware or software licences.

HNQAP builds on existing technical guidance and QA for heat networks and related systems, including CIPHE Building Engineering Services Design Guide, CIBSE CP1 Codes of Practice, SAP10, EMBED, MMSP, HNTAS Heat Network Technical Assurance Scheme, and MEHNA/BESA Training Modules.
  
## Design, Installation & Optimisation

Quality control (for each object) is divided into three catagories:

* System design
* Installation and acceptance testing of systems
* Optimisation of operational systems


### System Design

System design is handled through the use of standard design details (schematics) for objects.  These details are drawn from CP1 standards as well as industry standards for equipment such as HIUs.

A database of standard details will be maintained in this project.

Design details include references for acceptance testing procedures and operational KPIs.

### Acceptance Testing

The quality of installations is maintained through the use of standard processes, driven through logic-driven forms and operational KPIs.

* [HIU Acceptance Test](https://heatweb.b-cdn.net/browserware/hwforms12.html?loadCID=bafkreih5nm75fu7c6envjjnrlxjjyau4fpd34gdqdc3zr572vs2bo4w5eq)
  

### Operational KPIs

![image](https://github.com/heatweb/HNQAP/assets/7034068/70228675-7ffe-4fab-bc68-9c11c51434b5)


