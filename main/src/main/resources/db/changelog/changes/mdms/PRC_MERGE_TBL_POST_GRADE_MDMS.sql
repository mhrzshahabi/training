create PROCEDURE PRC_MERGE_TBL_POST_GRADE_MDMS AS
BEGIN
    ------------UPDATE-------------------------------------------------------
MERGE INTO TBL_POST_GRADE T
    USING (
        (SELECT MDMS_POST_GRADE.C_CODE        AS MDMS_C_CODE,
                MDMS_POST_GRADE.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
                MDMS_POST_GRADE.C_TITLE_FA    AS MDMS_C_TITLE_FA,
                TR_POST_GRADE.C_CODE          AS TR_C_CODE,
                TR_POST_GRADE.C_PEOPLE_TYPE   AS TR_C_PEOPLE_TYPE,
                TR_POST_GRADE.C_TITLE_FA      AS TR_C_TITLE_FA
         FROM (
                  SELECT C_CODE,
                         C_PEOPLE_TYPE,
                         NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE_FA
                  FROM TBL_MD_POST_GRADE_MDMS
                  WHERE c_code is not null
              ) MDMS_POST_GRADE
                  INNER JOIN TBL_POST_GRADE TR_POST_GRADE
                             ON (MDMS_POST_GRADE.C_CODE = TR_POST_GRADE.C_CODE AND MDMS_POST_GRADE.C_PEOPLE_TYPE = TR_POST_GRADE.C_PEOPLE_TYPE)
         WHERE TR_POST_GRADE.C_TITLE_FA <> MDMS_POST_GRADE.C_TITLE_FA
            OR TR_POST_GRADE.C_PEOPLE_TYPE <> MDMS_POST_GRADE.C_PEOPLE_TYPE
            OR (TR_POST_GRADE.C_PEOPLE_TYPE IS NULL
             AND MDMS_POST_GRADE.C_PEOPLE_TYPE IS NOT NULL)
            OR (TR_POST_GRADE.C_PEOPLE_TYPE IS NOT NULL
             AND MDMS_POST_GRADE.C_PEOPLE_TYPE IS NULL)
        )
    ) CHANGES_
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
MERGE INTO TBL_POST_GRADE T
    USING (
        SELECT MDMS_POST_GRADE.C_CODE        AS MDMS_C_CODE,
               MDMS_POST_GRADE.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
               MDMS_POST_GRADE.C_TITLE_FA    AS MDMS_C_TITLE_FA
        FROM (
                 SELECT C_CODE,
                        C_PEOPLE_TYPE,
                        NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE_FA
                 FROM TBL_MD_POST_GRADE_MDMS
                 WHERE
                     c_code is NOT null) MDMS_POST_GRADE
                 LEFT JOIN TBL_POST_GRADE TR_POST_GRADE
                           ON (MDMS_POST_GRADE.C_CODE = TR_POST_GRADE.C_CODE AND MDMS_POST_GRADE.C_PEOPLE_TYPE = TR_POST_GRADE.C_PEOPLE_TYPE)
        WHERE TR_POST_GRADE.ID IS NULL) NEW_
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
            VALUES (SEQ_POST_GRADE_ID.NEXTVAL,
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

