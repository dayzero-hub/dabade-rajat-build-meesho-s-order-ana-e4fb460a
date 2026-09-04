-- Grain: one row per order line item (order_id, order_item_id). price and freight_value live
-- here, not on the order, so summing them at this grain never fans out on a line-item join.
--
-- Orders that never reached the customer (cancelled, unavailable, still in transit, ...) are
-- included, not dropped: the line item was still sold and still carries price/freight_value.
-- delivery_days and delivered_late are null for them rather than the fact row disappearing —
-- that null propagates on its own from order_delivered_customer_at being null, no CASE needed.
select
    md5(oi.order_id || '-' || oi.order_item_id::varchar) as order_item_key,
    oi.order_id,
    oi.order_item_id,
    dc.customer_key,
    dp.product_key,
    ds.seller_key,
    dd.date_key as order_date_key,
    o.order_status,
    oi.price,
    oi.freight_value,
    date_diff('day', o.order_purchased_at, o.order_delivered_customer_at) as delivery_days,
    o.order_delivered_customer_at > o.order_estimated_delivery_at as delivered_late
from {{ ref('stg_order_items') }} oi
inner join {{ ref('stg_orders') }} o on oi.order_id = o.order_id
inner join {{ ref('stg_customers') }} c on o.customer_order_id = c.customer_order_id
inner join {{ ref('dim_customers') }} dc on c.customer_unique_id = dc.customer_unique_id
inner join {{ ref('dim_products') }} dp on oi.product_id = dp.product_id
inner join {{ ref('dim_sellers') }} ds on oi.seller_id = ds.seller_id
inner join {{ ref('dim_dates') }} dd on cast(o.order_purchased_at as date) = dd.date_day
