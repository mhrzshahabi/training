create PROCEDURE PRC_MERGE_TBL_CONTACT_INFO_MDMS AS
BEGIN
-------------------------- NEW CONTACT-INFOS ---------------------------------------------------------------------------

    DECLARE
        CURSOR NEW_PERSONNELS IS SELECT ID, F_CONTACT_INFO
                                 FROM TBL_PERSONNEL
                                 WHERE F_CONTACT_INFO IS NULL FOR UPDATE OF F_CONTACT_INFO;
        NEXT_ID NUMBER;
    BEGIN
        FOR P IN NEW_PERSONNELS
            LOOP
                SELECT SEQ_CONTACT_INFO_ID.nextval INTO NEXT_ID FROM DUAL;
                INSERT INTO TBL_CONTACT_INFO(ID, C_CREATED_BY, D_CREATED_DATE, N_VERSION)
                VALUES (NEXT_ID, 'PRC_MERGE(NEW PERSONNEL)', SYSDATE, 0);
                UPDATE TBL_PERSONNEL SET F_CONTACT_INFO = NEXT_ID WHERE CURRENT OF NEW_PERSONNELS;
            END LOOP;
    END;

    DECLARE
        CURSOR NEW_PERSONNELS IS SELECT ID, F_CONTACT_INFO
                                 FROM TBL_PERSONNEL_REGISTERED
                                 WHERE F_CONTACT_INFO IS NULL FOR UPDATE OF F_CONTACT_INFO;
        NEXT_ID NUMBER;
    BEGIN
        FOR P IN NEW_PERSONNELS
            LOOP
                SELECT SEQ_CONTACT_INFO_ID.nextval INTO NEXT_ID FROM DUAL;
                INSERT INTO TBL_CONTACT_INFO(ID, C_CREATED_BY, D_CREATED_DATE, N_VERSION)
                VALUES (NEXT_ID, 'PRC_MERGE(NEW PERSONNEL_REGISTERED)', SYSDATE, 0);
                UPDATE TBL_PERSONNEL_REGISTERED SET F_CONTACT_INFO = NEXT_ID WHERE CURRENT OF NEW_PERSONNELS;
            END LOOP;
    END;


--------------------------- TBL_PERSONNEL ------------------------------------------------------------------------------
MERGE INTO TBL_CONTACT_INFO TR_CONTACT_INFO USING (
    SELECT TR_PRS.F_CONTACT_INFO,C_NATIONAL_CODE,
           MDMS_CONTACT_INFO.C_MOBILE,
           MDMS_CONTACT_INFO.C_EMAIL
    FROM (
             SELECT NVL(E.C_MOBILE, P.C_MOBILE) AS C_MOBILE,
                    NVL(E.C_EMAIL, P.C_EMAIL) AS C_EMAIL,
                    P.C_NATIONAL_CODE
             FROM TBL_MD_PEOPLE_MDMS     P
                      FULL OUTER JOIN (SELECT C_EMAIL,C_MOBILE,C_NATIONAL_CODE
                                       FROM (
                                                SELECT E.*,
                                                       ROW_NUMBER() OVER (PARTITION BY E.C_PEOPLE_ID
                                          ORDER BY C_ID DESC) AS INX
                                                FROM   TBL_MD_EMPLOYEE_MDMS E
                                            )
                                       WHERE INX = 1
             ) E ON E.C_NATIONAL_CODE = P.C_NATIONAL_CODE
         ) MDMS_CONTACT_INFO
             INNER JOIN (SELECT F_CONTACT_INFO,NATIONAL_CODE FROM TBL_PERSONNEL WHERE DELETED = 0 AND NATIONAL_CODE IS NOT NULL)TR_PRS  ON  TR_PRS.NATIONAL_CODE = MDMS_CONTACT_INFO.C_NATIONAL_CODE) MDMS_CONTACT_INFO
    ON(MDMS_CONTACT_INFO.F_CONTACT_INFO = TR_CONTACT_INFO.ID)
    WHEN MATCHED THEN UPDATE SET C_MDMS_MOBILE = MDMS_CONTACT_INFO.C_MOBILE, C_EMAIL = MDMS_CONTACT_INFO.C_EMAIL , D_LAST_MODIFIED_DATE = SYSDATE , C_LAST_MODIFIED_BY = 'HR';

--------------------------- TBL_PERSONNEL_REGISTERED -------------------------------------------------------------------
MERGE INTO TBL_CONTACT_INFO TR_CONTACT_INFO USING (
    SELECT TR_PRS.F_CONTACT_INFO,C_NATIONAL_CODE,
           MDMS_CONTACT_INFO.C_MOBILE,
           MDMS_CONTACT_INFO.C_EMAIL
    FROM (
             SELECT NVL(E.C_MOBILE, P.C_MOBILE) AS C_MOBILE,
                    NVL(E.C_EMAIL, P.C_EMAIL) AS C_EMAIL,
                    P.C_NATIONAL_CODE
             FROM TBL_MD_PEOPLE_MDMS     P
                      FULL OUTER JOIN (SELECT C_EMAIL,C_MOBILE,C_NATIONAL_CODE
                                       FROM (
                                                SELECT E.*,
                                                       ROW_NUMBER() OVER (PARTITION BY E.C_PEOPLE_ID
                                          ORDER BY C_ID DESC) AS INX
                                                FROM   TBL_MD_EMPLOYEE_MDMS E
                                            )
                                       WHERE INX = 1
             ) E ON E.C_NATIONAL_CODE = P.C_NATIONAL_CODE
         ) MDMS_CONTACT_INFO
             INNER JOIN (SELECT F_CONTACT_INFO,NATIONAL_CODE FROM TBL_PERSONNEL_REGISTERED WHERE NATIONAL_CODE IS NOT NULL)TR_PRS  ON  TR_PRS.NATIONAL_CODE = MDMS_CONTACT_INFO.C_NATIONAL_CODE) MDMS_CONTACT_INFO
    ON(MDMS_CONTACT_INFO.F_CONTACT_INFO = TR_CONTACT_INFO.ID)
    WHEN MATCHED THEN UPDATE SET C_MDMS_MOBILE = MDMS_CONTACT_INFO.C_MOBILE, C_EMAIL = MDMS_CONTACT_INFO.C_EMAIL , D_LAST_MODIFIED_DATE = SYSDATE , C_LAST_MODIFIED_BY = 'HR';

END;
/

