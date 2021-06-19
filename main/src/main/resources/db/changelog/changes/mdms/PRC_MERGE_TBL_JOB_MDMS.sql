create PROCEDURE PRC_MERGE_TBL_JOB_MDMS AS
BEGIN
    ------------UPDATE-------------------------------------------------------
    MERGE INTO TBL_JOB T
    USING
        (SELECT MDMS_JOB.C_CODE        AS MDMS_C_CODE,
                MDMS_JOB.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
                MDMS_JOB.E_ENABLED     AS MDMS_E_ENABLED,
                MDMS_JOB.E_DELETED     AS MDMS_E_DELETED,
                MDMS_JOB.C_TITLE_FA    AS MDMS_C_TITLE_FA,
                TR_JOB.C_CODE          AS TR_C_CODE,
                TR_JOB.C_PEOPLE_TYPE   AS TR_C_PEOPLE_TYPE,
                TR_JOB.E_ENABLED       AS TR_E_ENABLED,
                TR_JOB.E_DELETED       AS TR_E_DELETED,
                TR_JOB.C_TITLE_FA      AS TR_C_TITLE_FA
         FROM (
                  SELECT C_CODE,
                         C_PEOPLE_TYPE,
                         NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE_FA,
                         CASE
                             WHEN C_ACTIVE = 1 THEN
                                 NULL
                             WHEN C_ACTIVE = 0 THEN
                                 74
                             END                         AS E_ENABLED,
                         CASE
                             WHEN C_DELETED = 1 THEN
                                 75
                             WHEN C_DELETED = 0 THEN
                                 NULL
                             END                         AS E_DELETED
                  FROM MDMS_TBL_MD_JOB) MDMS_JOB
                  INNER JOIN TBL_JOB TR_JOB
                             ON (MDMS_JOB.C_CODE = TR_JOB.C_CODE AND MDMS_JOB.C_PEOPLE_TYPE = TR_JOB.C_PEOPLE_TYPE)
         WHERE TR_JOB.C_TITLE_FA <> MDMS_JOB.C_TITLE_FA
            OR TR_JOB.E_ENABLED <> MDMS_JOB.E_ENABLED
            OR TR_JOB.E_DELETED <> MDMS_JOB.E_DELETED)
     CHANGES_
    ON (CHANGES_.MDMS_C_CODE = T.C_CODE AND CHANGES_.MDMS_C_PEOPLE_TYPE = T.C_PEOPLE_TYPE)
    WHEN MATCHED THEN
        UPDATE
        SET T.C_TITLE_FA         = MDMS_C_TITLE_FA,
            T.E_ENABLED          = MDMS_E_ENABLED,
            T.E_DELETED          = MDMS_E_DELETED,
            C_LAST_MODIFIED_BY   = 'CHARGOON',
            D_LAST_MODIFIED_DATE = SYSDATE,
            N_VERSION            = T.N_VERSION + 1;
    --------------INSERT-----------------------------------------------------
    MERGE INTO TBL_JOB T
    USING (
        SELECT MDMS_JOB.C_CODE        AS MDMS_C_CODE,
               MDMS_JOB.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
               MDMS_JOB.E_ENABLED     AS MDMS_E_ENABLED,
               MDMS_JOB.E_DELETED     AS MDMS_E_DELETED,
               MDMS_JOB.C_TITLE_FA    AS MDMS_C_TITLE_FA
        FROM (
                 SELECT C_CODE,
                        C_PEOPLE_TYPE,
                        NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE_FA,
                        CASE
                            WHEN C_ACTIVE = 1 THEN
                                NULL
                            WHEN C_ACTIVE = 0 THEN
                                74
                            END                         AS E_ENABLED,
                        CASE
                            WHEN C_DELETED = 1 THEN
                                75
                            WHEN C_DELETED = 0 THEN
                                NULL
                            END                         AS E_DELETED
                 FROM MDMS_TBL_MD_JOB) MDMS_JOB
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
                'CHARGOON',
                SYSDATE,
                NEW_.MDMS_E_ENABLED,
                NEW_.MDMS_E_DELETED,
                0,
                NEW_.MDMS_C_CODE,
                NEW_.MDMS_C_TITLE_FA,
                NEW_.MDMS_C_PEOPLE_TYPE);
END;
/

