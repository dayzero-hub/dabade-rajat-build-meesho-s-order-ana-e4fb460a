-- Calendar spans every date the order lifecycle touches, generated rather than sourced.
with bounds as (
    select
        min(order_purchased_at)::date as start_date,
        max(order_estimated_delivery_at)::date as end_date
    from {{ ref('stg_orders') }}
),

days as (
    select unnest(generate_series(start_date, end_date, interval 1 day))::date as date_day
    from bounds
)

select
    strftime(date_day, '%Y%m%d')::int as date_key,
    date_day,
    extract(year from date_day) as year,
    extract(quarter from date_day) as quarter,
    extract(month from date_day) as month,
    strftime(date_day, '%B') as month_name,
    extract(day from date_day) as day_of_month,
    -- DuckDB's dayofweek() is 0-6 with Sunday=0, not ISO (Monday=1).
    dayofweek(date_day) as day_of_week,
    strftime(date_day, '%A') as day_name,
    dayofweek(date_day) in (0, 6) as is_weekend
from days
