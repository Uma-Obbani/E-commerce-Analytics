
{{ config(
    materialized='view'
) }}


with source as (

    select *

    from {{ source('ecommerce', 'raw_products') }}

),


stg_products as (

    select

        -- primary key
        cast(product_id as string) as product_id,


        -- product attributes
        category as product_category,


        cast(price as numeric) as product_price,


        -- metadata
        current_timestamp() as dbt_loaded_at


    from source

)


select *

from stg_products