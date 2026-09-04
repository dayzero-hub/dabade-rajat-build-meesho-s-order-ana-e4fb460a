-- customer_order_id changes on every order; customer_unique_id is the durable person behind it.
select
    customer_id as customer_order_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from {{ source('raw', 'olist_customers_dataset') }}
