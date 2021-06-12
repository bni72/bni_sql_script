--SELECT
------

-- Report Sessions Yesterday


--- Report
SELECT DISTINCT
mus.processed_date 
, mus.processed_datetime 
, mus.user_role 
, mus.user_session_num 
FROM "MONITORING_USER_SESSION" mus 
INNER JOIN 
( 
SELECT MAX(mus1.processed_datetime) AS max_date 
FROM "MONITORING_USER_SESSION" mus1 
WHERE 1=1 
AND mus1.processed_date = TO_DATE(SYSDATE-1,'DD.MM.YYYY') 
AND mus1.user_role IN ('Вик', 'Все') 
GROUP BY mus1.user_role, mus1.processed_date 
) mus2 
ON mus2.max_date = mus.processed_datetime 
;

