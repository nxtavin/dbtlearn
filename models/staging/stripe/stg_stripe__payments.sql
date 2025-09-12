select 
ID as id,
ORDERID AS order_id,
PAYMENTMETHOD as payment_method,
STATUS as status,
AMOUNT as amount,
CREATED AS created
from {{ source('jaffle_shop', 'stripe_payments') }}