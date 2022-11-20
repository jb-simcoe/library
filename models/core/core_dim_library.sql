with cte as (
    select * from {{ ref('stg_library') }}
)
select * from cte