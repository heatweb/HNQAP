# HNQAP
Heat Network Quality Assurance Publications

This project contains documents, tools and data used in quality assurance procedures relating to heat networks and zero-carbon building services technologies.

As well as guidance documents, the project provides open-source JSON data files that describe procedures and records outcomes. A calculations engine and conditional branching are built into the data structure to allow complex conditional procedures to be followed and recorded.    

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

In addition, Node-RED or Python is used to ingest data into databases, from MQTT into PostgreSQL.

As such, all HNQAP functions can be replicated without barriers, licences or copyright, and where needed run using freemium services.

Through the use of MQTT, HNQAP is designed to be fully compatible with existing B(E)MS systems, and is layered on top of existing hardware without a need for any additional licences.

HNQAP is authored by individuals who have contributed directly to existing technical guidance for heat networks and related systems, including CIPHE Building Engineering Services Design Guide, CIBSE CP1 Codes of Practice, SAP10, HNTAS Heat Network Technical Assurance Scheme, and MEHNA/BESA Training Modules.
  
## Design, Installation & Optimisation

Quality control (for each object) is divided into three catagories:

* System design
* Installation and acceptance testing of systems
* Optimisation of operational systems

### System Design

System design is handled through the use of standard design details (schematics) for objects.  These details are drawn from CP1 standards as well as industry standards for equipment such as HIUs.

A database of standard details is maintained in this project.

Design details include references for acceptance testing procedures and operational KPIs.

### Acceptance Testing

The quality of installations is maintained through the use of standard processes, driven through logic-driven forms and operational KPIs.

* [HIU Acceptance Test](https://heatweb.b-cdn.net/browserware/hwforms5.html?loadCID=bafkreibb3h2appcsvztmvfz4eiybfudqlf3bfaobrsjcly63pp6i5vgygi)
  
![qa-hiu-acceptance](https://github.com/heatweb/HNQAP/assets/7034068/532226b9-1e73-4eb1-b0bd-0a37d4f339c8)


### Operational KPIs

![image](https://github.com/heatweb/HNQAP/assets/7034068/70228675-7ffe-4fab-bc68-9c11c51434b5)


