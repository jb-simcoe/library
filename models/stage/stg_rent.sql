with cte as (
    
    select  rent_id
          , customer_id
          , PARSE_DATE("%Y%m%d", cast(issue_date as string)) as issue_date
    from {{ source('mysql','src_rent') }}
)

select * from cte