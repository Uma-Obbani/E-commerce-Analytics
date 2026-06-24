/*
    Model: mart_customer_ai_scores
    Purpose: Generate customer intelligence scores using business rules.
    Grain: One row per customer.
*/


{{ config(
    materialized='table'
) }}


with customers as (

    select *

    from {{ ref('mart_customer_360') }}

),


scores as (

select


    customer_id,


    -- Customer value score

    historical_clv,


    case

        when historical_clv >= 1000
            then 'High Value'

        when historical_clv >= 300
            then 'Medium Value'

        else 'Low Value'

    end as customer_value_segment,



    -- Churn risk score

    case

        when days_since_last_order > 90
             and email_clicks = 0

            then 'High Risk'


        when days_since_last_order > 45

            then 'Medium Risk'


        else 'Low Risk'


    end as churn_risk,



    -- Engagement score

    case

        when email_clicks >= 5
             or total_web_events >= 20

            then 'Highly Engaged'


        when email_clicks >= 1

            then 'Moderately Engaged'


        else 'Low Engagement'


    end as engagement_segment,



    -- Marketing recommendation

    case

        when days_since_last_order > 90
             and historical_clv >= 1000

            then 'Send VIP retention campaign'


        when total_orders = 0

            then 'Send first purchase offer'


        when email_clicks >= 5

            then 'Send upsell campaign'


        else 'Standard nurturing'


    end as recommended_action



from customers

)


select *

from scores