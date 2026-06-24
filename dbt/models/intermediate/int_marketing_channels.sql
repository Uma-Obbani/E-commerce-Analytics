/*
    Model: int_marketing_channels
    Purpose: Combine paid marketing sources into unified channel data.
    Grain: One row per campaign per day.
*/


{{ config(
    materialized='table'
) }}


with paid_channels as (


    -- Google Ads channel data
    select

        date,

        campaign_id,

        campaign_name,

        channel,

        spend,

        impressions,

        clicks,

        conversions


    from {{ ref('stg_google_ads') }}



    union all



    -- Meta Ads channel data
    select

        date,

        campaign_id,

        campaign_name,

        channel,

        spend,

        impressions,

        clicks,

        conversions


    from {{ ref('stg_meta_ads') }}

)


select *

from paid_channels