with customers as (

select * from {{ ref('stg_jaffle_shop__customers') }}

),

fct_orders as (

select * from {{ ref('fct_orders') }}


),

customer_orders_payments as (
    select
        customer_id,
        min(p.order_date) as first_order_date,
        max(p.order_date) as most_recent_order_date,
        count(1) as number_of_orders,
        sum(p.amount) as lifetime_value
    from customers o 
    left join fct_orders p using (customer_id)
    group by 1

),

final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders_payments.first_order_date,
        customer_orders_payments.most_recent_order_date,
        coalesce(customer_orders_payments.number_of_orders, 0) as number_of_orders,
        customer_orders_payments.lifetime_value
    from customers
    left join customer_orders_payments using (customer_id)
)

select * from final