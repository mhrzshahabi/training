create PROCEDURE PRC_DUPLICATED_ROW_CHECK_MDMS AS
    BEGIN
    DECLARE
        DUPLICATED_ROWS VARCHAR2(300);
    BEGIN
        SELECT CASE
                   WHEN EXISTS(
                           SELECT C_CODE, C_PEOPLE_TYPE
                           FROM (SELECT * FROM DEV_MDMS.TBL_MD_JOB)
                           GROUP BY C_CODE, C_PEOPLE_TYPE
                           HAVING COUNT(*) > 1
                       ) THEN 'TBL_MD_JOB'
                   WHEN EXISTS(
                           SELECT C_CODE, C_PEOPLE_TYPE
                           FROM (SELECT * FROM DEV_MDMS.TBL_MD_POST_GRADE)
                           GROUP BY C_CODE, C_PEOPLE_TYPE
                           HAVING COUNT(*) > 1
                       ) THEN 'TBL_MD_POST_GRADE'
                   WHEN EXISTS(
                           SELECT C_CODE, C_PEOPLE_TYPE
                           FROM (SELECT * FROM DEV_MDMS.TBL_MD_GEO_WORK)
                           GROUP BY C_CODE, C_PEOPLE_TYPE
                           HAVING COUNT(*) > 1
                       ) THEN 'TBL_MD_GEO_WORK'
                   WHEN EXISTS(
                           SELECT C_CODE
                           FROM (SELECT * FROM DEV_MDMS.TBL_MD_DEPARTMENT)
                           GROUP BY C_CODE
                           HAVING COUNT(*) > 1
                       ) THEN 'TBL_MD_DEPARTMENT'
                   WHEN EXISTS(
                           SELECT C_CODE
                           FROM (SELECT * FROM DEV_MDMS.TBL_MD_POST)
                           GROUP BY C_CODE
                           HAVING COUNT(*) > 1
                       ) THEN 'TBL_MD_POST'
                   WHEN EXISTS(
                           SELECT C_NATIONAL_CODE
                           FROM (SELECT * FROM DEV_MDMS.VIW_EMPLOYEE)
                           GROUP BY C_NATIONAL_CODE
                           HAVING COUNT(*) > 1
                       ) THEN 'VIW_EMPLOYEE'
                   WHEN EXISTS(
                           SELECT NATIONAL_CODE
                           FROM (SELECT * FROM TBL_PERSONNEL where DELETED = 0 and active = 1)
                           GROUP BY NATIONAL_CODE
                           HAVING COUNT(*) > 1
                       ) THEN 'TRAINING.TBL_PERSONNEL'
                   ELSE NULL
                   END
        INTO DUPLICATED_ROWS
        FROM DUAL;
        IF DUPLICATED_ROWS IS NOT NULL
        THEN
            RAISE_APPLICATION_ERROR(-20001, DUPLICATED_ROWS || ' HAS DUPLICATED ROWS');
        END IF;
    END;
END;
/

