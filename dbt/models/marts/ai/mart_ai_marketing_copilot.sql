/*
    Model: mart_ai_marketing_copilot
    Purpose: Final AI serving layer combining customer intelligence,
             marketing performance and LLM context.
    Grain: One row per customer.
*/


{{ config(
    materialized='table'
) }}


with customers as (

    select *

    from {{ ref('customer_intelligence') }}

),


campaigns as (

    select *

    from {{ ref('campaign_intelligence') }}

),


llm_context as (

    select *

    from {{ ref('llm_context_text') }}

),


best_campaign as (

    /*
        Select best performing campaign
        based on conversion efficiency.
    */

    select

        campaign_id,

        channel,

        campaign_segment,

        recommended_action
            as campaign_recommendation,


        row_number() over (

            order by conversion_rate desc

        ) as campaign_rank


    from campaigns

),


final as (

select


    -- Customer identity
    c.customer_id,


    -- Customer profile
    c.country,

    c.age,


    -- Customer value
    c.historical_clv,

    c.total_orders,


    c.customer_value_segment,


    -- Risk intelligence
    c.churn_risk,

    c.engagement_segment,


    c.priority_score,


    -- Customer recommendation
    c.recommended_action
        as customer_recommendation,


    -- Best marketing campaign
    bc.campaign_id
        as recommended_campaign_id,


    bc.channel
        as recommended_channel,


    bc.campaign_segment,


    bc.campaign_recommendation,


    -- LLM context
    l.llm_context,


    -- Final AI instruction
    concat(

        l.llm_context,

        ' Suggested campaign channel is ',

        bc.channel,

        '. Campaign action: ',

        bc.campaign_recommendation

    ) as ai_marketing_summary



from customers c


left join llm_context l

on c.customer_id = l.customer_id


left join best_campaign bc

on bc.campaign_rank = 1

)


select *

from final