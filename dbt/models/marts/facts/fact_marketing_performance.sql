/*
    Model: fact_marketing_performance
    Purpose: Campaign performance metrics.
    Grain: One row per campaign per day.
*/


{{ config(
    materialized='table'
) }}


select


date,

campaign_id,

channel,


sum(spend)
    as spend,


sum(impressions)
    as impressions,


sum(clicks)
    as clicks,


sum(conversions)
    as conversions


from {{ ref('int_marketing_channels') }}


group by

1,2,3