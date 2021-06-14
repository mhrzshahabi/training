
create table TBL_MDMS_PRC_LOG
(
    ID         NUMBER not null
        constraint TBL_MDMS_PRC_LOG_PK
            primary key,
    DATE_      DATE,
    LOG_MSG    NVARCHAR2(500),
    TABLE_NAME NVARCHAR2(500)
);
/


create sequence SEQ_GEO_WORK_ID increment by 1;
create sequence SEQ_DEPARTMENT_ID increment by 1;
create sequence SEQ_JOB_ID increment by 1;
create sequence SEQ_PERSONAL_ID increment by 1;
create sequence SEQ_POST_ID increment by 1;
create sequence SEQ_POST_GRADE_ID increment by 1;

declare
        next_ID number;
begin

    begin
        select max(id) into next_ID from TBL_GEO_WORK;
        execute immediate 'alter sequence  SEQ_GEO_WORK_ID increment by ' || next_ID;
        select SEQ_GEO_WORK_ID.nextval into next_ID from dual;
        execute immediate 'alter sequence SEQ_GEO_WORK_ID increment by 1';
        select SEQ_GEO_WORK_ID.nextval into next_ID from dual;
    end;

    begin
        select max(id) into next_ID from TBL_DEPARTMENT;
        execute immediate 'alter sequence  SEQ_DEPARTMENT_ID increment by ' || next_ID;
        select SEQ_DEPARTMENT_ID.nextval into next_ID from dual;
        execute immediate 'alter sequence SEQ_DEPARTMENT_ID increment by 1';
        select SEQ_DEPARTMENT_ID.nextval into next_ID from dual;
    end;

    begin
        select max(id) into next_ID from TBL_JOB;
        execute immediate 'alter sequence  SEQ_JOB_ID increment by ' || next_ID;
        select SEQ_JOB_ID.nextval into next_ID from dual;
        execute immediate 'alter sequence SEQ_JOB_ID increment by 1';
        select SEQ_JOB_ID.nextval into next_ID from dual;
    end;

    begin
        select max(id) into next_ID from  TBL_PERSONNEL;
        execute immediate 'alter sequence  SEQ_PERSONAL_ID increment by ' || next_ID;
        select SEQ_PERSONAL_ID.nextval into next_ID from dual;
        execute immediate 'alter sequence SEQ_PERSONAL_ID increment by 1';
        select SEQ_PERSONAL_ID.nextval into next_ID from dual;
    end;

    begin
        select max(id) into next_ID from  TBL_POST;
        execute immediate 'alter sequence  SEQ_POST_ID increment by ' || next_ID;
        select SEQ_POST_ID.nextval into next_ID from dual;
        execute immediate 'alter sequence SEQ_POST_ID increment by 1';
        select SEQ_POST_ID.nextval into next_ID from dual;
    end;

    begin
        select max(id) into next_ID from  TBL_POST_GRADE;
        execute immediate 'alter sequence  SEQ_POST_GRADE_ID increment by ' || next_ID;
        select SEQ_POST_GRADE_ID.nextval into next_ID from dual;
        execute immediate 'alter sequence SEQ_POST_GRADE_ID increment by 1';
        select SEQ_POST_GRADE_ID.nextval into next_ID from dual;
    end;


end;


