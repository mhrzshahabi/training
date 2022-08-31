create PROCEDURE PRC_MERGE_TBL_JOB_MDMS AS
BEGIN
    ------------UPDATE-------------------------------------------------------
MERGE INTO TBL_JOB T
    USING
        (SELECT MDMS_JOB.C_CODE        AS MDMS_C_CODE,
                MDMS_JOB.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
                MDMS_JOB.C_TITLE_FA    AS MDMS_C_TITLE_FA,
                TR_JOB.C_CODE          AS TR_C_CODE,
                TR_JOB.C_PEOPLE_TYPE   AS TR_C_PEOPLE_TYPE,
                TR_JOB.C_TITLE_FA      AS TR_C_TITLE_FA
         FROM (
                  SELECT C_CODE,
                         C_PEOPLE_TYPE,
                         NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE_FA
                  FROM TBL_MD_JOB_MDMS) MDMS_JOB
                  INNER JOIN TBL_JOB TR_JOB
                             ON (MDMS_JOB.C_CODE = TR_JOB.C_CODE AND MDMS_JOB.C_PEOPLE_TYPE = TR_JOB.C_PEOPLE_TYPE)
         WHERE TR_JOB.C_TITLE_FA <> MDMS_JOB.C_TITLE_FA)
            CHANGES_
    ON (CHANGES_.MDMS_C_CODE = T.C_CODE AND CHANGES_.MDMS_C_PEOPLE_TYPE = T.C_PEOPLE_TYPE)
    WHEN MATCHED THEN
        UPDATE
            SET T.C_TITLE_FA         = MDMS_C_TITLE_FA,
                T.E_ENABLED          = null,
                T.E_DELETED          = null,
                C_LAST_MODIFIED_BY   = 'HR',
                D_LAST_MODIFIED_DATE = SYSDATE,
                N_VERSION            = T.N_VERSION + 1;
    --------------INSERT-----------------------------------------------------
MERGE INTO TBL_JOB T
    USING (
        SELECT MDMS_JOB.C_CODE        AS MDMS_C_CODE,
               MDMS_JOB.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
               MDMS_JOB.C_TITLE_FA    AS MDMS_C_TITLE_FA
        FROM (
                 SELECT C_CODE,
                        C_PEOPLE_TYPE,
                        NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE_FA


                 FROM TBL_MD_JOB_MDMS
                 WHERE
                     c_code is not null) MDMS_JOB
                 LEFT JOIN TBL_JOB TR_JOB
                           ON (MDMS_JOB.C_CODE = TR_JOB.C_CODE AND MDMS_JOB.C_PEOPLE_TYPE = TR_JOB.C_PEOPLE_TYPE)
        WHERE TR_JOB.ID IS NULL) NEW_
    ON (NEW_.MDMS_C_CODE = T.C_CODE AND NEW_.MDMS_C_PEOPLE_TYPE = T.C_PEOPLE_TYPE)
    WHEN NOT MATCHED THEN
        INSERT (ID,
                C_CREATED_BY,
                D_CREATED_DATE,
                E_ENABLED,
                E_DELETED,
                N_VERSION,
                C_CODE,
                C_TITLE_FA,
                C_PEOPLE_TYPE)
            VALUES (SEQ_JOB_ID.NEXTVAL,
                    'HR',
                    SYSDATE,
                    null,
                    null,
                    0,
                    NEW_.MDMS_C_CODE,
                    NEW_.MDMS_C_TITLE_FA,
                    NEW_.MDMS_C_PEOPLE_TYPE);

END;
/

