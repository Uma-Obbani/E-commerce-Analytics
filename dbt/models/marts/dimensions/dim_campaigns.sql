/*
    Model: dim_campaign
    Purpose: Campaign attributes across marketing channels.
    Grain: One row per campaign.
*/


{{ config(
    materialized='table'
) }}


select distinct

    campaign_id,

    campaign_name,

    channel


from {{ ref('int_marketing_channels') }}