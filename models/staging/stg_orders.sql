select
    order_id,
    customer_id as customer_order_id,
    order_status,
    order_purchase_timestamp as order_purchased_at,
    order_approved_at,
    order_delivered_carrier_date as order_delivered_carrier_at,
    order_delivered_customer_date as order_delivered_customer_at,
    order_estimated_delivery_date as order_estimated_delivery_at
from {{ source('raw', 'olist_orders_dataset') }}
