{{ config(materialized='view') }}

SELECT

    id AS purchase_id,

    purchase_datetime AS purchase_timestamp,

    buy_price,

    bank_uuid AS current_finance_uuid,

    created_on AS created_timestamp,

    created_by,

    updated_on AS updated_timestamp

FROM {{ source('auto1', 'raw_purchases') }}