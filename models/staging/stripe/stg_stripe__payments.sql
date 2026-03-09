WITH source AS (
    SELECT * 
    FROM {{ source('stripe', 'payments') }}
    ),

transformed AS (
    SELECT
        id as payment_id,
        orderid as order_id,
        created as payment_created_at,
        status as payment_status,
        round(amount / 100.0, 2) as payment_amount
    FROM source
    )

SELECT * FROM transformed
