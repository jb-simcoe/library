with date as (
    select * from {{ ref('core_dim_date') }}
),

fct_rent_item as (
    select * from {{ ref('fct_rent_item') }}
)

select * from date
where 1=1
  and date.date_day >= (select min(issue_date) from fct_rent_item)
  and date.date_day <= (select max(return_date) from fct_rent_item)