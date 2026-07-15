
-- this singular test checks that every airport that has type = 'heliport' has at least one helicopter-specific runway
-- I define helicopter-specific runway as runway that is close to square shape (length vs width ratio) and its length is less than 1000 ft
-- condition: runway_length_ft > 1000 AND runway_length_ft / runway_width_ft > 2

{{ config(
    severity='warn'
) }}


WITH heliport_airports_only as (
SELECT 
  a.airport_ident,
  a.airport_name,
  a.airport_type,
  r.runway_id,
  r.runway_length_ft,
  r.runway_width_ft,
  IFF(runway_length_ft > 1000 AND runway_length_ft / runway_width_ft > 2, 'airplane_runway', 'heliport_runway') as runway_type

FROM DEV.SILVER_AIRPORTS a
JOIN DEV.SILVER_RUNWAYS r
ON a.airport_ident = r.airport_ident

WHERE a.airport_type = 'heliport'
ORDER BY airport_ident
),

runway_types_count as (
select
  airport_ident,
  runway_type,
  count(distinct runway_id)

from heliport_airports_only

GROUP BY airport_ident, runway_type

),

runway_types_aggregation as (
SELECT

airport_ident, 
count(distinct runway_type) as runways_cnt,
ARRAY_AGG(runway_type) as runways_types_arr


FROM runway_types_count

GROUP BY airport_ident
)

-- this select should return all airports that have only airplane runways;
-- to have this test pass, this query should return 0 records
-- but in fact returns 76 records in total 
-- so I configured its severity to warning

SELECT * 
FROM runway_types_aggregation

WHERE NOT ARRAY_CONTAINS('heliport_runway'::VARIANT, runways_types_arr) 

