with customer as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
)
select 
{{ dbt_utils.generate_surrogate_key(['order_date','customer_id']) }} as pk,
order_date,
customer_id,
count(*) as order_count
from customer
group by order_date,customer_id
