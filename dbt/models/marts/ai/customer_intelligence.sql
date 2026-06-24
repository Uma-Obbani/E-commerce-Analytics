/*
    Model: mart_customer_intelligence
    Purpose: Final customer decision layer for AI agents and marketing teams.
    Grain: One row per customer.
*/


{{ config(
    materialized='table'
) }}


select


    c.customer_id,


    -- Customer profile
    c.country,

    c.age,

    c.email_opt_in,


    -- Revenue metrics
    c.total_orders,

    c.historical_clv,

    c.avg_order_value,


    -- Engagement
    c.total_web_events,

    c.email_opens,

    c.email_clicks,


    -- AI classifications
    s.customer_value_segment,

    s.churn_risk,

    s.engagement_segment,


    s.recommended_action,


    -- Customer priority ranking

    case

        when s.customer_value_segment = 'High Value'
             and s.churn_risk = 'High Risk'

             then 100


        when s.customer_value_segment = 'High Value'

             then 80


        when s.churn_risk = 'High Risk'

             then 70


        else 40


    end as priority_score,


    -- LLM ready explanation

    concat(

        'Customer ',
        c.customer_id,

        ' is a ',
        s.customer_value_segment,

        ' customer with ',
        s.churn_risk,

        ' churn risk. Recommended action: ',

        s.recommended_action

    ) as ai_summary



from {{ ref('mart_customer_360') }} c


left join {{ ref('customer_scores') }} s

on c.customer_id = s.customer_id