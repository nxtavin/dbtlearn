with
    customers as (
        select
            customer_id,
            first_name as customer_first_name,
            last_name as customer_last_name
        from {{ ref("stg_jaffle_shop__customers") }}
    ),
    orders as (
        select order_id, customer_id, order_date, status
        from {{ ref("stg_jaffle_shop__orders") }}
    ),
    payments as (
        select id, order_id, payment_method, status, amount, created
        from {{ ref("stg_stripe__payments") }}
    ),
    valid_payments_amount as (
        select
            order_id,
            max(created) as payment_finalized_date,
            sum(amount) / 100.0 as total_amount_paid
        from payments
        where status != 'fail'
        group by 1
    ),
    paid_orders as (
        select
            o.order_id,
            o.customer_id,
            o.order_date as order_placed_at,
            o.status as order_status,
            v.total_amount_paid,
            v.payment_finalized_date
        from orders o
        join valid_payments_amount v using (order_id)

    ),
    customer_orders as (
        select
            c.customer_id,
            c.customer_last_name,
            c.customer_first_name,
            min(o.order_date) as first_order_date,
            max(o.order_date) as most_recent_order_date,
            count(o.order_id) as number_of_orders
        from customers c
        left join orders o using (customer_id)
        group by all
    ),
    final as (
        select
            p.*,
            c.customer_first_name,
            c.customer_last_name,
            row_number() over (order by p.order_id) as transaction_seq,
            row_number() over (
                partition by customer_id order by p.order_id
            ) as customer_sales_seq,
            case
                when c.first_order_date = p.order_placed_at then 'new' else 'return'
            end as nvsr,
            sum(p.total_amount_paid) over (
                partition by customer_id
            ) as customer_lifetime_value,
            c.first_order_date as fdos
        from paid_orders p
        left join customer_orders c using (customer_id)
    )
select *
from final
