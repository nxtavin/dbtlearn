{% macro cents_to_dollars(col_name,round = 2) %}
    round(({{ col_name }} / 100.0),{{round}})
{% endmacro %}