/*
    Model: int_experiment_results
    Purpose: Summarize experiment performance.
    Grain: One row per experiment variant.
*/


{{ config(materialized='table') }}


select

experiment_id,

variant,

count(customer_id) as users,

sum(converted) as conversions


from {{ ref('stg_ab_tests') }}


group by 1,2