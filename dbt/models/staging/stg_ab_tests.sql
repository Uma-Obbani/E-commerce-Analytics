/*
    Model: stg_ab_tests
    Purpose: Standardize raw experiment data for A/B testing analytics.
    Grain: One row per customer experiment assignment.
*/


{{ config(
    materialized='view'
) }}


with source as (

    -- Load raw A/B testing data
    select *

    from {{ source('ecommerce', 'raw_ab_tests') }}

),


stg_ab_tests as (

    select


        -- Unique experiment identifier
        cast(experiment_id as string) as experiment_id,


        -- Customer assigned to experiment
        cast(customer_id as string) as customer_id,


        -- Experiment group assignment
        variant,


        -- Conversion outcome flag
        cast(converted as int64) as converted,


        -- Data processing timestamp
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_ab_tests