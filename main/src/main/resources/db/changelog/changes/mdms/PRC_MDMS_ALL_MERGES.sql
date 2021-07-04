create PROCEDURE PRC_MDMS_ALL_MERGES AS
BEGIN
    DECLARE
        err_code VARCHAR2(30);
        err_msg  VARCHAR2(500);
    BEGIN
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_DUPLICATED_ROW_CHECK_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg);
                    commit;
                    raise;
        END;
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_MERGE_TBL_DEPARTMENT_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG, TABLE_NAME)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg, 'TBL_DEPARTMENT');
                    commit;
                    raise;
        END;
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_MERGE_TBL_GEO_WORK_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG, TABLE_NAME)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg, 'TBL_GEO_WORK');
                    commit;
                    raise;
        END;
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_MERGE_TBL_JOB_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG, TABLE_NAME)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg, 'TBL_JOB_WORK');
                    commit;
                    raise;
        END;
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_MERGE_TBL_POST_GRADE_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG, TABLE_NAME)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg, 'TBL_POST_GRADE');
                    commit;
                    raise;
        END;
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_MERGE_TBL_PERSONNEL_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG, TABLE_NAME)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg, 'TBL_PERSONNEL');
                    commit;
                    raise;
        END;
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_MERGE_TBL_POST_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG, TABLE_NAME)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg, 'TBL_POST');
                    commit;
                    raise;
        END;
        ----------------------------------------------------------------------------------------------------------------
        BEGIN
            PRC_MERGE_TBL_CONTACT_INFO_MDMS();
        EXCEPTION
            WHEN OTHERS
                THEN
                    err_code := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    insert into TBL_MDMS_PRC_LOG(id, DATE_, LOG_MSG, TABLE_NAME)
                    values (SEQ_MDMS_PRC_LOG_ID.nextval, sysdate, err_msg, 'TBL_CONTACT_INFO');
                    commit;
                    raise;
        END;
    END;
END;
/

