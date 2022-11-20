with cte as (
    
    select  book_id
          , isbn
          , title
          , edition
          , author
          , publisher
          , genre_code

    from {{ source('mysql','src_book') }}
)

select * from cte