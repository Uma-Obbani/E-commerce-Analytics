/*
    Model: stg_ga4_events
    Purpose: Standardize raw GA4 event data for customer journey analysis.
    Grain: One row per customer event.
*/


{{ config(
    materialized='view'
) }}


with source as (

    -- Load raw GA4 event data
    select *

    from {{ source('ecommerce', 'raw_ga4_events') }}

),


stg_ga4_events as (

    select


        -- Unique event identifier
        cast(event_id as string) as event_id,


        -- Customer associated with the event
        cast(customer_id as string) as customer_id,


        -- Event activity date
        cast(event_date as date) as event_date,


        -- User interaction type
        event_name,


        -- Marketing traffic source
        traffic_source,


        -- Data processing timestamp
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_ga4_events