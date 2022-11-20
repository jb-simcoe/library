with date as (
    select * from {{ ref('dim_date') }}
),

libraries as (
    select * from {{ ref('dim_library') }}
),

customer_initial_order as (
    select customer_id
         , library_id
         , issue_date
    from (
            select customer_id
                    , library_id
                    , issue_date
                    , row_number() over (partition by customer_id order by issue_date asc) as rent_order_no
                from {{ ref('fct_rent_item') }}
    ) rent_order
    where rent_order.rent_order_no = 1
) ,

count_new_customers as (
    select issue_date
         , library_id
         , count(*) as count_new_customers
    from customer_initial_order
    group by 1,2
)

select date.date_day
     , libraries.library_id
     , coalesce(cnt.count_new_customers,0) as count_new_customers
     , sum(coalesce(cnt.count_new_customers,0)) over (partition by libraries.library_id order by date.date_day asc) as total_active_customers
from date
cross join libraries
left join count_new_customers cnt on date.date_day = cnt.issue_date and libraries.library_id = cnt.library_id