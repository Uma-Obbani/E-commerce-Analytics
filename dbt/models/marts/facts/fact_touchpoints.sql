/*
    Model: fact_customer_touchpoints
    Purpose: Customer journey events.
    Grain: One row per interaction.
*/


{{ config(
materialized='table'
) }}


select

event_id,

customer_id,

event_date,

traffic_source,

event_name


from {{ ref('stg_ga4_events') }}