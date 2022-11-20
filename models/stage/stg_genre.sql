with genres as (
    
    select  genre_code
          , title as genre_title
          , description
          , minimum_age

    from {{ source('mysql','src_genre') }}
)

select * from genres