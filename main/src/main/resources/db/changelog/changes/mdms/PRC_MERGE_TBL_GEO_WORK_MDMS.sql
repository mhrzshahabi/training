create PROCEDURE PRC_MERGE_TBL_GEO_WORK_MDMS AS
BEGIN
    ------------UPDATE-------------------------------------------------------
MERGE INTO TBL_GEO_WORK T
    USING (
        SELECT MDMS_GEO_WORK.C_CODE        AS MDMS_C_CODE,
               MDMS_GEO_WORK.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
               MDMS_GEO_WORK.C_TITLE    AS MDMS_C_TITLE_FA,
               TR_GEO_WORK.C_CODE          AS TR_C_CODE,
               TR_GEO_WORK.C_PEOPLE_TYPE   AS TR_C_PEOPLE_TYPE,
               TR_GEO_WORK.C_TITLE         AS TR_C_TITLE_FA
        FROM (SELECT C_CODE,
                     C_PEOPLE_TYPE,
                     NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE
              FROM TBL_MD_GEO_WORK_MDMS) MDMS_GEO_WORK
                 INNER JOIN TBL_GEO_WORK TR_GEO_WORK
                            ON (MDMS_GEO_WORK.C_CODE = TR_GEO_WORK.C_CODE AND
                                MDMS_GEO_WORK.C_PEOPLE_TYPE = TR_GEO_WORK.C_PEOPLE_TYPE)
        WHERE TR_GEO_WORK.C_TITLE <> MDMS_GEO_WORK.C_TITLE
    ) CHANGES_
    ON (CHANGES_.MDMS_C_CODE = T.C_CODE AND CHANGES_.MDMS_C_PEOPLE_TYPE = T.C_PEOPLE_TYPE)
    WHEN MATCHED THEN
        UPDATE
            SET T.C_TITLE         = MDMS_C_TITLE_FA;
    --------------INSERT-----------------------------------------------------
MERGE INTO TBL_GEO_WORK T
    USING (
        SELECT MDMS_GEO_WORK.C_CODE        AS MDMS_C_CODE,
               MDMS_GEO_WORK.C_PEOPLE_TYPE AS MDMS_C_PEOPLE_TYPE,
               MDMS_GEO_WORK.C_TITLE_FA    AS MDMS_C_TITLE_FA
        FROM (
                 SELECT C_CODE,
                        C_PEOPLE_TYPE,
                        NVL(C_TITLE, 'NULL_' || C_CODE) AS C_TITLE_FA
                 FROM TBL_MD_GEO_WORK_MDMS
                 where c_code is not null
             ) MDMS_GEO_WORK
                 LEFT JOIN TBL_GEO_WORK TR_GEO_WORK
                           ON (MDMS_GEO_WORK.C_CODE = TR_GEO_WORK.C_CODE AND
                               MDMS_GEO_WORK.C_PEOPLE_TYPE = TR_GEO_WORK.C_PEOPLE_TYPE)
        WHERE TR_GEO_WORK.ID IS NULL

    ) NEW_
    ON (NEW_.MDMS_C_CODE = T.C_CODE AND NEW_.MDMS_C_PEOPLE_TYPE = T.C_PEOPLE_TYPE)
    WHEN NOT MATCHED THEN
        INSERT (ID,
                C_CODE,
                C_TITLE,
                C_PEOPLE_TYPE)
            VALUES (SEQ_POST_GRADE_ID.NEXTVAL,
                    NEW_.MDMS_C_CODE,
                    NEW_.MDMS_C_TITLE_FA,
                    NEW_.MDMS_C_PEOPLE_TYPE);
END;
/

