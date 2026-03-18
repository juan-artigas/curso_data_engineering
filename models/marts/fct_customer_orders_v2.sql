with 
orders as (
    select * from {{ ref("stg_jaffle_shop__orders") }}
),
customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),
payments as (
    select * from {{ ref('stg_stripe__payments') }}
),
paid_orders as (
    select * from {{ ref('int_orders') }}
),
final as (

  select
    paid_orders.order_id,
    paid_orders.customer_id,
    paid_orders.order_placed_at,
    paid_orders.order_status as order_status_new,
    paid_orders.total_amount_paid,
    cast(paid_orders.payment_finalized_date as date) as payment_finalized_date,
    customers.customer_first_name,
    customers.customer_last_name,

    -- sales transaction sequence
    row_number() over (order by paid_orders.order_placed_at, paid_orders.order_id) as transaction_seq,

    -- customer sales sequence
    row_number() over (
        partition by paid_orders.customer_id
        order by paid_orders.order_placed_at, paid_orders.order_id
        ) as customer_sales_seq,

    -- new vs returning customer
    case 
      when (
      rank() over (
        partition by paid_orders.customer_id
        order by paid_orders.order_placed_at, paid_orders.order_id
        ) = 1
      ) then 'new'
    else 'return' end as nvsr,

    -- customer lifetime value
    sum(paid_orders.total_amount_paid) over (
      partition by paid_orders.customer_id
      order by paid_orders.order_placed_at, paid_orders.order_id
      ) as customer_lifetime_value,
    --agrego otro comentario para test ci
    -- first day of sale
    first_value(paid_orders.order_placed_at) over (
      partition by paid_orders.customer_id
      order by paid_orders.order_placed_at, paid_orders.order_id
      ) as fdos
    from paid_orders
    left join customers on paid_orders.customer_id = customers.customer_id
)

select * from final