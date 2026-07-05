{{   
    config(
        materialized = 'incremental',
        on_schema_change = 'fail',
        event_time = 'comment_id'
    )
}}

WITH src_airport_comments AS (
    SELECT * FROM {{ ref('src_airport_comments') }}  
)

SELECT
  comment_id,
  airport_ident,
  comment_timestamp,
  NVL(member_nickname, '__UNKNOWN__') AS member_nickname,
  comment_subject,
  comment_body,
  current_timestamp() as loaded_at
  
FROM src_airport_comments
WHERE comment_body is not null
  AND TRIM(comment_body) <> ''

{% if is_incremental() %}
    {% set result = run_query("select max(comment_id) as max_comment_id from " ~ this) %}
    {% set max_comment_id = result.columns[0].values()[0] %}
    AND comment_id > {{ max_comment_id }}
    {{ log('Loading ' ~ this ~ ' incrementally (loading all missing comments where comment_id > ' ~ max_comment_id ~ ')', info=True) }}
{% endif %}
