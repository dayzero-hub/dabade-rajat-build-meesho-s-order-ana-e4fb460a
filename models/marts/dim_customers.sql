-- Keyed on the real person (customer_unique_id), not the per-order customer_order_id.
select
    md5(customer_unique_id) as customer_key,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from {{ ref('stg_customers') }}
qualify row_number() over (partition by customer_unique_id order by customer_order_id) = 1
