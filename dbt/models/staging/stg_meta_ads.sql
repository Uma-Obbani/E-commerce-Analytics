/*
    Model: stg_meta_ads
    Purpose: Standardize raw Meta Ads data for downstream marketing models.
    Grain: One row per campaign per day.
*/


{{ config(
    materialized='view'
) }}


with source as (

    -- Load raw Meta Ads source data
    select *

    from {{ source('ecommerce', 'raw_meta_ads') }}

),


stg_meta_ads as (

    select


        -- Campaign reporting date
        cast(date as date) as date,


        -- Unique campaign identifier
        cast(campaign_id as string) as campaign_id,


        -- Campaign name from source platform
        campaign_name,


        -- Standardized marketing channel
        'Meta' as channel,


        -- Advertising spend amount
        cast(spend as numeric) as spend,


        -- Number of ad impressions
        cast(impressions as int64) as impressions,


        -- Number of ad clicks
        cast(clicks as int64) as clicks,


        -- Standardized conversion metric
        cast(leads as int64) as conversions,


        -- Data load timestamp
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_meta_ads