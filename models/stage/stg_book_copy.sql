with book_copy as (
    
    select  copy_id
          , book_id
          , library_id
          , PARSE_DATE("%Y%m%d", cast(acquisition_date as string)) as acquisition_date
          , condition

    from {{ source('mysql','src_book_copy') }}
)

select * from book_copy