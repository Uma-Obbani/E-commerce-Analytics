{{ config(materialized='table') }}

SELECT

    car_id,
    branch_id,
    country,
    purchase_datetime,

    old_iban_last4 AS iban_before_last4,

    old_iban_last_active_datetime AS iban_last_active_datetime,


    new_iban_last4 AS iban_after_last4,
    change_event_datetime

FROM {{ ref('int_purchase_finance_iban') }}

