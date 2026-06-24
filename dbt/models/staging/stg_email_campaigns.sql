/*
    Model: stg_email_campaigns
    Purpose: Standardize raw email engagement data for customer analytics.
    Grain: One row per customer email campaign interaction.
*/


{{ config(
    materialized='view'
) }}


with source as (

    -- Load raw email campaign data
    select *

    from {{ source('ecommerce', 'raw_email_campaigns') }}

),


stg_email_campaigns as (

    select


        -- Customer associated with email activity
        cast(customer_id as string) as customer_id,


        -- Email delivery date
        cast(send_date as date) as send_date,


        -- Email campaign identifier
        cast(campaign_id as string) as campaign_id,


        -- Email open indicator
        cast(opened as int64) as opened,


        -- Email click indicator
        cast(clicked as int64) as clicked,


        -- Data processing timestamp
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_email_campaigns