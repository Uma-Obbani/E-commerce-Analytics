/*
    Model: stg_crm_customers
    Purpose: Standardize raw CRM customer data for customer analytics.
    Grain: One row per customer.
*/


{{ config(
    materialized='view'
) }}


with source as (

    -- Load raw CRM customer data
    select *

    from {{ source('ecommerce', 'raw_crm_customers') }}

),


stg_crm_customers as (

    select


        -- Unique customer identifier
        cast(customer_id as string) as customer_id,


        -- Customer registration date
        cast(signup_date as date) as signup_date,


        -- Customer country
        country,


        -- Customer age
        cast(age as int64) as age,


        -- Email marketing consent flag
        cast(email_opt_in as boolean) as email_opt_in,


        -- Data processing timestamp
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_crm_customers