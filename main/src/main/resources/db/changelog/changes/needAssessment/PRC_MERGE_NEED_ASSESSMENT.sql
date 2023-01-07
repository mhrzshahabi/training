create PROCEDURE PRC_MERGE_NEED_ASSESSMENT AS

BEGIN
    ------------NEEDASSESSMENT-------------------------------------------------------

BEGIN
MERGE
    INTO    tbl_needs_assessment trg
        USING   (
            SELECT

                tbl_needs_assessment.id as rid ,
                tbl_training_post.c_code AS postcode,
                tbl_training_post.c_title_fa AS postName,
                tbl_needs_assessment.c_object_code

            FROM
                tbl_needs_assessment
                    INNER JOIN tbl_training_post ON tbl_needs_assessment.f_object = tbl_training_post.id
            WHERE
                tbl_needs_assessment.c_object_code != tbl_training_post.c_code
    AND tbl_needs_assessment.c_object_type = 'TrainingPost'
        ) src
        ON      (trg.id = src.rid)
        WHEN MATCHED THEN UPDATE
            SET trg.c_object_code = src.postcode,
                trg.c_object_name = src.postName;
END;

    ------------NEEDASSESSMENTTEMP-------------------------------------------------------
BEGIN
MERGE
    INTO    tbl_needs_assessment_temp trg
        USING   (
            SELECT

                tbl_needs_assessment_temp.id as rid ,
                tbl_training_post.c_code AS postcode,
                tbl_training_post.c_title_fa AS postName,
                tbl_needs_assessment_temp.c_object_code

            FROM
                tbl_needs_assessment_temp
                    INNER JOIN tbl_training_post ON tbl_needs_assessment_temp.f_object = tbl_training_post.id
            WHERE
                tbl_needs_assessment_temp.c_object_code != tbl_training_post.c_code
    AND tbl_needs_assessment_temp.c_object_type = 'TrainingPost'
        ) src
        ON      (trg.id = src.rid)
        WHEN MATCHED THEN UPDATE
            SET trg.c_object_code = src.postcode,
                trg.c_object_name = src.postName;
END;

END;
/

