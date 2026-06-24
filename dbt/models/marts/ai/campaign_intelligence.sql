/*
    Model: mart_campaign_intelligence
    Purpose: Build campaign performance intelligence for AI recommendations.
    Grain: One row per campaign per channel.
*/


{{ config(
    materialized='table'
) }}


with campaign_performance as (

    select

        campaign_id,

        channel,


        -- Marketing investment
        sum(spend)
            as total_spend,


        -- Reach metrics
        sum(impressions)
            as total_impressions,


        sum(clicks)
            as total_clicks,


        sum(conversions)
            as total_conversions,


        -- Efficiency metrics
        safe_divide(
            sum(clicks),
            sum(impressions)
        ) as ctr,


        safe_divide(
            sum(spend),
            sum(clicks)
        ) as cpc,


        safe_divide(
            sum(conversions),
            sum(clicks)
        ) as conversion_rate,


        safe_divide(
            sum(spend),
            sum(conversions)
        ) as cost_per_conversion


    from {{ ref('fact_marketing_performance') }}


    group by

        campaign_id,

        channel

),


campaign_scoring as (

    select

        *,


        -- Campaign performance classification
        case

            when conversion_rate >= 0.10
                 and cost_per_conversion <= 20

                then 'High Performer'


            when conversion_rate >= 0.05

                then 'Average Performer'


            else 'Low Performer'


        end as campaign_segment,


        -- Marketing recommendation
        case


            when conversion_rate >= 0.10
                 and cost_per_conversion <= 20

                then 'Increase budget'


            when ctr < 0.02

                then 'Refresh creatives'


            when cost_per_conversion > 50

                then 'Reduce spend and optimize targeting'


            else 'Continue monitoring'


        end as recommended_action


    from campaign_performance

)


select *

from campaign_scoring