{{ config(materialized='table') }}

WITH all_uuids AS (

    SELECT 
        old_finance_uuid AS finance_uuid

    FROM {{ ref('int_purchase_finance_changes') }}

    WHERE old_finance_uuid IS NOT NULL


    UNION DISTINCT


    SELECT 
        new_finance_uuid AS finance_uuid

    FROM {{ ref('int_purchase_finance_changes') }}

    WHERE new_finance_uuid IS NOT NULL

)

SELECT 
    finance_uuid

FROM all_uuids