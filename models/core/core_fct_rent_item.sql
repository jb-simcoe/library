{{
    config(
        materialized='incremental',
        unique_key=['copy_id', 'rent_id'],
        incremental_strategy='merge'
    )
}}

with rent as (
    select * from {{ ref('stg_rent') }}
),

item as (
    select * from {{ ref('stg_rent_item') }}
),

book as (
    select *
        ,  count(*) over (partition by copy_id) as entry_count
    from {{ ref('core_dim_book') }}
)

select
       item.copy_id
     , item.rent_id
     , book.library_id
     , rent.customer_id
     , rent.issue_date
     , item.return_date
     , item.max_rent_duration
from item 
join rent on item.rent_id = rent.rent_id
join book on item.copy_id = book.copy_id
         and (rent.issue_date >= date(book.dbt_valid_from) or book.entry_count = 1)
         and rent.issue_date <= coalesce(date(book.dbt_valid_to),(date(2099,12,12)))
{% if is_incremental() %}
where
rent.issue_date >= (select max(issue_date) from {{this}}) or
item.return_date >= (select max(return_date) from {{this}})
{% endif %}