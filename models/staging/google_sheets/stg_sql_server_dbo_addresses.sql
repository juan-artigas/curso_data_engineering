{{
  config(
    materialized='view'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    WHERE _fivetran_deleted IS NULL
    ),
renamed_casted AS (
    SELECT
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_synced AS date_load
    FROM src_addresses
    )
SELECT * FROM renamed_casted