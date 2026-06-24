/*
    Model: stg_google_ads
    Purpose: Standardize raw Google Ads data for downstream marketing models.
    Grain: One row per campaign per day.
*/


{{ config(
    materialized='view'
) }}


with source as (

    -- Load raw Google Ads source data
    select *

    from {{ source('ecommerce', 'raw_google_ads') }}

),


stg_google_ads as (

    select


        -- Campaign reporting date
        cast(date as date) as date,


        -- Unique campaign identifier
        cast(campaign_id as string) as campaign_id,


        -- Campaign name from Google Ads
        campaign_name,


        -- Standardized marketing channel
        'Google' as channel,


        -- Normalize Google cost field to common spend naming
        cast(cost as numeric) as spend,


        -- Number of ad impressions
        cast(impressions as int64) as impressions,


        -- Number of ad clicks
        cast(clicks as int64) as clicks,


        -- Number of campaign conversions
        cast(conversions as int64) as conversions,


        -- Data processing timestamp
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_google_ads