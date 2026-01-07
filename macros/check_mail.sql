{% test check_mail(model, column_name) %}

with validate_mail as (

    select coalesce (regexp_like({{ column_name }}, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address
    from {{ model }}
)
select * from validate_mail
where not is_valid_email_address 

{% endtest %}