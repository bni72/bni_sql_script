PROC_MONITORING_USER_SESSION
----------------------------

create or replace PROCEDURE PROC_MONITORING_USER_SESSION(IN_FLAG_MODE IN VARCHAR2 DEFAULT 'WORK')
IS


VAR_IN_FLAG_MODE VARCHAR2(10);
VAR_IN_FLAG_MODE_TO_TABLE VARCHAR2(32);
---
VAR_COUNTER INTEGER;
VAR_MESSAGE_EMAIL VARCHAR(256);


BEGIN


--TABLE
-------
--DB."MONITORING_USER_SESSION"
---
--PROCESSED_DATE
--PROCESSED_DATETIME
--USER_ROLE
--USER_SESSION_NUM
--MESSAGE_EMAIL
--PARAM_IN_FLAG_MODE


VAR_MESSAGE_EMAIL:='';


-- For ID
--SELECT COUNT("ID") INTO VAR_COUNTER FROM DB."MONITORING_USER_SESSION";
--IF VAR_COUNTER = 0 THEN
--    VAR_COUNTER:=1;
--ELSE
--    SELECT MAX("ID") INTO VAR_COUNTER FROM DB."MONITORING_USER_SESSION";
--    VAR_COUNTER:=VAR_COUNTER+1;
--END IF;


-- Use mode of PROCESSing
IF (IN_FLAG_MODE != 'WORK') AND (IN_FLAG_MODE != 'TEST') THEN -- ??? NULL
    VAR_IN_FLAG_MODE:='WORK';
    VAR_IN_FLAG_MODE_TO_TABLE:=CONCAT(VAR_IN_FLAG_MODE,CONCAT('=',IN_FLAG_MODE));
ELSE
    VAR_IN_FLAG_MODE:=IN_FLAG_MODE;
    VAR_IN_FLAG_MODE_TO_TABLE:=VAR_IN_FLAG_MODE;
END IF;
CASE VAR_IN_FLAG_MODE
-- Mode=WORK
WHEN 'WORK'
THEN NULL;
---
-- Mode=TEST
WHEN 'TEST'
THEN NULL;
---
-- Mode=DEFAULT
ELSE NULL;
END CASE;


-- INSERT
INSERT INTO DB."MONITORING_USER_SESSION" 
( 
"PROCESSED_DATE" 
,"PROCESSED_DATETIME" 
,"USER_ROLE" 
,"USER_SESSION_NUM" 
,"MESSAGE_EMAIL" 
,"PARAM_IN_FLAG_MODE" 
) 
SELECT 
session_date 
, SYSDATE 
, 'Все' 
, COUNT(*) 
, VAR_MESSAGE_EMAIL 
, VAR_IN_FLAG_MODE_TO_TABLE 
FROM 
( 
    SELECT DISTINCT 
    TO_DATE(SYSDATE-1, 'DD.MM.YYYY') AS session_date 
    , COUNT(*) 
    , c."Name" 
    FROM "SysUserSession" sus 
    INNER JOIN "Contact" c ON sus."CreatedById" = c."Id" 
    INNER JOIN "SysAdminUnit" sau ON sau."ContactId" = c."Id" 
    INNER JOIN "SysUserInRole" suir ON sau."Id" = suir."SysUserId" 
    INNER JOIN "SysAdminUnit" sau1 ON suir."SysRoleId" = sau1."Id" 
    WHERE 1=1 
    AND sus."CreatedOn" > TO_DATE(SYSDATE-1, 'DD.MM.YYYY') 
    AND sus."CreatedOn" < TO_DATE(SYSDATE, 'DD.MM.YYYY') 
    AND suir."SysRoleId" NOT IN 
    ( 
        '{071A6732-783C-4F6E-93D4-3AB16816295C}' --Вик 
    ) 
    GROUP BY sau1."Name", c."Name", TO_DATE(SYSDATE-1, 'DD.MM.YYYY') 
) 
GROUP BY session_date 
;
COMMIT 
;


-- INSERT
INSERT INTO DB."MONITORING_USER_SESSION" 
( 
"PROCESSED_DATE" 
,"PROCESSED_DATETIME" 
,"USER_ROLE" 
,"USER_SESSION_NUM" 
,"MESSAGE_EMAIL" 
,"PARAM_IN_FLAG_MODE" 
) 
SELECT 
session_date 
, SYSDATE 
, 'Вик' 
, COUNT(*) 
, VAR_MESSAGE_EMAIL 
, VAR_IN_FLAG_MODE_TO_TABLE 
FROM 
( 
    SELECT DISTINCT 
    TO_DATE(SYSDATE-1, 'DD.MM.YYYY') AS session_date 
    , COUNT(*) 
    , c."Name" 
    FROM "SysUserSession" sus 
    INNER JOIN "Contact" c ON sus."CreatedById" = c."Id" 
    INNER JOIN "SysAdminUnit" sau ON sau."ContactId" = c."Id" 
    INNER JOIN "SysUserInRole" suir ON sau."Id" = suir."SysUserId" 
    INNER JOIN "SysAdminUnit" sau1 ON suir."SysRoleId" = sau1."Id"
    WHERE 1=1 
    AND sus."CreatedOn" > TO_DATE(SYSDATE-1, 'DD.MM.YYYY') 
    AND sus."CreatedOn" < TO_DATE(SYSDATE, 'DD.MM.YYYY') 
    AND suir."SysRoleId" IN 
    ( 
        '{071A6732-783C-4F6E-93D4-3AB16816295C}' --Вик 
    ) 
    GROUP BY sau1."Name", c."Name", TO_DATE(SYSDATE-1, 'DD.MM.YYYY') 
) 
GROUP BY session_date 
;
COMMIT 
;


END PROC_MONITORING_USER_SESSION;

