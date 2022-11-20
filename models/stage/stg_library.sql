with libraries as (
    
    select  library_id
          , name
          , address

    from {{ source('mysql','src_library') }}
)

select * from libraries