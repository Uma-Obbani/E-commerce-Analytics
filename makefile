# ==================================================
# E-Commerce AI Analytics Platform
# BigQuery + dbt + Gemini RAG + Streamlit
# ==================================================


# ---------- Python Environment ----------

venv:
	python3.11 -m venv venv
	./venv/bin/pip install --upgrade pip


install:
	pip install -r requirements.txt


freeze:
	pip freeze > requirements.txt



# ---------- dbt Commands ----------

dbt-debug:
	cd dbt && dbt debug


dbt-deps:
	cd dbt && dbt deps


dbt-run:
	cd dbt && dbt run


dbt-test:
	cd dbt && dbt test


dbt-build:
	cd dbt && dbt build


dbt-docs:
	cd dbt && dbt docs generate && dbt docs serve



# ---------- AI Engine ----------

build-vector:
	python -m ai_engine.embeddings


test-rag:
	python -m ai_engine.rag_engine



# ---------- Streamlit App ----------

app:
	streamlit run streamlit_app/app.py



# ---------- Git ----------

status:
	git status


push:
	git add .
	git commit -m "Update ecommerce AI analytics platform"
	git push origin main



# ---------- Cleanup ----------

clean-vector:
	rm -rf vector_store


clean-python:
	find . -type d -name "__pycache__" -exec rm -rf {} +



# ---------- Full Pipeline ----------

pipeline:
	cd dbt && dbt build
	python -m ai_engine.embeddings


run-all:
	cd dbt && dbt build
	python -m ai_engine.embeddings
	streamlit run streamlit_app/app.py