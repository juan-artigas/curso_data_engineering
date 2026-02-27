{{
  config(
    materialized='view'
  )
}}

with src_orders as (
    select * from {{ source('sql_server_dbo', 'orders') }}
    where _fivetran_deleted IS NULL
),

renamed as (

    select
        order_id,
        CASE 
            WHEN shipping_service = ''
                THEN NULL
            ELSE shipping_service
        END AS shipping_service,
        shipping_cost,
        address_id,
        created_at,
        CASE 
            WHEN promo_id = ''
                THEN NULL
            ELSE
                promo_id
        END AS promo_id,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        CASE 
            WHEN tracking_id = ''
                THEN NULL
            ELSE tracking_id
        END AS tracking_id,
        status,
        _fivetran_synced as date_load

    from src_orders
)
select * from renamed_casted

