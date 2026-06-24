# 🛒 E-Commerce AI Analytics Copilot

An end-to-end modern data platform that transforms raw e-commerce data into AI-powered customer intelligence using **BigQuery, dbt, Gemini, RAG, Vector Search, and Streamlit**.

The platform enables business users to ask natural language questions about customers, churn risk, customer value, and marketing recommendations.

---

## 🚀 Project Overview

This project demonstrates a complete Analytics Engineering + AI workflow:

- Data ingestion
- Cloud data warehouse modeling
- dbt transformations
- Data quality testing
- Customer intelligence marts
- AI-ready semantic layer
- RAG pipeline
- Conversational analytics interface


---

## 🏗️ Architecture


```
                 Data Sources

        Customers | Orders | Products | Campaigns

                         |
                         ▼

                  BigQuery Raw Layer

                         |
                         ▼

                     dbt Core

                         |

        ┌─────────────────────────────────┐
        │                                 │
        ▼                                 ▼

   Staging Models                 Intermediate Models

   stg_customers                  int_customer_metrics
   stg_orders                     int_customer_engagement
   stg_campaigns                  int_campaign_performance


                         |
                         ▼

                    Data Marts

             customer_intelligence

             campaign_intelligence

             mart_customer_360

             mart_ai_marketing_copilot


                         |
                         ▼

                  AI / RAG Layer


          Gemini Embeddings

                  |
                  ▼

          Chroma Vector Database

                  |
                  ▼

             RAG Engine

                  |
                  ▼

            Gemini LLM

                  |
                  ▼

          Streamlit AI Copilot

```

---

# 🛠️ Tech Stack

## Data Engineering

- Python 3.11
- Google Cloud Platform
- BigQuery

## Analytics Engineering

- dbt Core
- dbt BigQuery Adapter
- dbt Tests
- dbt Documentation

## AI Engineering

- Gemini Embeddings
- LangChain
- Chroma Vector Database
- Retrieval Augmented Generation (RAG)

## Application Layer

- Streamlit


---

# 📁 Project Structure


```
E-commerce Analytics

│
├── dbt/
│   |
│   ├── models/
│   │
│   ├── staging/
│   ├── intermediate/
│   └── marts/
│        |
│        └── ai/
│             ├── customer_intelligence.sql
│             ├── customer_score.sql
│             ├── llm_context_text.sql
│             ├── mart_customer_360.sql
│             └── mart_ai_marketing_copilot.sql
│
│
├── ai_engine/
│
│   ├── bigquery_client.py
│   ├── embeddings.py
│   ├── rag_engine.py
│   └── prompts.py
│
│
├── streamlit_app/
│
│   └── app.py
│
│
├── requirements.txt
├── README.md
└── .env

```

---

# 🔄 Data Pipeline Flow


## 1. Raw Data

E-commerce datasets:

- Customers
- Orders
- Products
- Campaigns
- User activity


---

## 2. dbt Transformation Layer


### Staging Layer

Cleans and standardizes raw tables.


Example:

```
raw_customers

        ↓

stg_customers

```

---

### Intermediate Layer


Creates reusable business logic:


- Customer engagement
- Purchase behavior
- Campaign metrics


---

### Mart Layer


Business-ready datasets:


### Customer Intelligence


Features:


- Customer Lifetime Value
- Purchase behavior
- Engagement segment
- Churn indicators
- Customer priority score


---

# 🤖 AI Layer


## AI Context Generation


dbt creates LLM-ready text:


Example:


```
Customer 1024 is a premium customer.
High lifetime value.
Low churn risk.
Recommended campaign: Loyalty offer.
```


---

## Embeddings


Generated using Gemini:


```
Customer Text

      ↓

Gemini Embedding Model

      ↓

Vector Representation

      ↓

Chroma Database

```

---

# 🔎 RAG Workflow


User asks:


```
Which customers are likely to churn?
```


Process:


```
Question

   ↓

Vector Search

   ↓

Retrieve similar customer profiles

   ↓

Gemini LLM

   ↓

Business recommendation

```


Example output:


```
High risk customers:

Customer 2041

Reason:
- Low engagement
- No recent orders

Recommended Action:
Send win-back campaign

```

---

# 💬 Streamlit AI Copilot


Run application:


```bash
streamlit run streamlit_app/app.py
```


Users can ask:


- Which customers may churn?
- Who are my highest value customers?
- Recommend marketing actions
- Which campaign should I prioritize?


---

# ⚙️ Setup


Create environment:


```bash
python3.11 -m venv venv

source venv/bin/activate
```


Install dependencies:


```bash
pip install -r requirements.txt
```


---

# dbt Commands


Test connection:


```bash
dbt debug
```


Run models:


```bash
dbt build
```


Generate docs:


```bash
dbt docs generate

dbt docs serve
```


---

# Build Vector Store


```bash
python -m ai_engine.embeddings
```


---

# Start AI Copilot


```bash
streamlit run streamlit_app/app.py
```


---

# Future Enhancements


- BigQuery Vector Search
- Vertex AI deployment
- BigQuery ML churn prediction
- Airflow orchestration
- CI/CD pipeline
- Docker + Cloud Run
- Real-time event streaming


---

# Project Goal


Build a production-style AI analytics platform combining:

Data Engineering + Analytics Engineering + Generative AI

```
Raw Data → BigQuery → dbt → AI Marts → RAG → AI Copilot
```
