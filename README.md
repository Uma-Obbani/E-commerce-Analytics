# Analytics Engineering Case Study

## Overview

This project demonstrates an end-to-end Analytics Engineering pipeline using Python, FastAPI, BigQuery, and dbt.

The solution identifies post-purchase bank account changes by analyzing Finance UUID transitions, enriching finance identifiers through a simulated banking API, comparing previous and updated IBAN values, and generating GDPR-safe stakeholder reports.

The pipeline includes asynchronous API enrichment, dbt transformations, data quality checks, and automated country-level report distribution.

---

## Technology Stack

- Python 3.11
- FastAPI
- Google BigQuery
- dbt
- Pandas
- OpenPyXL
- Gmail SMTP
- Pre-commit

---

# Project Architecture

The workflow consists of three main layers:

## 1. Transformation Pipeline (dbt)

1. Standardize source datasets using staging models.
2. Identify valid post-purchase Finance UUID changes.
3. Consolidate old and new Finance UUIDs into a deduplicated enrichment queue.
4. Join enriched IBAN information to detect account changes.
5. Create reporting-ready mart tables.

---

## 2. Async Enrichment Pipeline

1. Read distinct Finance UUIDs from BigQuery.
2. Process UUIDs asynchronously in batches.
3. Call FastAPI mock banking enrichment service.
4. Apply retry handling for failed batches.
5. Validate requested vs returned record counts.
6. Load enriched results into BigQuery.

---

## 3. Reporting Pipeline

1. Retrieve IBAN change records from BigQuery.
2. Generate country-specific Excel reports.
3. Expose only the last four IBAN digits for GDPR compliance.
4. Distribute reports automatically through email.

---

# Folder Structure

analytics-engineering/

├── dbt/
│   ├── models/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│
├── src/
│   └── app/
│       ├── clients/
│       │   ├── bigquery_client.py
│       │   └── api_client.py
│       │
│       ├── config/
│       │   └── settings.py
│       │
│       ├── reporting/
│       │   └── reports.py
│       │
│       ├── services/
│       │   ├── transformation_service.py
│       │   └── batch_service.py
│       │
│       ├── enrichment_job.py
│       ├── iban_router.py
│       └── main.py
│
├── raw/
├── docs/
├── tests/
├── README.md
└── requirements.txt


---

# Running the Application

## Start FastAPI Service

```bash
cd src

uvicorn app.main:app --reload
cd src

python -m app.enrichment_job
```

## Data Quality & Reliability

Data quality and reliability controls are implemented across dbt transformations and the enrichment pipeline.

### dbt Data Quality Checks

* Not Null validation
* Unique key validation
* Accepted values validation
* Referential integrity checks

### Pipeline Reliability Controls

* Finance UUID validation
* Duplicate Finance UUID removal before enrichment
* API authentication validation
* Asynchronous batch processing
* Batch-level retry handling (3 retry attempts)
* Requested vs returned record reconciliation
* Branch and country completeness validation for stakeholder reporting

---

## Reporting Output

The monthly reporting process generates GDPR-safe stakeholder reports.

Generated outputs include:

* Market-specific IBAN change reports
* One Excel workbook per country/market
* Only the last four digits of IBAN values exposed
* Automated email distribution to stakeholders

Generated reports are attached to stakeholder emails.

In a production implementation, reports would additionally be archived in centralized storage locations such as Google Cloud Storage, SharePoint, or S3 to support:

* Auditability
* Historical access
* Report re-distribution

---

## Future Improvements

* Incremental processing using finance change timestamp
* IBAN history tracking using valid_from / valid_to periods
* Pipeline execution audit tables
* Report generation history tracking
* Delivery status monitoring
* Data quality exception reporting for missing market mappings
* Production banking API integration
* Monitoring and alerting
* CI/CD pipeline using GitHub Actions
* Cloud Scheduler orchestration
* Docker containerization