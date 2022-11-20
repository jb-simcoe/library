with customers as (
    
    select  customer_id
          , first_name
          , last_name

    from {{ source('mysql','src_customer') }}
)

select * from customers