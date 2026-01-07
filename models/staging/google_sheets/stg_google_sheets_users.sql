{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('google_sheets', 'users') }}
    ),

renamed_casted AS (
    SELECT
      nombre,
      dni,
      email,
      fecha_alta_sistema AS date_load
    FROM src_users
    )

SELECT * FROM renamed_casted
