WITH source AS (
    SELECT * 
    FROM {{ source('jaffle_shop', 'customers') }}
    ),

transformed AS (
    SELECT
        id as customer_id,
        first_name as customer_first_name,
        last_name as customer_last_name,
        first_name || ' ' || last_name as full_name
    FROM source
    )

SELECT * FROM transformed
