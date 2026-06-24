/*
    Model: dim_product
    Purpose: Product reference dimension.
    Grain: One row per product.
*/


{{ config(
    materialized='table'
) }}


select

    product_id,

    product_category,

    product_price


from {{ ref('stg_products') }}