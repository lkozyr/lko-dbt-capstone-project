-- this singular test will check that there is at least one open runway for each airport where airport type is not 'closed'
-- so if airport is operational, it should have at least one working runwayl;
-- the following sql query should return 0 records so that the test will pass;
-- if it returns more than 0 records, it means there are operational airports with 0 working runways, so the test will fail;



WITH operational_runways AS (
    SELECT
      DISTINCT a.airport_ident,
      count(distinct r.runway_id) as operational_runway_cnt

    FROM DEV.SILVER_AIRPORTS a
    JOIN DEV.SILVER_RUNWAYS r
    ON a.airport_ident = r.airport_ident

    WHERE a.airport_type <> 'closed'
    AND r.runway_closed = 0

    GROUP BY a.airport_ident
)

SELECT * FROM operational_runways
WHERE operational_runway_cnt = 0
LIMIT 10
