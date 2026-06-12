{{ config(materialized='table') }}

WITH finance_changes AS (

    SELECT *
    FROM {{ ref('int_purchase_finance_changes') }}

),

iban_lookup AS (

    SELECT
        finance_uuid,
        iban
    FROM {{ source('auto1', 'int_finance_uuid_iban') }}

)

SELECT

    fc.changelog_id,

    fc.vehicle_code AS car_id,

    fc.branch_id,

    fc.market AS country,

    fc.purchase_timestamp AS purchase_datetime,


    -- Previous bank account

    RIGHT(old_iban.iban, 4)
        AS old_iban_last4,


    -- Old IBAN was active until finance UUID changed

    fc.finance_uuid_changed_timestamp
        AS old_iban_last_active_datetime,


    -- Actual change event timestamp

    fc.finance_uuid_changed_timestamp
        AS change_event_datetime,


    -- New bank account

    RIGHT(new_iban.iban, 4)
        AS new_iban_last4


FROM finance_changes fc


LEFT JOIN iban_lookup old_iban
    ON fc.old_finance_uuid = old_iban.finance_uuid


LEFT JOIN iban_lookup new_iban
    ON fc.new_finance_uuid = new_iban.finance_uuid


WHERE COALESCE(old_iban.iban, '')
    <> COALESCE(new_iban.iban, '')