with payment as (
    select * from {{ ref('stg_stripe__payments') }}
    where status = 'success'
)
,
pivoted as (

    select 
    order_id,
    {% for item in dbt_utils.get_column_values(table=ref('stg_stripe__payments'), column='payment_method') %}
        sum(case when payment_method = '{{item}}' then amount else 0 end) as {{item}}_total
        {% if not loop.last %}
            ,
        {% endif %}
    {% endfor %}
    from payment
    group by 1
)
select * from pivoted