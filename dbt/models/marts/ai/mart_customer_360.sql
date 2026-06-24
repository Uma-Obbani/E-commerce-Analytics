/*
    Model: mart_customer_360
    Purpose: Customer level ML feature table for CLV, churn and AI personalization.
    Grain: One row per customer.
*/


{{ config(
    materialized='table'
) }}


with customers as (

    select *

    from {{ ref('dim_customers') }}

),


orders as (

    select *

    from {{ ref('int_customer_orders') }}

),


engagement as (

    select *

    from {{ ref('int_customer_engagement') }}

),


final as (

select


    -- Customer profile
    c.customer_id,

    c.country,

    c.age,

    c.email_opt_in,

    c.signup_date,


    -- Customer tenure
    date_diff(
        current_date(),
        c.signup_date,
        day
    ) as customer_age_days,


    -- Purchase behavior
    coalesce(o.total_orders,0)
        as total_orders,


    coalesce(o.lifetime_value,0)
        as historical_clv,


    coalesce(o.avg_order_value,0)
        as avg_order_value,


    date_diff(
        current_date(),
        o.last_order_date,
        day
    ) as days_since_last_order,


    -- Digital engagement
    coalesce(e.total_web_events,0)
        as total_web_events,


    coalesce(e.email_opens,0)
        as email_opens,


    coalesce(e.email_clicks,0)
        as email_clicks


from customers c


left join orders o

on c.customer_id = o.customer_id


left join engagement e

on c.customer_id = e.customer_id

)


select *

from final