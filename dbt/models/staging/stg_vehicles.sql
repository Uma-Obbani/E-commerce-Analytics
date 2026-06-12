{{ config(materialized='view') }}

-- This is a staging model for vehicles data. It selects relevant columns from the raw_vehicles source and renames them for consistency. The model is materialized as a view for easy access in downstream models.
SELECT

    id AS purchase_id,

    code AS vehicle_code,

    status_id,

  SAFE_CAST(branch_id AS INT64) AS branch_id,

    dat_ecode,

    mileage,

    built_year,

    created_on AS created_timestamp,

    created_by

FROM {{ source('auto1', 'raw_vehicles') }}
