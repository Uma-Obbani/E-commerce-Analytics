/*
    Model: fact_transactions
    Purpose: Customer purchase transactions.
    Grain: One row per order.
*/


{{ config(
    materialized='table'
) }}


select

order_id,

customer_id,

order_date,

gross_revenue,

discount_amount,

net_revenue


from {{ ref('stg_orders') }}