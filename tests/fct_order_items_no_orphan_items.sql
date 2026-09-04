-- Fails if a line item present in staging silently disappeared from the fact table, e.g.
-- because one of the inner joins to a dimension (or the customer bridge) found no match.
select
    oi.order_id,
    oi.order_item_id
from {{ ref('stg_order_items') }} oi
left join {{ ref('fct_order_items') }} f
    on oi.order_id = f.order_id
    and oi.order_item_id = f.order_item_id
where f.order_item_key is null
