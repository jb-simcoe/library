with cte as (
    
    select  rent_id
          , copy_id
          , max_rent_duration
          , PARSE_DATE("%Y%m%d", cast(return_date as string)) as return_date
    from {{ source('mysql','src_rent_item') }}
)

select * from cte