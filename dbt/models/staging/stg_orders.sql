{{ config(
    materialized='view'
) }}


with source as (

    select *

    from {{ source('ecommerce', 'raw_orders') }}

),


stg_orders as (

    select

        -- primary key
        cast(order_id as string) as order_id,


        -- foreign keys
        cast(customer_id as string) as customer_id,


        -- dates
        cast(order_date as date) as order_date,


        -- measures
        cast(revenue as numeric) as gross_revenue,

        cast(discount as numeric) as discount_amount,


        (
            cast(revenue as numeric)
            -
            cast(discount as numeric)
        ) as net_revenue,


        -- metadata
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_orders