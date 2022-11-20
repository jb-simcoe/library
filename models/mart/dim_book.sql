select 
    {{ dbt_utils.star(from=ref('core_dim_book'), except=["library_id","dbt_scd_id", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to"]) }},
    library_id as current_library_id
from {{ref('core_dim_book')}}
where dbt_valid_to is null