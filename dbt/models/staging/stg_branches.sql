--- This is a staging model for branches data. It selects relevant columns from the raw_branches source and renames them for consistency. The model is materialized as a view for easy access in downstream models.
{{ config(materialized='view') }}

SELECT
    id AS branch_id,
    name AS branch_name,
    address AS branch_address,
    country

FROM {{ source('auto1', 'raw_branches') }}