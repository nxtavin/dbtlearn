select 
ID as id,
ORDERID AS order_id,
PAYMENTMETHOD as payment_method,
STATUS as status,
{{cents_to_dollars('AMOUNT', 2)}} as amount,
CREATED AS created
from {{ source('jaffle_shop', 'stripe_payments') }}