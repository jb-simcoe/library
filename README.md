# Local Library Analytics
## 1 Logical Data Model
### Model

An initial LDM as been derived:

![LDM of library management system](/docs/images/library_ldm.svg)

Some aspects and processes need to be clarified with the business:

- Do we offer articles other than books? (generic article entity required)
- Could a book belong to multiple genres, subgenres and are there hierarchical structures? (assignment table)
- Does each genre have a designated section in the library or are there multiple sections (section or shelf entity required as well assignment table)
- Importance of authors needs to be clarified (Multiple Authors, roles, assignment table)
- Could a book be picked up at one location and returned at another?
- Could a member extend a rent?

## 2 ETL/ELT Concept
### Architecture and components

A simple DWH architecture has been derived from the case. It is assumed that both libraries share one source system and therefore, no integration is required. The architecture could be set up quickly and scales in terms of pricing as well as analytical capabilities.

![Library ELT Architecture](/docs/images/library_architecture.svg)

### Extraction + Loading

The source data is extracted table by table, without any transformation (1:1 extraction) and stored in a file storage. The following advantages are associated with this approach:

- simple extraction jobs, no heavy queries on the source system 
- no proprietary etl tool required (the proposed python/meltano solutions are open source) 
- simple error analysis, no hidden transformation logic, tables could be compared with the source directly (fault tolerance)
- file storage with a general format (e.g. singer) is system agnostic and could be ingested into a simple db as well as an analytical db later on
-  the snapshots of the source data allow for quick recovery and remodeling of the dwh is always an option

### Transformation

After the data has been extraced from the source and has been stored in the file storage, it is loaded into the db's stage layer. Again loading is performed using 1:1 copies of the source data.

Necessary transformations of the data in order to calculate the proposed kpi and other future cases occur in the db only using open source tool dbt. Using dbt offers the following advantages:

- open source
- focus on select statements and the logic, storing, historizing and incremental loading of the data can be automated easily
- dependencies between objects are recognized automatically by dbt, therefore no complex etl pipelines or scheduling/orchestration solutions are required (simple shell scripts are proposed as an initial solution, open source solution airflow could be used later on)
- code can easily be put into version control
- quick setup
- testing can be implemented easily

After the copied data from the source has been prepared in the stage layer, generic models are built in the core layer of the dwh. The generic models from the core layer are then used in the mart layer to provide simplified models for specific cases, e.g. the required active customer kpi.

Transformation of the data could look like the following, though clarification of requirements and possible scenarios for the future might lead to a different approach:

![Transformation DAG](/docs/images/library_dag.png)

See `/models` for details.

