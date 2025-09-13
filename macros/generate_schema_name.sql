{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- set curr_env = env_var("DBT_ENV_NAME") -%}
    {%- if custom_schema_name is none or curr_env == 'DEV'-%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}