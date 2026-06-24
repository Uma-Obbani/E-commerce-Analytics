/*
    Model: dim_customer
    Purpose: Customer dimension for analytics and ML models.
    Grain: One row per customer.
*/


{{ config(
    materialized='table'
) }}


select

    customer_id,

    signup_date,

    country,

    age,

    email_opt_in


from {{ ref('stg_crm_customers') }}