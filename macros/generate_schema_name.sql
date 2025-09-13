{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- set curr_env = env_var("DBT_ENV_NAME") -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}
        {% if curr_env == 'DEV' %}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {% else %}
            {{ custom_schema_name | trim }}
        {% endif %}
        

    {%- endif -%}

{%- endmacro %}