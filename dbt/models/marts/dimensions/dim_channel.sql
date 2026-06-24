/*
    Model: dim_channel
    Purpose: Marketing channel classification.
    Grain: One row per channel.
*/


{{ config(
    materialized='table'
) }}


select distinct

channel,


case

    when channel in ('Google','Meta')
        then 'Paid'

    when channel='Email'
        then 'Owned'

    else 'Organic'

end as channel_type


from {{ ref('int_marketing_channels') }}