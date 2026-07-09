WITH silver_airports_snapshots AS (
    SELECT * FROM {{ ref('scd_silver_airports') }}
)
SELECT * FROM silver_airports_snapshots WHERE AIRPORT_IDENT = '01CN'


-- run:
-- dbt compile

-- if compiled successfully, the compiled SQL will be stored in
-- target/compiled/airstats/analyses/la_heliport_closed.sql
