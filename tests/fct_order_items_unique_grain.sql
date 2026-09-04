-- Fails if any (order_id, order_item_id) pair appears more than once, i.e. the declared grain
-- of fct_order_items is broken. Checks the natural composite key directly, not the
-- order_item_key hash, so a bug in the hash itself couldn't hide a grain violation.
select
    order_id,
    order_item_id,
    count(*) as row_count
from {{ ref('fct_order_items') }}
group by order_id, order_item_id
having count(*) > 1
