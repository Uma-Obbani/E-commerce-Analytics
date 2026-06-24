/*
    Model: int_customer_orders
    Purpose: Aggregate customer purchase activity.
    Grain: One row per customer.
*/


{{ config(materialized='table') }}


select

    customer_id,

    count(order_id) as total_orders,

    sum(net_revenue) as lifetime_value,

    avg(net_revenue) as avg_order_value,

    max(order_date) as last_order_date


from {{ ref('stg_orders') }}


group by customer_id