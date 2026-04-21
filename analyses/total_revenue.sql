SELECT 
    payment_status, 
    sum(payment_amount) as total_revenue
FROM {{ ref('stg_stripe__payments') }}
GROUP BY payment_status
