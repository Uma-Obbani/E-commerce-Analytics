/*
    Model: fact_experiments
    Purpose: Experiment results for campaign testing.
    Grain: One row per customer experiment.
*/


{{ config(
materialized='table'
) }}


select

experiment_id,

customer_id,

variant,

converted


from {{ ref('stg_ab_tests') }}