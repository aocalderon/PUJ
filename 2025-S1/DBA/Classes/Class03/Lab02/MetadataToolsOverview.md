# Metadata Tools Overview

If you're specifically interested in **database-oriented metadata tools**, here are both **open-source** and **commercial** solutions that focus on **metadata management, cataloging, lineage, and governance** for relational and NoSQL databases.

---

## **Open-Source Database-Oriented Metadata Tools**

1. **Apache Atlas**  
   - Designed for big data environments but also supports relational databases.  
   - Provides metadata management, data lineage, and governance.  
   - Works well with **Hive, HBase, and relational databases**.

2. **Amundsen**  
   - Developed by Lyft, it focuses on **metadata discovery** and **search**.  
   - Supports databases such as **PostgreSQL, MySQL, Redshift, and BigQuery**.  
   - Uses **Elasticsearch and Neo4j** for metadata storage.

3. **DataHub**  
   - Originally developed by LinkedIn, it supports **real-time metadata management**.  
   - Works with **PostgreSQL, MySQL, Snowflake, Redshift, BigQuery, and MongoDB**.  
   - Strong support for database lineage and governance.

4. **Egeria**  
   - Open-source metadata and governance platform.  
   - Supports relational databases like **PostgreSQL, Oracle, MySQL, and SQL Server**.  
   - Provides **metadata APIs and connectors**.

5. **OpenMetadata**  
   - Specifically designed for **metadata management in databases**.  
   - Supports **MySQL, PostgreSQL, Snowflake, Redshift, and Databricks**.  
   - Provides database schema discovery, profiling, and lineage tracking.

6. **Metacat (Netflix)**  
   - Metadata management for **Hive, RDS, Redshift, and MySQL**.  
   - Helps unify metadata across different storage and database systems.  
   - Designed for large-scale data environments.

7. **dcat (Data Catalog Tool)**  
   - Lightweight metadata catalog for relational databases.  
   - Works with **PostgreSQL, MySQL, and SQLite**.  
   - Simple and minimalistic compared to enterprise-grade solutions.

---

## **Commercial Database-Oriented Metadata Tools**

1. **Alation**  
   - One of the most widely used metadata management tools for relational databases.  
   - Supports **Oracle, SQL Server, MySQL, PostgreSQL, Snowflake, and Redshift**.  
   - AI-powered search and collaboration.

2. **Collibra Data Catalog**  
   - Enterprise-level metadata governance solution.  
   - Supports **SQL Server, Oracle, PostgreSQL, MySQL, Teradata, and Snowflake**.  
   - Provides **data lineage, access control, and policy management**.

3. **Informatica Enterprise Data Catalog**  
   - Metadata management with **AI-powered discovery**.  
   - Supports **relational databases, NoSQL, and cloud data warehouses**.  
   - Deep metadata scanning for **Oracle, SQL Server, MySQL, and PostgreSQL**.

4. **Talend Data Catalog**  
   - Automates metadata harvesting and lineage tracking.  
   - Works with **Snowflake, SQL Server, MySQL, PostgreSQL, and Redshift**.  
   - Focuses on **metadata compliance and governance**.

5. **IBM Watson Knowledge Catalog**  
   - AI-powered metadata catalog for database governance.  
   - Supports **IBM Db2, SQL Server, Oracle, and PostgreSQL**.  
   - Provides **lineage tracking and security compliance**.

6. **AWS Glue Data Catalog**  
   - Native AWS metadata management for databases.  
   - Works with **Amazon RDS, Aurora, Redshift, and DynamoDB**.  
   - Supports **schema evolution and data discovery**.

7. **Google Data Catalog (Dataplex)**  
   - Designed for **Google Cloud SQL, BigQuery, and other databases**.  
   - Provides **automatic metadata discovery and search**.  
   - Integrates with Google Cloud services.

8. **Microsoft Purview**  
   - Azure’s metadata and data governance tool.  
   - Works with **SQL Server, Azure Synapse, MySQL, PostgreSQL, and Oracle**.  
   - Provides **end-to-end lineage tracking**.

9. **Atlan**  
   - A modern data workspace that integrates with **PostgreSQL, MySQL, Snowflake, and Redshift**.  
   - Provides **metadata enrichment and governance features**.  
   - Focuses on **collaboration for database metadata**.

---

### **Choosing the Right Metadata Tool for Databases**
- **For Open-Source & Scalability** → *Apache Atlas, DataHub, OpenMetadata, Amundsen*  
- **For Relational Databases** → *Alation, Collibra, Informatica, AWS Glue, Microsoft Purview*  
- **For Cloud Databases** → *AWS Glue, Google Data Catalog, Microsoft Purview, Atlan*  
- **For NoSQL & Hybrid Use Cases** → *Metacat, OpenMetadata, Talend Data Catalog*  