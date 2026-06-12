api:
	cd src && uvicorn app.main:app --reload

enrichment:
	cd src && python -m app.enrichment_job

report:
	cd src && python -m app.reporting.monthly_iban_report

dbt-run:
	cd dbt && dbt run

dbt-test:
	cd dbt && dbt test

format:
	pre-commit run --all-files