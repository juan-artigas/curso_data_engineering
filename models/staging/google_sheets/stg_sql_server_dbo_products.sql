{{
  config(
    materialized='view'
  )
}}

with src_products as (
    select * from {{ source('sql_server_dbo', 'products') }}
    where _fivetran_deleted IS NULL
),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_synced as date_load
    from src_products

)
select * from renamed_casted
