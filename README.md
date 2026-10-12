<div align="center">

# 🚀 Data Warehouse Project
### End-to-End Data Engineering

**From raw operational data to trusted, analytics-ready insights.**

<p>
  <img src="https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white" alt="SQL Server" />
  <img src="https://img.shields.io/badge/Medallion%20Architecture-Bronze%20%7C%20Silver%20%7C%20Gold-CD7F32?style=for-the-badge" alt="Medallion Architecture" />
  <img src="https://img.shields.io/badge/Data%20Engineering-ETL%20%7C%20Modeling-2563EB?style=for-the-badge" alt="Data Engineering" />
</p>

</div>

---

## 👋 Welcome to the Project

This repository showcases the **end-to-end development of a modern data warehouse**, transforming raw data from **ERP** and **CRM** source systems into clean, integrated, and analytics-ready datasets.

Built with **SQL Server** and the **Medallion Architecture** 🥉🥈🥇, this project explores industry-relevant data engineering practices—from **ETL pipeline development** and **data quality management** to **data integration** and **dimensional modeling**.

🎯 **The goal:** turn fragmented operational data into a reliable foundation for analytical reporting and data-driven business decisions.

---

<div align="center">


<div align="center">

# 🏗️ Data Architecture

### From Raw Source Files to Analytics-Ready Data

*An end-to-end warehouse architecture built around the Medallion pattern.*

</div>

---

## 🔎 Architecture Overview

The solution follows the **Medallion Architecture** to progressively refine data from source files into trusted, business-ready datasets. Data from **ERP** and **CRM** CSV files is ingested into SQL Server, processed through three logical layers, and prepared for analytical reporting.

<div align="center">

<!-- Upload your architecture diagram to the repository (for example, docs/architecture.png)
     and update the path below if your filename or folder differs. -->
<img src="docs/Architecture_Diagram (2).png" alt="High-level data warehouse architecture showing ERP and CRM sources flowing through Bronze, Silver, and Gold layers." width="100%" />

<sub><b>Figure 1.</b> High-level data flow across the Bronze, Silver, and Gold layers.</sub>

</div>

## 🥉 Bronze Layer — Raw Data

> **Purpose:** Preserve source data as received.

- Ingest raw CSV files from the ERP and CRM source systems into SQL Server.
- Store source records in raw tables before applying business transformations.
- Keep ingestion logic separate from cleansing and modeling logic.

## 🥈 Silver Layer — Cleaned & Standardized Data

> **Purpose:** Improve data quality and consistency.

- Cleanse and standardize data types, formats, and values.
- Address data quality issues such as missing values and duplicate records where applicable.
- Normalize and integrate related data from ERP and CRM.
- Prepare consistent datasets for downstream modeling.

## 🥇 Gold Layer — Business-Ready Data

> **Purpose:** Make data easy to query for analytics.

- Model integrated data into **fact and dimension tables** using a star schema.
- Apply business rules and prepare relevant measures and descriptive attributes.
- Support analytical SQL queries, reporting, and business insights.

## 🔄 End-to-End Data Flow

<div align="center">

**📁 ERP & CRM CSV Files**  
⬇️  
**🥉 Bronze · Raw Ingestion**  
⬇️  
**🥈 Silver · Cleansing, Standardization & Integration**  
⬇️  
**🥇 Gold · Dimensional Modeling & Business Logic**  
⬇️  
**📊 SQL Analytics & Reporting**

</div>

---

<sub>🛠️ **Core platform:** SQL Server Express · SQL Server Management Studio (SSMS) · SQL</sub>

### 🧱 Raw Data → 🔄 Transformation → 📊 Business Insights

*Building a stronger foundation in modern data engineering, one layer at a time.*

</div>
