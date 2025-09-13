{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = target.database -%}
    {%- set curr_env = env_var("DBT_ENV_NAME") -%}
    {%- if custom_database_name is none -%}

        {{ default_database }}_{{ curr_env }}

    {%- else -%}

        {{ custom_database_name | trim }}_{{ curr_env }}

    {%- endif -%}

{%- endmacro %}