{% snapshot core_dim_book %}

{{
    config(
      unique_key='copy_id',
      target_schema='library_core',
      strategy='check',
      check_cols='all'
    )
}}


with copy as (
    select * from {{ ref('stg_book_copy') }}
),

book as (
  select * from {{ ref('stg_book') }}
),

genre as (
  select * from {{ ref('stg_genre') }}
)

select copy.copy_id,
       copy.book_id,
     {{ dbt_utils.star(from=ref('stg_book'), except=["book_id"], relation_alias="book") }}{{","}}
     {{ dbt_utils.star(from=ref('stg_book_copy'), except=["copy_id","book_id"], relation_alias="copy") }},
     {{ dbt_utils.star(from=ref('stg_genre'), except=["genre_code"], relation_alias="genre") }}
       from copy
       join book on copy.book_id = book.book_id
       join genre on book.genre_code = genre.genre_code

{% endsnapshot %}