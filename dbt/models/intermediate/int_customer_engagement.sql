/*
    Model: int_customer_engagement
    Purpose: Build customer engagement features.
    Grain: One row per customer.
*/


{{ config(
    materialized='table'
) }}


with web_events as (

    -- Aggregate customer website activity
    select

        customer_id,


        count(distinct event_id)
            as total_web_events,


        countif(event_name = 'purchase')
            as web_purchases


    from {{ ref('stg_ga4_events') }}


    group by customer_id

),


email_events as (

    -- Aggregate customer email engagement
    select

        customer_id,


        sum(opened)
            as email_opens,


        sum(clicked)
            as email_clicks


    from {{ ref('stg_email_campaigns') }}


    group by customer_id

),


customer_engagement as (

    select

        coalesce(
            w.customer_id,
            e.customer_id
        ) as customer_id,


        coalesce(
            w.total_web_events,
            0
        ) as total_web_events,


        coalesce(
            w.web_purchases,
            0
        ) as web_purchases,


        coalesce(
            e.email_opens,
            0
        ) as email_opens,


        coalesce(
            e.email_clicks,
            0
        ) as email_clicks


    from web_events w


    full outer join email_events e

    on w.customer_id = e.customer_id

)


select *

from customer_engagement