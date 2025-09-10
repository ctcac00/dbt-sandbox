with

    orders as (select * from {{ ref("int_order_items") }}),
    pivoted as (
        select
            o_orderkey,
            {%- set ship_modes = [
                "TRUCK",
                "AIR",
                "RAIL",
                "SHIP",
                "MAIL",
                "FOB",
                "REG AIR",
            ] -%}
            {% for ship_mode in ship_modes %}
                sum(
                    case
                        when l_shipmode = '{{ ship_mode }}' then l_extendedprice else 0
                    end
                ) as "{{ ship_mode }}_total"
                {%- if not loop.last -%}, {%- endif -%}
            {% endfor %}
        from orders
        group by 1
    )

select *
from pivoted
