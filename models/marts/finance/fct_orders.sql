with payments as (
    select order_id,
    case when status='success' then amount/100 else 0 end as amount
     from {{ ref('stg_stripe__payments') }}
),
orders as (
    select order_id,customer_id,order_date
    from {{ ref('stg_jaffle_shop__orders') }}
),
final as (
    select 
    o.order_id,
    o.customer_id,
    p.AMOUNT as amount,
    o.order_date
    from orders o 
    left join payments p using (order_id)
)
select * from final