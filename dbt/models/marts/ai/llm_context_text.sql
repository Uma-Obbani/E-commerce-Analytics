/*
    Model: mart_llm_customer_context
    Purpose: Prepare natural language customer context for LLM retrieval.
    Grain: One row per customer.
*/


{{ config(
    materialized='table'
)}}


select


customer_id,


concat(

'Customer is ',
customer_value_segment,

'. Churn status is ',

churn_risk,

'. Engagement level is ',

engagement_segment,

'. Recommended marketing action: ',

recommended_action

) as llm_context


from {{ ref('customer_scores') }}