package com.nicico.training.repository;

import com.nicico.training.model.GenericStatisticalIndexReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GenericStatisticalIndexReportDAO extends JpaRepository<GenericStatisticalIndexReport, Long>, JpaSpecificationExecutor<GenericStatisticalIndexReport> {


    @Query(value = """
           --Report08 -nesbat nyazhaye amozeshi takhasosi
           
           SELECT rowNum AS id,
                  res.*
           FROM(     \s
           
            with kol as (
                         SELECT DISTINCT\s
                                     SUM(s.presence_hour)  over (partition by s.complex)    AS sum_kol_mojtama,\s
                                     SUM(s.presence_hour)  over (partition by s.assistant)   AS sum_kol_moavenat,\s
                                      SUM(s.presence_hour) over (partition by s.affairs)      AS sum_kol_omoor,\s
                                     s.affairs       AS omoor,
                                     s.assistant     AS moavenat,
                                     s.assistant_id  AS moavenat_id,\s
                                     s.affairs_id    AS omoor_id,
                                     s.complex_id    AS mojtama_id,
                                     s.complex       AS mojtama  \s
           
                                 FROM\s
                                     (\s
                                         SELECT\s
                                             class.id               AS class_id,\s
                                             tbl_student.id         AS student_id,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_hour,\s
                                               view_complex.id         AS complex_id,
                                               view_complex.c_title    AS complex,
                                               view_assistant.id       AS assistant_id,
                                               view_assistant.c_title  AS assistant,
                                               view_affairs.id         AS affairs_id,
                                               view_affairs.c_title    AS affairs
                                         FROM\s
                                             tbl_attendance att\s
                                             INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                             INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                             INNER JOIN
                                               (
                                                 select
                                                       tbl_student.id                                                         as id
                                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                                 \s
                                                  from tbl_student\s
                                                   LEFT JOIN view_last_md_employee_hr
                                                   ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                               )
                                               tbl_student  ON att.f_student = tbl_student.id
                                               RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                               RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                               RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                      where 1=1
                                            and class.C_START_DATE >=  :fromDate
                                            and class.C_START_DATE <=  :toDate
                                            and class.f_course IN (\s
                                                                      SELECT DISTINCT tbl_course.id\s
                                                                      FROM tbl_needs_assessment\s
                                                                               INNER JOIN tbl_skill ON tbl_needs_assessment.f_skill = tbl_skill.id\s
                                                                               INNER JOIN tbl_course ON tbl_skill.f_main_objective_course = tbl_course.id\s
                                                                      WHERE tbl_skill.e_deleted IS NULL\s
                                                                  )\s
                                          \s
                                         GROUP BY\s
                                             class.id,\s
                                             tbl_student.id,\s
                                              view_complex.id,
                                             view_complex.c_title,
                                             view_assistant.id,
                                             view_assistant.c_title,
                                             view_affairs.id,
                                             view_affairs.c_title
           
                                     ) s\s
                                 GROUP BY\s
                                     s.presence_hour,
                                     s.class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex
                                    \s
                    having  nvl(count( s.class_id) ,0)  !=0
                    ),
                  \s
                  takhasosi as(
                              SELECT DISTINCT\s
                                     SUM(s.presence_hour)  over (partition by s.complex)    AS sum_takhasosi_mojtama,\s
                                     SUM(s.presence_hour)  over (partition by s.assistant)  AS sum_takhasosi_moavenat,\s
                                     SUM(s.presence_hour)  over (partition by s.affairs)    AS sum_takhasosi_omoor,\s
                                     s.affairs       AS omoor,
                                     s.assistant     AS moavenat,
                                     s.assistant_id  AS moavenat_id,\s
                                     s.affairs_id    AS omoor_id,
                                     s.complex_id    AS mojtama_id,
                                     s.complex       AS mojtama  \s
           
                                 FROM\s
                                     (\s
                                         SELECT\s
                                             class.id               AS class_id,\s
                                             tbl_student.id         AS student_id,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_hour,\s
                                               view_complex.id         AS complex_id,
                                               view_complex.c_title    AS complex,
                                               view_assistant.id       AS assistant_id,
                                               view_assistant.c_title  AS assistant,
                                               view_affairs.id         AS affairs_id,
                                               view_affairs.c_title    AS affairs
                                         FROM\s
                                             tbl_attendance att\s
                                             INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                             INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                             INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                             INNER JOIN
                                               (
                                                 select
                                                       tbl_student.id                                                         as id
                                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                                 \s
                                                  from tbl_student\s
                                                   LEFT JOIN view_last_md_employee_hr
                                                   ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                               )
                                               tbl_student  ON att.f_student = tbl_student.id
                                               RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                               RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                               RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                      where 1=1
                                            and class.C_START_DATE >=  :fromDate
                                            and class.C_START_DATE <=  :toDate
           
                                            and  tbl_course.e_technical_type = 2 --takhasosi
                                            and class.f_course IN (\s
                                                                      SELECT DISTINCT tbl_course.id\s
                                                                      FROM tbl_needs_assessment\s
                                                                               INNER JOIN tbl_skill ON tbl_needs_assessment.f_skill = tbl_skill.id\s
                                                                               INNER JOIN tbl_course ON tbl_skill.f_main_objective_course = tbl_course.id\s
                                                                      WHERE tbl_skill.e_deleted IS NULL\s
                                                                  )\s
                                           \s
                                          \s
                                         GROUP BY\s
                                             class.id,\s
                                             tbl_student.id,\s
                                              view_complex.id,
                                             view_complex.c_title,
                                             view_assistant.id,
                                             view_assistant.c_title,
                                             view_affairs.id,
                                             view_affairs.c_title
           
                                     ) s\s
                                 GROUP BY\s
                                     s.presence_hour,
                                     s.class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex
           \s
                   )
                  \s
                   select DISTINCT
                  \s
                   kol.mojtama_id     as complex_id
                   ,kol.mojtama       as complex
                   ,max(cast ((takhasosi.sum_takhasosi_mojtama /kol.sum_kol_mojtama)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex
                  \s
                   , kol.moavenat_id  as assistant_id
                   , kol.moavenat     as assistant
                   ,max( cast ( (takhasosi.sum_takhasosi_moavenat /kol.sum_kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant
                  \s
                   ,kol.omoor_id     as affairs_id
                   ,kol.omoor        as affairs
                   ,max(cast ( (takhasosi.sum_takhasosi_omoor /kol.sum_kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs
                  \s
                   FROM
                   kol\s
                   LEFT JOIN  takhasosi
                   on
                    takhasosi.mojtama_id = kol.mojtama_id
                    and takhasosi.moavenat_id = kol.moavenat_id
                    and takhasosi.omoor_id = kol.omoor_id
                  \s
                   where 1=1
                         and (
                              kol.mojtama_id is not null
                              and kol.moavenat_id is not null
                              and kol.omoor_id is not null
                             )
                   \s
                   group by
                   kol.mojtama_id
                   ,kol.mojtama
                   ,takhasosi.sum_takhasosi_mojtama\s
                   ,takhasosi.sum_takhasosi_moavenat\s
                   ,takhasosi.sum_takhasosi_omoor\s
                   ,kol.sum_kol_mojtama
                   ,kol.sum_kol_moavenat
                   ,kol.sum_kol_omoor
                   ,kol.moavenat_id
                   ,kol.moavenat
                   ,kol.omoor_id
                   ,kol.omoor
           ) res
            where 1=1
                AND (:complexNull = 1 OR complex IN (:complex))\s
                AND (:assistantNull = 1 OR assistant IN (:assistant))\s
                AND (:affairsNull = 1 OR affairs IN (:affairs))\s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> getTechnicalTrainingNeeds(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);



    @Query(value = """
           --Report02- majmoe saate amozesh ejra shodeh
           
           SELECT
              rowNum AS id,\s
              res.*\s
           FROM (\s
                         SELECT DISTINCT\s
                             complex                      AS complex,\s
                             complex_id                   as complex_id,\s
                             SUM(sum_presence_hour)\s
                             OVER(PARTITION BY complex)   AS n_base_on_complex,\s
                             assistant                    AS assistant,\s
                             assistant_id                 as assistant_id,\s
                             SUM(sum_presence_hour)\s
                             OVER(PARTITION BY assistant) AS n_base_on_assistant,\s
                             affairs                      AS affairs,\s
                             affairs_id                   as affairs_id,\s
                             SUM(sum_presence_hour)\s
                             OVER(PARTITION BY affairs)   AS n_base_on_affairs\s
                         FROM\s
                             (\s
                                 SELECT DISTINCT\s
                                     SUM(s.presence_hour)   AS sum_presence_hour,\s
                                     SUM(s.presence_minute) AS sum_presence_minute,\s
                                     SUM(s.absence_hour)    AS sum_absence_hour,\s
                                     SUM(s.absence_minute)  AS sum_absence_minute,\s
                                     s.class_id             AS class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex,\s
                                     s.e_technical_type,\s
                                     s.c_end_date,\s
                                     s.c_start_date,\s
                                     CASE\s
                                         WHEN s.e_technical_type = '1' THEN\s
                                             'عمومی'\s
                                         WHEN s.e_technical_type = '2' THEN\s
                                             'تخصصی'\s
                                         WHEN s.e_technical_type = '3' THEN\s
                                             'مدیریتی'\s
                                     END                    AS technical_title\s
                                 FROM\s
                                     (\s
                                         SELECT\s
                                             class.id               AS class_id,\s
                                             tbl_student.id         AS student_id,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_hour,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24 * 60)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_minute,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('3', '4') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS absence_hour,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('3', '4') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24 * 60)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                        AS absence_minute,\s
                                               class.c_start_date,\s
                                               class.c_end_date,\s
                                               tbl_course.e_technical_type,\s
                                               view_complex.id         AS complex_id,
                                               view_complex.c_title    AS complex,
                                               view_assistant.id       AS assistant_id,
                                               view_assistant.c_title  AS assistant,
                                               view_affairs.id         AS affairs_id,
                                               view_affairs.c_title    AS affairs
           
           
                                         FROM\s
                                              tbl_attendance att\s
                                             INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                             INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                             INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                             INNER JOIN
                                               (
                                                 select
                                                       tbl_student.id                                                         as id
                                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                                 \s
                                                  from tbl_student\s
                                                   LEFT JOIN view_last_md_employee_hr
                                                   ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                               )
                                           tbl_student  ON att.f_student = tbl_student.id
                                           RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                           RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                           RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
           
                                         GROUP BY\s
                                             class.id,\s
                                             tbl_student.id,\s
                                             class.c_start_date,\s
                                             class.c_end_date,\s
                                             tbl_course.e_technical_type,\s
                                             view_complex.id,
                                             view_complex.c_title,
                                             view_assistant.id,
                                             view_assistant.c_title,
                                             view_affairs.id,
                                             view_affairs.c_title,
                                             csession.c_session_date,\s
                                             class.c_code\s
                                     ) s\s
                                 GROUP BY\s
                                     s.class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex,\s
                                     s.e_technical_type,\s
                                     s.c_end_date,\s
                                     s.c_start_date\s
                             )\s
           WHERE 1=1
                 AND c_start_date >= :fromDate\s
                 AND c_start_date <= :toDate
           \s
                 ) res
           WHERE 1=1
                 AND (:complexNull = 1 OR complex IN (:complex))\s
                 AND (:assistantNull = 1 OR assistant IN (:assistant))\s
                 AND (:affairsNull = 1 OR affairs IN (:affairs))
                \s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> getTotalHours(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);


    @Query(value = """
           --Report03 -saraneh anbasht sabeghe amozeshi omomi
           
           SELECT rowNum AS id,
                  res.*
           FROM(     \s
           
            with kol as (
                         SELECT DISTINCT\s
                                     SUM(s.presence_hour)  over (partition by s.complex)    AS sum_kol_mojtama,\s
                                     SUM(s.presence_hour)  over (partition by s.assistant)   AS sum_kol_moavenat,\s
                                      SUM(s.presence_hour) over (partition by s.affairs)      AS sum_kol_omoor,\s
                                     s.affairs       AS omoor,
                                     s.assistant     AS moavenat,
                                     s.assistant_id  AS moavenat_id,\s
                                     s.affairs_id    AS omoor_id,
                                     s.complex_id    AS mojtama_id,
                                     s.complex       AS mojtama  \s
           
                                 FROM\s
                                     (\s
                                         SELECT\s
                                             class.id               AS class_id,\s
                                             tbl_student.id         AS student_id,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_hour,\s
                                               view_complex.id         AS complex_id,
                                               view_complex.c_title    AS complex,
                                               view_assistant.id       AS assistant_id,
                                               view_assistant.c_title  AS assistant,
                                               view_affairs.id         AS affairs_id,
                                               view_affairs.c_title    AS affairs
                                         FROM\s
                                             tbl_attendance att\s
                                             INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                             INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                             INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                             INNER JOIN
                                               (
                                                 select
                                                       tbl_student.id                                                         as id
                                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                                 \s
                                                  from tbl_student\s
                                                   LEFT JOIN view_last_md_employee_hr
                                                   ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                               )
                                               tbl_student  ON att.f_student = tbl_student.id
                                               RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                               RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                               RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                      where 1=1
                                            and class.C_START_DATE >=  :fromDate
                                            and class.C_START_DATE <=  :toDate
                                          \s
                                         GROUP BY\s
                                             class.id,\s
                                             tbl_student.id,\s
                                              view_complex.id,
                                             view_complex.c_title,
                                             view_assistant.id,
                                             view_assistant.c_title,
                                             view_affairs.id,
                                             view_affairs.c_title
           
                                     ) s\s
                                 GROUP BY\s
                                     s.presence_hour,
                                     s.class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex
                                    \s
                    having  nvl(count( s.class_id) ,0)  !=0
                    ),
                  \s
                  omomi as(
                              SELECT DISTINCT\s
                                     SUM(s.presence_hour)  over (partition by s.complex)    AS sum_omomi_mojtama,\s
                                     SUM(s.presence_hour)  over (partition by s.assistant)  AS sum_omomi_moavenat,\s
                                     SUM(s.presence_hour)  over (partition by s.affairs)    AS sum_omomi_omoor,\s
                                     s.affairs       AS omoor,
                                     s.assistant     AS moavenat,
                                     s.assistant_id  AS moavenat_id,\s
                                     s.affairs_id    AS omoor_id,
                                     s.complex_id    AS mojtama_id,
                                     s.complex       AS mojtama  \s
           
                                 FROM\s
                                     (\s
                                         SELECT\s
                                             class.id               AS class_id,\s
                                             tbl_student.id         AS student_id,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_hour,\s
                                               view_complex.id         AS complex_id,
                                               view_complex.c_title    AS complex,
                                               view_assistant.id       AS assistant_id,
                                               view_assistant.c_title  AS assistant,
                                               view_affairs.id         AS affairs_id,
                                               view_affairs.c_title    AS affairs
                                         FROM\s
                                             tbl_attendance att\s
                                             INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                             INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                             INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                             INNER JOIN
                                               (
                                                 select
                                                       tbl_student.id                                                         as id
                                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                                 \s
                                                  from tbl_student\s
                                                   LEFT JOIN view_last_md_employee_hr
                                                   ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                               )
                                               tbl_student  ON att.f_student = tbl_student.id
                                               RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                               RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                               RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                      where 1=1
                                            and  tbl_course.e_technical_type = 1 --omomi
                                            and class.C_START_DATE >= :fromDate
                                            and class.C_START_DATE <= :toDate
                                          \s
                                         GROUP BY\s
                                             class.id,\s
                                             tbl_student.id,\s
                                              view_complex.id,
                                             view_complex.c_title,
                                             view_assistant.id,
                                             view_assistant.c_title,
                                             view_affairs.id,
                                             view_affairs.c_title
           
                                     ) s\s
                                 GROUP BY\s
                                     s.presence_hour,
                                     s.class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex
           \s
                   )
                  \s
                   select DISTINCT
                  \s
                   kol.mojtama_id     as complex_id
                   ,kol.mojtama       as complex
                   ,max(cast ((omomi.sum_omomi_mojtama /kol.sum_kol_mojtama) as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex
                  \s
                   , kol.moavenat_id  as assistant_id
                   , kol.moavenat     as assistant
                   ,max( cast ( (omomi.sum_omomi_moavenat /kol.sum_kol_moavenat) as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant
                  \s
                   ,kol.omoor_id     as affairs_id
                   ,kol.omoor        as affairs
                   ,max(cast ( (omomi.sum_omomi_omoor /kol.sum_kol_omoor) as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs
                  \s
                   FROM
                   kol\s
                   LEFT JOIN  omomi
                   on
                    omomi.mojtama_id = kol.mojtama_id
                    and omomi.moavenat_id = kol.moavenat_id
                    and omomi.omoor_id = kol.omoor_id
                  \s
                   where 1=1
                         and (
                              kol.mojtama_id is not null
                              and kol.moavenat_id is not null
                              and kol.omoor_id is not null
                             )
                   \s
                   group by
                   kol.mojtama_id
                   ,kol.mojtama
                   ,omomi.sum_omomi_mojtama\s
                   ,omomi.sum_omomi_moavenat\s
                   ,omomi.sum_omomi_omoor\s
                   ,kol.sum_kol_mojtama
                   ,kol.sum_kol_moavenat
                   ,kol.sum_kol_omoor
                   ,kol.moavenat_id
                   ,kol.moavenat
                   ,kol.omoor_id
                   ,kol.omoor
           ) res
            where 1=1
                AND (:complexNull = 1 OR complex IN (:complex))\s
                AND (:assistantNull = 1 OR assistant IN (:assistant))\s
                AND (:affairsNull = 1 OR affairs IN (:affairs))\s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> saraneomomi(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);

    @Query(value = """
           --Report04 -saraneh anbasht sabeghe amozeshi takhasosi
           
           SELECT rowNum AS id,
                  res.*
           FROM(     \s
           
            with kol as (
                         SELECT DISTINCT\s
                                     SUM(s.presence_hour)  over (partition by s.complex)    AS sum_kol_mojtama,\s
                                     SUM(s.presence_hour)  over (partition by s.assistant)   AS sum_kol_moavenat,\s
                                      SUM(s.presence_hour) over (partition by s.affairs)      AS sum_kol_omoor,\s
                                     s.affairs       AS omoor,
                                     s.assistant     AS moavenat,
                                     s.assistant_id  AS moavenat_id,\s
                                     s.affairs_id    AS omoor_id,
                                     s.complex_id    AS mojtama_id,
                                     s.complex       AS mojtama  \s
           
                                 FROM\s
                                     (\s
                                         SELECT\s
                                             class.id               AS class_id,\s
                                             tbl_student.id         AS student_id,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_hour,\s
                                               view_complex.id         AS complex_id,
                                               view_complex.c_title    AS complex,
                                               view_assistant.id       AS assistant_id,
                                               view_assistant.c_title  AS assistant,
                                               view_affairs.id         AS affairs_id,
                                               view_affairs.c_title    AS affairs
                                         FROM\s
                                             tbl_attendance att\s
                                             INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                             INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                             INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                             INNER JOIN
                                               (
                                                 select
                                                       tbl_student.id                                                         as id
                                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                                 \s
                                                  from tbl_student\s
                                                   LEFT JOIN view_last_md_employee_hr
                                                   ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                               )
                                               tbl_student  ON att.f_student = tbl_student.id
                                               RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                               RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                               RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                      where 1=1
                                            and class.C_START_DATE >=  :fromDate
                                            and class.C_START_DATE <=  :toDate
                                          \s
                                         GROUP BY\s
                                             class.id,\s
                                             tbl_student.id,\s
                                              view_complex.id,
                                             view_complex.c_title,
                                             view_assistant.id,
                                             view_assistant.c_title,
                                             view_affairs.id,
                                             view_affairs.c_title
           
                                     ) s\s
                                 GROUP BY\s
                                     s.presence_hour,
                                     s.class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex
                                    \s
                    having  nvl(count( s.class_id) ,0)  !=0   and s.presence_hour !=0
                    ),
                  \s
                  takhasosi as(
                              SELECT DISTINCT\s
                                     SUM(s.presence_hour)  over (partition by s.complex)    AS sum_takhasosi_mojtama,\s
                                     SUM(s.presence_hour)  over (partition by s.assistant)  AS sum_takhasosi_moavenat,\s
                                     SUM(s.presence_hour)  over (partition by s.affairs)    AS sum_takhasosi_omoor,\s
                                     s.affairs       AS omoor,
                                     s.assistant     AS moavenat,
                                     s.assistant_id  AS moavenat_id,\s
                                     s.affairs_id    AS omoor_id,
                                     s.complex_id    AS mojtama_id,
                                     s.complex       AS mojtama  \s
           
                                 FROM\s
                                     (\s
                                         SELECT\s
                                             class.id               AS class_id,\s
                                             tbl_student.id         AS student_id,\s
                                             SUM(\s
                                                 CASE\s
                                                     WHEN att.c_state IN('1', '2') THEN\s
                                                         round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                         'HH24:MI')) * 24, 1)\s
                                                     ELSE\s
                                                         0\s
                                                 END\s
                                             )                      AS presence_hour,\s
                                               view_complex.id         AS complex_id,
                                               view_complex.c_title    AS complex,
                                               view_assistant.id       AS assistant_id,
                                               view_assistant.c_title  AS assistant,
                                               view_affairs.id         AS affairs_id,
                                               view_affairs.c_title    AS affairs
                                         FROM\s
                                             tbl_attendance att\s
                                             INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                             INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                             INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                             INNER JOIN
                                               (
                                                 select
                                                       tbl_student.id                                                         as id
                                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                                 \s
                                                  from tbl_student\s
                                                   LEFT JOIN view_last_md_employee_hr
                                                   ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                               )
                                               tbl_student  ON att.f_student = tbl_student.id
                                               RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                               RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                               RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                      where 1=1
                                            and  tbl_course.e_technical_type = 2 --takhasosi
                                            and class.C_START_DATE >=  :fromDate
                                            and class.C_START_DATE <=  :toDate
                                          \s
                                         GROUP BY\s
                                             class.id,\s
                                             tbl_student.id,\s
                                              view_complex.id,
                                             view_complex.c_title,
                                             view_assistant.id,
                                             view_assistant.c_title,
                                             view_affairs.id,
                                             view_affairs.c_title
           
                                     ) s\s
                                 GROUP BY\s
                                     s.presence_hour,
                                     s.class_id,\s
                                     s.affairs,\s
                                     s.assistant,\s
                                     s.assistant_id,\s
                                     s.affairs_id,\s
                                     s.complex_id,\s
                                     s.complex
           \s
                   )
                  \s
                   select DISTINCT
                  \s
                   kol.mojtama_id     as complex_id
                   ,kol.mojtama       as complex
                   ,max(cast ((takhasosi.sum_takhasosi_mojtama /kol.sum_kol_mojtama) as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex
                  \s
                   , kol.moavenat_id  as assistant_id
                   , kol.moavenat     as assistant
                   ,max( cast ( (takhasosi.sum_takhasosi_moavenat /kol.sum_kol_moavenat) as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant
                  \s
                   ,kol.omoor_id     as affairs_id
                   ,kol.omoor        as affairs
                   ,max(cast ( (takhasosi.sum_takhasosi_omoor /kol.sum_kol_omoor) as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs
                  \s
                   FROM
                   kol\s
                   LEFT JOIN  takhasosi
                   on
                    takhasosi.mojtama_id = kol.mojtama_id
                    and takhasosi.moavenat_id = kol.moavenat_id
                    and takhasosi.omoor_id = kol.omoor_id
                  \s
                   where 1=1
                         and (
                              kol.mojtama_id is not null
                              and kol.moavenat_id is not null
                              and kol.omoor_id is not null
                             )
                   \s
                   group by
                   kol.mojtama_id
                   ,kol.mojtama
                   ,takhasosi.sum_takhasosi_mojtama\s
                   ,takhasosi.sum_takhasosi_moavenat\s
                   ,takhasosi.sum_takhasosi_omoor\s
                   ,kol.sum_kol_mojtama
                   ,kol.sum_kol_moavenat
                   ,kol.sum_kol_omoor
                   ,kol.moavenat_id
                   ,kol.moavenat
                   ,kol.omoor_id
                   ,kol.omoor
           ) res
            where 1=1
                AND (:complexNull = 1 OR complex IN (:complex))\s
                AND (:assistantNull = 1 OR assistant IN (:assistant))\s
                AND (:affairsNull = 1 OR affairs IN (:affairs))\s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> saratakhasosi(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);

    @Query(value = """
         --Report05 -saraneh anbasht sabeghe amozeshi modiriaty
         
         SELECT rowNum AS id,
                res.*
         FROM(     \s
         
          with kol as (
                       SELECT DISTINCT\s
                                   SUM(s.presence_hour)  over (partition by s.complex)    AS sum_kol_mojtama,\s
                                   SUM(s.presence_hour)  over (partition by s.assistant)   AS sum_kol_moavenat,\s
                                    SUM(s.presence_hour) over (partition by s.affairs)      AS sum_kol_omoor,\s
                                   s.affairs       AS omoor,
                                   s.assistant     AS moavenat,
                                   s.assistant_id  AS moavenat_id,\s
                                   s.affairs_id    AS omoor_id,
                                   s.complex_id    AS mojtama_id,
                                   s.complex       AS mojtama  \s
         
                               FROM\s
                                   (\s
                                       SELECT\s
                                           class.id               AS class_id,\s
                                           tbl_student.id         AS student_id,\s
                                           SUM(\s
                                               CASE\s
                                                   WHEN att.c_state IN('1', '2') THEN\s
                                                       round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                       'HH24:MI')) * 24, 1)\s
                                                   ELSE\s
                                                       0\s
                                               END\s
                                           )                      AS presence_hour,\s
                                             view_complex.id         AS complex_id,
                                             view_complex.c_title    AS complex,
                                             view_assistant.id       AS assistant_id,
                                             view_assistant.c_title  AS assistant,
                                             view_affairs.id         AS affairs_id,
                                             view_affairs.c_title    AS affairs
                                       FROM\s
                                           tbl_attendance att\s
                                           INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                           INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                           INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                           INNER JOIN
                                             (
                                               select
                                                     tbl_student.id                                                         as id
                                                    ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                    ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                    ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                               \s
                                                from tbl_student\s
                                                 LEFT JOIN view_last_md_employee_hr
                                                 ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                             )
                                             tbl_student  ON att.f_student = tbl_student.id
                                             RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                             RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                             RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                    where 1=1
                                          and class.C_START_DATE >= :fromDate
         
                                          and class.C_START_DATE <= :toDate
                                        \s
                                       GROUP BY\s
                                           class.id,\s
                                           tbl_student.id,\s
                                            view_complex.id,
                                           view_complex.c_title,
                                           view_assistant.id,
                                           view_assistant.c_title,
                                           view_affairs.id,
                                           view_affairs.c_title
         
                                   ) s\s
                               GROUP BY\s
                                   s.presence_hour,
                                   s.class_id,\s
                                   s.affairs,\s
                                   s.assistant,\s
                                   s.assistant_id,\s
                                   s.affairs_id,\s
                                   s.complex_id,\s
                                   s.complex
                                  \s
                  having  nvl(count( s.class_id) ,0)  !=0
                  ),
                \s
                modiriaty as(
                            SELECT DISTINCT\s
                                   SUM(s.presence_hour)  over (partition by s.complex)    AS sum_modiriaty_mojtama,\s
                                   SUM(s.presence_hour)  over (partition by s.assistant)  AS sum_modiriaty_moavenat,\s
                                   SUM(s.presence_hour)  over (partition by s.affairs)    AS sum_modiriaty_omoor,\s
                                   s.affairs       AS omoor,
                                   s.assistant     AS moavenat,
                                   s.assistant_id  AS moavenat_id,\s
                                   s.affairs_id    AS omoor_id,
                                   s.complex_id    AS mojtama_id,
                                   s.complex       AS mojtama  \s
         
                               FROM\s
                                   (\s
                                       SELECT\s
                                           class.id               AS class_id,\s
                                           tbl_student.id         AS student_id,\s
                                           SUM(\s
                                               CASE\s
                                                   WHEN att.c_state IN('1', '2') THEN\s
                                                       round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\s
                                                       'HH24:MI')) * 24, 1)\s
                                                   ELSE\s
                                                       0\s
                                               END\s
                                           )                      AS presence_hour,\s
                                             view_complex.id         AS complex_id,
                                             view_complex.c_title    AS complex,
                                             view_assistant.id       AS assistant_id,
                                             view_assistant.c_title  AS assistant,
                                             view_affairs.id         AS affairs_id,
                                             view_affairs.c_title    AS affairs
                                       FROM\s
                                           tbl_attendance att\s
                                           INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                           INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                           INNER JOIN tbl_course ON class.f_course = tbl_course.id\s
                                           INNER JOIN
                                             (
                                               select
                                                     tbl_student.id                                                         as id
                                                    ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                    ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                    ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                               \s
                                                from tbl_student\s
                                                 LEFT JOIN view_last_md_employee_hr
                                                 ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                             )
                                             tbl_student  ON att.f_student = tbl_student.id
                                             RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                             RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                             RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                    where 1=1
                                          and  tbl_course.e_technical_type = 3 --modiriaty
                                          and class.C_START_DATE >= :fromDate
         
                                          and class.C_START_DATE <= :toDate
                                        \s
                                       GROUP BY\s
                                           class.id,\s
                                           tbl_student.id,\s
                                            view_complex.id,
                                           view_complex.c_title,
                                           view_assistant.id,
                                           view_assistant.c_title,
                                           view_affairs.id,
                                           view_affairs.c_title
         
                                   ) s\s
                               GROUP BY\s
                                   s.presence_hour,
                                   s.class_id,\s
                                   s.affairs,\s
                                   s.assistant,\s
                                   s.assistant_id,\s
                                   s.affairs_id,\s
                                   s.complex_id,\s
                                   s.complex
         \s
                 )
                \s
                 select DISTINCT
                \s
                 kol.mojtama_id     as complex_id
                 ,kol.mojtama       as complex
                 ,max(cast ((modiriaty.sum_modiriaty_mojtama /kol.sum_kol_mojtama) as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex
                \s
                 , kol.moavenat_id  as assistant_id
                 , kol.moavenat     as assistant
                 ,max( cast ( (modiriaty.sum_modiriaty_moavenat /kol.sum_kol_moavenat) as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant
                \s
                 ,kol.omoor_id     as affairs_id
                 ,kol.omoor        as affairs
                 ,max(cast ( (modiriaty.sum_modiriaty_omoor /kol.sum_kol_omoor) as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs
                \s
                 FROM
                 kol\s
                 LEFT JOIN  modiriaty
                 on
                  modiriaty.mojtama_id = kol.mojtama_id
                  and modiriaty.moavenat_id = kol.moavenat_id
                  and modiriaty.omoor_id = kol.omoor_id
                \s
                 where 1=1
                       and (
                            kol.mojtama_id is not null
                            and kol.moavenat_id is not null
                            and kol.omoor_id is not null
                           )
                 \s
                 group by
                 kol.mojtama_id
                 ,kol.mojtama
                 ,modiriaty.sum_modiriaty_mojtama\s
                 ,modiriaty.sum_modiriaty_moavenat\s
                 ,modiriaty.sum_modiriaty_omoor\s
                 ,kol.sum_kol_mojtama
                 ,kol.sum_kol_moavenat
                 ,kol.sum_kol_omoor
                 ,kol.moavenat_id
                 ,kol.moavenat
                 ,kol.omoor_id
                 ,kol.omoor
         ) res
          where 1=1
              AND (:complexNull = 1 OR complex IN (:complex))\s
              AND (:assistantNull = 1 OR assistant IN (:assistant))\s
              AND (:affairsNull = 1 OR affairs IN (:affairs))\s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> saraneModiriati(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);




    @Query(value = """
           --Report06 -nerkh ghozar az amozesh
           
           SELECT\s
                 ROWNUM AS id,\s
                 res.*\s
           FROM\s
             (\s
                 SELECT DISTINCT\s
                     complex,\s
                     CASE\s
                         WHEN COUNT(national_code)\s
                              OVER(PARTITION BY complex) = 0 THEN\s
                             0\s
                         ELSE\s
                             round(COUNT(DISTINCT\s
                                 CASE\s
                                     WHEN ghabol LIKE  'PassdByGrade' or ghabol LIKE  'PassedWithoutGrade'  THEN
                                         national_code\s
                                 END\s
                             )\s
                                   OVER(PARTITION BY complex) / COUNT(national_code)\s
                                                                OVER(PARTITION BY complex), 2) * 100\s
                     END AS n_base_on_complex,\s
                     assistant,\s
                     CASE\s
                         WHEN COUNT(national_code)\s
                              OVER(PARTITION BY assistant) = 0 THEN\s
                             0\s
                         ELSE\s
                             round(COUNT(DISTINCT\s
                                 CASE\s
                                      WHEN ghabol LIKE  'PassdByGrade' or ghabol LIKE  'PassedWithoutGrade'  THEN
                                         national_code\s
                                 END\s
                             )\s
                                   OVER(PARTITION BY assistant) / COUNT(national_code)\s
                                                                  OVER(PARTITION BY assistant), 2) * 100\s
                     END AS n_base_on_assistant,\s
                     affairs,\s
                     CASE\s
                         WHEN COUNT(national_code)\s
                              OVER(PARTITION BY affairs) = 0 THEN\s
                             0\s
                         ELSE\s
                             round(COUNT(DISTINCT\s
                                 CASE\s
                                     WHEN ghabol LIKE  'PassdByGrade' or ghabol LIKE  'PassedWithoutGrade'  THEN\s
                                         national_code\s
                                 END\s
                             )\s
                                   OVER(PARTITION BY affairs) / COUNT(national_code)\s
                                                                OVER(PARTITION BY affairs), 2) * 100\s
                     END AS n_base_on_affairs,\s
                     complex_id,\s
                     assistant_id,\s
                     affairs_id\s
                 FROM\s
                     (\s
                         SELECT DISTINCT\s
                             tbl_student.national_code,\s
                             tbl_class_student.class_id,\s
                             tbl_student.id              AS student_id,\s
                             tbl_class.c_start_date,\s
                             tbl_class.c_end_date,\s
                             tbl_class_student.scores_state_id,\s
                             tbl_parameter_value.C_CODE  AS ghabol,
                             view_complex.id             AS complex_id ,
                             view_complex.c_title        AS complex,
                             view_assistant.id           AS assistant_id,
                             view_assistant.c_title      AS assistant,\s
                             view_affairs.id             AS affairs_id,
                             view_affairs.c_title        AS affairs
              \s
                         FROM\s
                                  tbl_class_student\s
                             INNER JOIN tbl_parameter_value ON tbl_class_student.scores_state_id = tbl_parameter_value.id
                             INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id
                             INNER JOIN
                               (
                                 select
                                       tbl_student.id                                                         as id
                                      ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                      ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                      ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                      ,tbl_student.NATIONAL_CODE                                              as national_code
                                  from tbl_student\s
                                       LEFT JOIN view_last_md_employee_hr
                                       ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                               )
                               tbl_student  ON tbl_class_student.student_id = tbl_student.id
                               RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                               RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                               RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
              \s
                         WHERE\s
                             tbl_class_student.e_deleted IS NULL\s
                             and tbl_class.c_start_date >=  :fromDate
                             and  tbl_class.c_start_date <= :toDate
                     )\s
              ) res
           WHERE\s
                (:complexNull = 1 OR complex IN (:complex))\s
                AND (:assistantNull = 1 OR assistant IN (:assistant))\s
                AND (:affairsNull = 1 OR affairs IN (:affairs))\s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> gozarAzAmozesh(String fromDate,
                                                        String toDate,
                                                        List<Object> complex,
                                                        int complexNull,
                                                        List<Object> assistant,
                                                        int assistantNull,
                                                        List<Object> affairs,
                                                        int affairsNull);



    @Query(value = """
        -- Report07- nerkh poshesh arzeshyabi sathe yadgiri
       
       SELECT rowNum AS id,
              res.*
       FROM(     \s
       
        with kol as (SELECT DISTINCT
                    count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_kol_mojtama,
                    count(distinct s.class_id)  over (partition by  s.moavenat)  AS count__kol_moavenat,
                    count(distinct s.class_id)  over (partition by s.omoor)      AS count__kol_omoor,
                    s.mojtama_id,
                    s.mojtama,
                    moavenat_id,
                    s.moavenat,
                    s.omoor_id,
                    s.omoor
                \s
               FROM
                   (
                       SELECT
                           class.id               AS class_id,
                           view_complex.id        AS mojtama_id,
                           view_complex.c_title   AS mojtama,
                           view_assistant.id      AS moavenat_id,
                           view_assistant.c_title AS moavenat,
                           view_affairs.id        AS omoor_id,
                           view_affairs.c_title   AS omoor
                       FROM
                           tbl_class   class\s
                           INNER JOIN tbl_class_student ON class.id = tbl_class_student.class_id
                            INNER JOIN
                           (
                             select
                                   tbl_student.id                                                         as id
                                  ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                  ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                  ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                             \s
                              from tbl_student\s
                               LEFT JOIN view_last_md_employee_hr
                               ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                           )
                           tbl_student  ON tbl_class_student.student_id = tbl_student.id
                           RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                           RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                           RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                      where 1=1
                       and class.c_status IN ( 2, 3, 5 )\s
                       and class.C_START_DATE >=  :fromDate
                       and class.C_START_DATE <=  :toDate
                          \s
                       GROUP BY
                           class.id,
                           view_complex.id,
                           view_complex.c_title,
                           view_assistant.id,
                           view_assistant.c_title,
                           view_affairs.id,
                           view_affairs.c_title
           \s
                   ) s
               GROUP BY
               \s
                   s.class_id,\s
                   s.mojtama_id,
                   s.mojtama,
                   moavenat_id,
                   s.moavenat,
                   s.omoor_id,
                   s.omoor
                having  nvl(count( s.class_id) ,0)  !=0
                ),
              \s
               khod as(SELECT DISTINCT
                   count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_yadgiri_mojtama,
                    count(distinct s.class_id)  over (partition by  s.moavenat)  AS count_yadgiri_moavenat,
                    count(distinct s.class_id)  over (partition by s.omoor)      AS count_yadgiri_omoor,
                    s.mojtama_id,
                   s.mojtama,
                   moavenat_id,
                   s.moavenat,
                   s.omoor_id,
                   s.omoor
                \s
               FROM
                   (
                       SELECT
                           class.id               AS class_id,
                           view_complex.id        AS mojtama_id,
                           view_complex.c_title   AS mojtama,
                           view_assistant.id      AS moavenat_id,
                           view_assistant.c_title AS moavenat,
                           view_affairs.id        AS omoor_id,
                           view_affairs.c_title   AS omoor
                       FROM
                           tbl_class   class
                           INNER JOIN tbl_evaluation_analysis ON class.id = tbl_evaluation_analysis.f_tclass\s
                           INNER JOIN tbl_class_student ON class.id = tbl_class_student.class_id
                           INNER JOIN
                           (
                             select
                                   tbl_student.id                                                         as id
                                  ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                  ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                  ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                             \s
                              from tbl_student\s
                               LEFT JOIN view_last_md_employee_hr
                               ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                           )
                           tbl_student  ON tbl_class_student.student_id = tbl_student.id
                           RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                           RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                           RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                      where 1=1\s
                       AND  tbl_evaluation_analysis.b_learning_pass = 1
                       and class.C_START_DATE >= :fromDate
                       and class.C_START_DATE <= :toDate
                          \s
                       GROUP BY
                           class.id,
                           view_complex.id,
                           view_complex.c_title,
                           view_assistant.id,
                           view_assistant.c_title,
                           view_affairs.id,
                           view_affairs.c_title
           \s
                   ) s
               GROUP BY
               \s
                   s.class_id,\s
                   s.mojtama_id,
                   s.mojtama,
                   moavenat_id,
                   s.moavenat,
                   s.omoor_id,
                   s.omoor
            \s
                )
              \s
               select DISTINCT
              \s
               kol.mojtama_id     as complex_id
               ,kol.mojtama       as complex
               ,max(cast ((khod.count_yadgiri_mojtama /kol.count_kol_mojtama)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex
              \s
               , kol.moavenat_id  as assistant_id
               , kol.moavenat     as assistant
               ,max( cast ( (khod.count_yadgiri_moavenat /kol.count__kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant
              \s
               ,kol.omoor_id     as affairs_id
               ,kol.omoor        as affairs
               ,max(cast ( (khod.count_yadgiri_omoor /kol.count__kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs
              \s
               FROM
               kol\s
               LEFT JOIN  khod
               on
                khod.mojtama_id = kol.mojtama_id
                and khod.moavenat_id = kol.moavenat_id
                and khod.omoor_id = kol.omoor_id
              \s
               where 1=1
                     and (
                          kol.mojtama_id is not null
                          and kol.moavenat_id is not null
                          and kol.omoor_id is not null
                         )
               \s
               group by
               kol.mojtama_id
               ,kol.mojtama
               ,khod.count_yadgiri_mojtama\s
               ,khod.count_yadgiri_moavenat\s
               ,khod.count_yadgiri_omoor\s
               ,kol.count_kol_mojtama
               ,kol.count__kol_moavenat
               ,kol.count__kol_omoor
               , kol.moavenat_id
               , kol.moavenat
               ,kol.omoor_id
               ,kol.omoor
       ) res
        where 1=1
            AND (:complexNull = 1 OR complex IN (:complex))\s
            AND (:assistantNull = 1 OR assistant IN (:assistant))\s
            AND (:affairsNull = 1 OR affairs IN (:affairs))\s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> arzeshyabiYadgiri(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);




    @Query(value = "SELECT rowNum AS id,\n" +
            "                   res.*\n" +
            "            FROM (\n" +
            "\n" +
            "SELECT DISTINCT\n" +
            "    complex                      AS complex,\n" +
            "    complex_id,\n" +
            "    \n" +
            "\n" +
            "    case\n" +
            "    when SUM(sum_presence_hour)\n" +
            "                                                         OVER(PARTITION BY complex) = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(\n" +
            "SUM(distinct case when tbl_course.e_run_type = 5 then sum_presence_hour end)\n" +
            "OVER(PARTITION BY complex) \n" +
            "          / SUM(sum_presence_hour)\n" +
            "                                                         OVER(PARTITION BY complex), 2)*100\n" +
            "                                                         \n" +
            "                                                         end \n" +
            "                                                         as n_base_on_complex ,\n" +
            "    \n" +
            "    \n" +
            "    \n" +
            "    \n" +
            "    \n" +
            "    \n" +
            "    \n" +
            "    \n" +
            "    assistant                    AS assistant,\n" +
            "    assistant_id,\n" +
            "\n" +
            "\n" +
            "    case\n" +
            "    when SUM(sum_presence_hour)\n" +
            "                                                         OVER(PARTITION BY assistant) = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(\n" +
            "SUM(distinct case when tbl_course.e_run_type = 5 then sum_presence_hour end)\n" +
            "OVER(PARTITION BY assistant) \n" +
            "          / SUM(sum_presence_hour)\n" +
            "                                                         OVER(PARTITION BY assistant), 2)*100\n" +
            "                                                         \n" +
            "                                                         end \n" +
            "                                                         as n_base_on_assistant,\n" +
            "\n" +
            "\n" +
            "\n" +
            "    affairs                      AS affairs,\n" +
            "    affairs_id,\n" +
            "   \n" +
            "   \n" +
            "    case\n" +
            "    when SUM(sum_presence_hour)\n" +
            "                                                         OVER(PARTITION BY affairs) = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(\n" +
            "SUM(distinct case when tbl_course.e_run_type = 5 then sum_presence_hour end)\n" +
            "OVER(PARTITION BY affairs) \n" +
            "          / SUM(sum_presence_hour)\n" +
            "                                                         OVER(PARTITION BY affairs), 2)*100\n" +
            "                                                         \n" +
            "                                                         end \n" +
            "                                                         as n_base_on_affairs \n" +
            "\n" +
            "  \n" +
            "  \n" +
            "  \n" +
            "  \n" +
            "\n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT DISTINCT\n" +
            "            SUM(s.presence_hour)   AS sum_presence_hour,\n" +
            "            SUM(s.presence_minute) AS sum_presence_minute,\n" +
            "            SUM(s.absence_hour)    AS sum_absence_hour,\n" +
            "            SUM(s.absence_minute)  AS sum_absence_minute,\n" +
            "            s.class_id             AS class_id,\n" +
            "            s.affairs,\n" +
            "            s.assistant,\n" +
            "            s.assistant_id,\n" +
            "            s.affairs_id,\n" +
            "            s.complex_id,\n" +
            "            s.complex,\n" +
            "            s.e_technical_type,\n" +
            "            s.e_run_type,\n" +
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            s.f_course\n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    std.id                 AS student_id,\n" +
            "                    SUM(\n" +
            "                        CASE\n" +
            "                            WHEN att.c_state IN('1', '2') THEN\n" +
            "                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\n" +
            "                                'HH24:MI')) * 24, 1)\n" +
            "                            ELSE\n" +
            "                                0\n" +
            "                        END\n" +
            "                    )                      AS presence_hour,\n" +
            "                    SUM(\n" +
            "                        CASE\n" +
            "                            WHEN att.c_state IN('1', '2') THEN\n" +
            "                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\n" +
            "                                'HH24:MI')) * 24 * 60)\n" +
            "                            ELSE\n" +
            "                                0\n" +
            "                        END\n" +
            "                    )                      AS presence_minute,\n" +
            "                    SUM(\n" +
            "                        CASE\n" +
            "                            WHEN att.c_state IN('3', '4') THEN\n" +
            "                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\n" +
            "                                'HH24:MI')) * 24, 1)\n" +
            "                            ELSE\n" +
            "                                0\n" +
            "                        END\n" +
            "                    )                      AS absence_hour,\n" +
            "                    SUM(\n" +
            "                        CASE\n" +
            "                            WHEN att.c_state IN('3', '4') THEN\n" +
            "                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour,\n" +
            "                                'HH24:MI')) * 24 * 60)\n" +
            "                            ELSE\n" +
            "                                0\n" +
            "                        END\n" +
            "                    )                      AS absence_minute,\n" +
            "                    class.c_start_date,\n" +
            "                    class.f_course,\n" +
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
            "                    tbl_course.e_run_type,\n" +
            "                    view_complex.c_title   AS complex,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title AS assistant,\n" +
            "                    view_affairs.c_title   AS affairs\n" +
            "                FROM\n" +
            "                         tbl_attendance att\n" +
            "                    INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                    INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                    INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                    INNER JOIN tbl_course ON class.f_course = tbl_course.id\n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    std.id,\n" +
            "                    class.c_start_date,\n" +
            "                    class.f_course,\n" +
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
            "                    tbl_course.e_run_type,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title,\n" +
            "                    csession.c_session_date,\n" +
            "                    class.c_code\n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "            s.class_id,\n" +
            "            s.affairs,\n" +
            "            s.assistant,\n" +
            "            s.assistant_id,\n" +
            "            s.affairs_id,\n" +
            "            s.complex_id,\n" +
            "            s.complex,\n" +
            "            s.e_technical_type,\n" +
            "                        s.e_run_type,\n" +
            "\n" +
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            s.f_course\n" +
            "    )\n" +
            "    INNER JOIN tbl_course ON f_course = tbl_course.id\n" +
            "WHERE\n" +
            "        c_start_date >= :fromDate\n" +
            "    AND c_start_date <= :toDate\n" +
            "    AND f_course IN (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_course.id\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment\n" +
            "            INNER JOIN tbl_skill ON tbl_needs_assessment.f_skill = tbl_skill.id\n" +
            "            INNER JOIN tbl_course ON tbl_skill.f_main_objective_course = tbl_course.id\n" +
            "        WHERE\n" +
            "            tbl_skill.e_deleted IS NULL\n" +
            "    )\n" +
            "    and\n" +
            "      (:complexNull = 1 OR complex IN (:complex))\n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "      AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "    )res", nativeQuery = true)
    List<GenericStatisticalIndexReport> getSkillTrainingNeeds(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);



    @Query(value = """
           
           --Report01- shakhes mizan kol nyazhay shenasaee shodeh
           
           SELECT rowNum AS id, \s
                 res.* \s
           FROM ( \s
                           \s
                  SELECT DISTINCT \s
                      mojtama                      AS complex, \s
                      mojtama_id                   AS complex_id, \s
                      SUM(sum_presence_hour) \s
                      OVER(PARTITION BY mojtama)   AS n_base_on_complex, \s
                      moavenat                     AS assistant, \s
                      moavenat_id                  AS assistant_id, \s
                      SUM(sum_presence_hour) \s
                      OVER(PARTITION BY moavenat) AS n_base_on_assistant, \s
                       omoor                      AS affairs, \s
                       omoor_id                   AS affairs_id, \s
                      SUM(sum_presence_hour) \s
                      OVER(PARTITION BY omoor)   AS n_base_on_affairs \s
                  FROM \s
                           ( \s
                          SELECT DISTINCT \s
                              SUM(s.presence_hour)   AS sum_presence_hour, \s
                              SUM(s.presence_minute) AS sum_presence_minute, \s
                              SUM(s.absence_hour)    AS sum_absence_hour, \s
                              SUM(s.absence_minute)  AS sum_absence_minute, \s
                              s.class_id             AS class_id, \s
                              s.omoor, \s
                              s.moavenat, \s
                              s.moavenat_id, \s
                              s.omoor_id, \s
                              s.mojtama_id, \s
                              s.mojtama, \s
                              s.e_technical_type, \s
                              s.c_end_date, \s
                              s.c_start_date, \s
                              s.f_course, \s
                              CASE \s
                                  WHEN s.e_technical_type = '1' THEN \s
                                      'عمومی' \s
                                  WHEN s.e_technical_type = '2' THEN \s
                                      'تخصصی' \s
                                  WHEN s.e_technical_type = '3' THEN \s
                                      'مدیریتی' \s
                              END                    AS technical_title \s
                          FROM \s
                              ( \s
                                  SELECT \s
                                      class.id               AS class_id, \s
                                      tbl_student.id         AS student_id, \s
                                      SUM( \s
                                          CASE \s
                                              WHEN att.c_state IN('1', '2') THEN \s
                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, \s
                                                  'HH24:MI')) * 24, 1) \s
                                              ELSE \s
                                                  0 \s
                                          END \s
                                      )                      AS presence_hour, \s
                                      SUM( \s
                                          CASE \s
                                              WHEN att.c_state IN('1', '2') THEN \s
                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, \s
                                                  'HH24:MI')) * 24 * 60) \s
                                              ELSE \s
                                                  0 \s
                                          END \s
                                      )                      AS presence_minute, \s
                                      SUM( \s
                                          CASE \s
                                              WHEN att.c_state IN('3', '4') THEN \s
                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, \s
                                                  'HH24:MI')) * 24, 1) \s
                                              ELSE \s
                                                  0 \s
                                          END \s
                                      )                      AS absence_hour, \s
                                      SUM( \s
                                          CASE \s
                                              WHEN att.c_state IN('3', '4') THEN \s
                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, \s
                                                  'HH24:MI')) * 24 * 60) \s
                                              ELSE \s
                                                  0 \s
                                          END \s
                                      )                           AS absence_minute, \s
                                      class.c_start_date, \s
                                      class.f_course, \s
                                      class.c_end_date, \s
                                      tbl_course.e_technical_type, \s
                                       view_complex.id            AS mojtama_id,
                                       view_complex.c_title       AS mojtama,
                                       view_assistant.id          AS moavenat_id,
                                       view_assistant.c_title     AS moavenat,
                                       view_affairs.id            AS omoor_id,
                                       view_affairs.c_title       AS omoor
           
                                  FROM \s
                                      tbl_attendance att \s
                                      INNER JOIN tbl_session csession ON att.f_session = csession.id \s
                                      INNER JOIN tbl_class   class ON csession.f_class_id = class.id \s
                                      INNER JOIN tbl_course ON class.f_course = tbl_course.id
                                      INNER JOIN
                                       (
                                         select
                                               tbl_student.id                                                         as id
                                              ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                              ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                              ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                         \s
                                          from tbl_student\s
                                           LEFT JOIN view_last_md_employee_hr
                                           ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                       )
                                       tbl_student  ON att.f_student = tbl_student.id
                                       RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                       RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                       RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
           
                                  GROUP BY \s
                                      class.id, \s
                                      tbl_student.id, \s
                                      class.c_start_date, \s
                                      class.f_course, \s
                                      class.c_end_date, \s
                                      tbl_course.e_technical_type, \s
                                      view_complex.id,
                                      view_complex.c_title,
                                      view_assistant.id,
                                      view_assistant.c_title,
                                      view_affairs.id,
                                      view_affairs.c_title,
                                      csession.c_session_date, \s
                                      class.c_code \s
                              ) s \s
                          GROUP BY \s
                              s.class_id, \s
                              s.omoor, \s
                              s. moavenat, \s
                              s. moavenat_id, \s
                              s.omoor_id, \s
                              s.mojtama_id, \s
                              s.mojtama, \s
                              s.e_technical_type, \s
                              s.c_end_date, \s
                              s.c_start_date, \s
                              s.f_course \s
                      ) \s
                      INNER JOIN tbl_course ON f_course = tbl_course.id \s
                  WHERE \s
                          c_start_date >=  :fromDate \s
                      AND c_start_date <=  :toDate \s
                      AND  \s
                      f_course IN ( \s
                          SELECT DISTINCT \s
                              tbl_course.id \s
                          FROM \s
                                   tbl_needs_assessment \s
                              INNER JOIN tbl_skill ON tbl_needs_assessment.f_skill = tbl_skill.id \s
                              INNER JOIN tbl_course ON tbl_skill.f_main_objective_course = tbl_course.id \s
                          WHERE \s
                              tbl_skill.e_deleted IS NULL \s
                      ) \s
                  )res
           where 1=1
               AND (:complexNull = 1 OR complex IN (:complex)) \s
               AND (:assistantNull = 1 OR assistant IN (:assistant)) \s
               AND (:affairsNull = 1 OR affairs IN (:affairs))
                             \s
                             \s
                             \s
                             \s
                             \s
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> needAssessment(String fromDate,
                                                              String toDate,
                                                              List<Object> complex,
                                                              int complexNull,
                                                              List<Object> assistant,
                                                              int assistantNull,
                                                              List<Object> affairs,
                                                              int affairsNull);





    @Query(value = " -- nesbat karkonan amozesh be kol karkonan\n" +
            "-- we have no date filter in this query\n" +
            "SELECT rowNum AS id,\n" +
            "                                           res.*\n" +
            "                                    FROM (\n" +
            "with personel_kol as(\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as personel_kol_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as personel_kol_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as personel_kol_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title   as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED = 0\n" +
            "         --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title   \n" +
            "),\n" +
            " personel_amoozesh as (\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as personel_amoozesh_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as personel_amoozesh_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as personel_amoozesh_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title   as asmojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED = 0\n" +
            "        and p.CCP_AFFAIRS like '%آموزش%'--\n" +
            "        --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title  \n" +
            ")\n" +
            "\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "personel_kol.mojtama_id as complex_id\n" +
            ",personel_kol.mojtama AS complex\n" +
            ",sum(cast (  (personel_amoozesh.personel_amoozesh_mojtama /personel_kol.personel_kol_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY personel_kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", personel_kol.moavenat_id as assistant_id\n" +
            ", personel_kol.moavenat as assistant\n" +
            ",sum( cast ( (personel_amoozesh.personel_amoozesh_moavenat /personel_kol.personel_kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  personel_kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",personel_kol.omoor_id as affairs_id\n" +
            ",personel_kol.omoor  AS affairs\n" +
            ",sum(cast ( (personel_amoozesh.personel_amoozesh_omoor /personel_kol.personel_kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY personel_kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "personel_kol \n" +
            "LEFT JOIN   personel_amoozesh\n" +
            "on\n" +
            " personel_amoozesh.mojtama_id = personel_kol.mojtama_id\n" +
            " and personel_amoozesh.moavenat_id = personel_kol.moavenat_id\n" +
            " and personel_amoozesh.omoor_id = personel_kol.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "and (personel_kol.mojtama_id is not null\n" +
            "     and personel_kol.moavenat_id is not null\n" +
            "     and personel_kol.omoor_id is not null\n" +
            "    )\n" +
            "\n" +
            "group by\n" +
            "personel_kol.mojtama_id\n" +
            ",personel_kol.mojtama\n" +
            ",personel_amoozesh.personel_amoozesh_mojtama \n" +
            ",personel_amoozesh.personel_amoozesh_moavenat\n" +
            ",personel_amoozesh.personel_amoozesh_omoor\n" +
            ",personel_kol.personel_kol_mojtama\n" +
            ",personel_kol.personel_kol_moavenat\n" +
            ",personel_kol.personel_kol_omoor\n" +
            ", personel_kol.moavenat_id\n" +
            ", personel_kol.moavenat\n" +
            ",personel_kol.omoor_id\n" +
            ",personel_kol.omoor) res\n" +
            "where 1=1\n" +
            "and (\n" +
            "(:complexNull = 1 OR complex IN (:complex))\n" +
            "AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "    )\n" +
            "\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> trainingStaffToTotalStaff(
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);


    @Query(value = " --final nerkh asar bakhshi sathe yadgiri (doreh jadid)\n" +
            " SELECT\n" +
            "    rowNum AS id, res.* FROM(\n" +
            "select distinct\n" +
            "co.id                as complex_id \n" +
            ",co.c_title          as complex\n" +
            ",vt.nerkh_mojtama_x  as n_base_on_complex\n" +
            ",si.id               as assistant_id\n" +
            ",si.c_title          as assistant\n" +
            ",vt.nerkh_moavenat_x  as n_base_on_assistant\n" +
            ",af.id               as affairs_id  \n" +
            ",vt.nerkh_omoor_x  as n_base_on_affairs\n" +
            ",af.c_title          as affairs\n" +
            "\n" +
            "from\n" +
            "     tbl_class                     cl \n" +
            "    LEFT JOIN view_complex        co ON cl.complex_id = co.id\n" +
            "    LEFT JOIN view_assistant      si ON cl.assistant_id = si.id\n" +
            "    LEFT JOIN view_affairs        af ON cl.affairs_id = af.id\n" +
            "left join( --vt\n" +
            "\n" +
            "        select \n" +
            "          \n" +
            "            max(abs(cast(nr.sorat_mojtama / nr.makhraj_mojtama as decimal(6,2))))  OVER( PARTITION BY nr.mojtama  ) as nerkh_mojtama_x\n" +
            "            ,nr.mojtama_id as mojtama_id_vt\n" +
            "            \n" +
            "            ,max(abs(cast(nr.sorat_moavenat / nr.makhraj_moavenat as decimal(6,2))))  OVER( PARTITION BY nr.moavenat  ) as nerkh_moavenat_x\n" +
            "            ,nr.moavenat_id as moavenat_id_vt\n" +
            "            \n" +
            "            ,max(abs(cast(nr.sorat_omoor / nr.makhraj_omoor as decimal(6,2))))  OVER( PARTITION BY nr.omoor  ) as nerkh_omoor_x\n" +
            "            ,nr.omoor_id as omoor_id_vt\n" +
            "        from( --nr\n" +
            "        \n" +
            "            SELECT\n" +
            "               max ((AVG(nvl(cs.pre_test_score, 0)) - AVG(nvl(cs.score, 0)))  )OVER( PARTITION BY co.c_title  )  as sorat_mojtama,\n" +
            "               max( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))) )  OVER( PARTITION BY co.c_title  ) as makhraj_mojtama,\n" +
            "                max ((AVG(nvl(cs.pre_test_score, 0)) - AVG(nvl(cs.score, 0)))  )OVER( PARTITION BY si.c_title  )  as sorat_moavenat,\n" +
            "               max( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))) )  OVER( PARTITION BY si.c_title  ) as makhraj_moavenat,\n" +
            "                max ((AVG(nvl(cs.pre_test_score, 0)) - AVG(nvl(cs.score, 0)))  )OVER( PARTITION BY af.c_title  )  as sorat_omoor,\n" +
            "               max( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))) )  OVER( PARTITION BY af.c_title  ) as makhraj_omoor,\n" +
            "                cs.class_id   AS class_id,\n" +
            "                c.c_code      AS class_code,\n" +
            "                co.c_title    AS mojtama,\n" +
            "                co.id         AS mojtama_id,   \n" +
            "                si.c_title    AS moavenat,\n" +
            "                si.id        as  moavenat_id,\n" +
            "                af.c_title    AS omoor,\n" +
            "                af.id         as omoor_id \n" +
            "           \n" +
            "            FROM\n" +
            "                tbl_class_student   cs\n" +
            "                INNER JOIN tbl_class           c ON cs.class_id = c.id\n" +
            "                LEFT JOIN view_complex        co ON c.complex_id = co.id\n" +
            "                LEFT JOIN view_assistant      si ON c.assistant_id = si.id\n" +
            "                LEFT JOIN view_affairs        af ON c.affairs_id = af.id\n" +
            "             WHERE 1 = 1  \n" +
            "              and\n" +
            "     c.D_CREATED_DATE >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and c.D_CREATED_DATE <=  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "  \n" +
            "--              and    to_char(c.D_CREATED_DATE,'yyyy/mm/dd','nls_calendar=persian')  <=@ from_date  --should be a mandatory @parameter\n" +
            "--              and   to_char(c.D_CREATED_DATE,'yyyy/mm/dd','nls_calendar=persian')   =>@ to_date   -- should be a mandatory @parameter\n" +
            "--             and co.id =@\n" +
            "--             and si.id =@\n" +
            "--             and af.id=@ \n" +
            "       \n" +
            "            GROUP BY\n" +
            "                cs.class_id,\n" +
            "                c.c_code,\n" +
            "                co.c_title,\n" +
            "                si.c_title,\n" +
            "                af.c_title,\n" +
            "                co.id,\n" +
            "                si.id,\n" +
            "                af.id\n" +
            "            HAVING\n" +
            "                  ( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))))  !=0\n" +
            "          ) nr\n" +
            "        group by\n" +
            "          nr.mojtama\n" +
            "          ,nr.sorat_mojtama\n" +
            "          ,nr.makhraj_mojtama\n" +
            "          ,nr.mojtama_id\n" +
            "          ,nr.moavenat\n" +
            "          ,nr.sorat_moavenat\n" +
            "          ,nr.makhraj_moavenat\n" +
            "          ,nr.moavenat_id\n" +
            "          ,nr.omoor\n" +
            "          ,nr.sorat_omoor\n" +
            "          ,nr.makhraj_omoor\n" +
            "          ,nr.omoor_id\n" +
            " ) vt \n" +
            " on\n" +
            "     co.id  = vt.mojtama_id_vt\n" +
            "     and si.id = vt.moavenat_id_vt\n" +
            "     and af.id  = vt.omoor_id_vt\n" +
            "  \n" +
            "order by\n" +
            "vt.nerkh_mojtama_x\n" +
            ",vt.nerkh_moavenat_x\n" +
            ",vt.nerkh_omoor_x\n" +
            ") RES\n" +
            "WHERE \n" +
            "(:complexNull = 1 OR complex IN (:complex))\n" +
            "AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> teachingLearningLevelOfNewCourses(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);

    @Query(value = " --final nerkh asar bakhshi sathe yadgiri (doreh_por_tekrar )\n" +
            " SELECT\n" +
            "   rowNum AS id,  res.* FROM\n" +
            "     (\n" +
            "select distinct\n" +
            "co.id                as complex_id \n" +
            ",co.c_title          as complex\n" +
            ",vt.nerkh_mojtama_x  as n_base_on_complex\n" +
            ",si.id               as assistant_id\n" +
            ",si.c_title          as assistant\n" +
            ",vt.nerkh_moavenat_x as n_base_on_assistant\n" +
            ",af.id               as affairs_id  \n" +
            ",vt.nerkh_omoor_x    as n_base_on_affairs\n" +
            ",af.c_title          as affairs\n" +
            "\n" +
            "from\n" +
            "     tbl_class                     cl \n" +
            "    LEFT JOIN view_complex        co ON cl.complex_id = co.id\n" +
            "    LEFT JOIN view_assistant      si ON cl.assistant_id = si.id\n" +
            "    LEFT JOIN view_affairs        af ON cl.affairs_id = af.id\n" +
            "left join( --vt\n" +
            "\n" +
            "        select \n" +
            "          \n" +
            "            max(abs(cast(nr.sorat_mojtama / nr.makhraj_mojtama as decimal(6,2))))  OVER( PARTITION BY nr.mojtama  ) as nerkh_mojtama_x\n" +
            "            ,nr.mojtama_id as mojtama_id_vt\n" +
            "            \n" +
            "            ,max(abs(cast(nr.sorat_moavenat / nr.makhraj_moavenat as decimal(6,2))))  OVER( PARTITION BY nr.moavenat  ) as nerkh_moavenat_x\n" +
            "            ,nr.moavenat_id as moavenat_id_vt\n" +
            "            \n" +
            "            ,max(abs(cast(nr.sorat_omoor / nr.makhraj_omoor as decimal(6,2))))  OVER( PARTITION BY nr.omoor  ) as nerkh_omoor_x\n" +
            "            ,nr.omoor_id as omoor_id_vt\n" +
            "        from( --nr\n" +
            "                    \n" +
            "            SELECT\n" +
            "               max ((AVG(nvl(cs.pre_test_score, 0)) - AVG(nvl(cs.score, 0)))  )OVER( PARTITION BY p.mojtama  )     as sorat_mojtama,\n" +
            "               max( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))) )  OVER( PARTITION BY p.mojtama  )  as makhraj_mojtama,\n" +
            "                max ((AVG(nvl(cs.pre_test_score, 0)) - AVG(nvl(cs.score, 0)))  )OVER( PARTITION BY p.moavenat  )   as sorat_moavenat,\n" +
            "               max( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))) )  OVER( PARTITION BY p.moavenat  ) as makhraj_moavenat,\n" +
            "                max ((AVG(nvl(cs.pre_test_score, 0)) - AVG(nvl(cs.score, 0)))  )OVER( PARTITION BY p.omoor  )      as sorat_omoor,\n" +
            "               max( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))) )  OVER( PARTITION BY p.omoor  )    as makhraj_omoor,\n" +
            "                cs.class_id                                                                                        as class_id,\n" +
            "                p.class_code,\n" +
            "                p.mojtama_id,\n" +
            "                p.mojtama,\n" +
            "                p.moavenat_id,\n" +
            "                p.moavenat,\n" +
            "                p.omoor_id,\n" +
            "                p.omoor\n" +
            "           \n" +
            "            FROM\n" +
            "                tbl_class_student   cs\n" +
            "                  inner join( \n" +
            "                                select distinct\n" +
            "                                        max(d.count_class_per_title) over ( partition by co.id ) as asdoreh_portekrar_in_mojtama \n" +
            "                                       ,max(d.count_class_per_title) over ( partition by si.id ) as asdoreh_portekrar_in_moavenat \n" +
            "                                       ,max(d.count_class_per_title) over ( partition by af.id ) as  asdoreh_portekrar_in_omoor\n" +
            "                                       ,c.id                                                     as class_id\n" +
            "                                       ,c.c_code                                                 as class_code\n" +
            "                                       ,co.id          as mojtama_id\n" +
            "                                       ,co.c_title     as mojtama \n" +
            "                                       ,si.c_title    as moavenat \n" +
            "                                       ,si.id          as moavenat_id\n" +
            "                                       ,af.id          as omoor_id\n" +
            "                                       ,af.c_title     as omoor\n" +
            "                                       \n" +
            "                                from\n" +
            "                                tbl_class c\n" +
            "                                left join  (\n" +
            "                                        select\n" +
            "                                        count(c.id) over  (partition by  c.c_title_class) as count_class_per_title\n" +
            "                                        ,c.id\n" +
            "                                        from\n" +
            "                                        tbl_class  c\n" +
            "                                        group by\n" +
            "                                        c.id\n" +
            "                                        ,c.c_title_class\n" +
            "                                        )d\n" +
            "                                        on c.id = d.id\n" +
            "                                 LEFT JOIN view_complex        co ON c.complex_id = co.id\n" +
            "                                LEFT JOIN view_assistant      si ON c.assistant_id = si.id\n" +
            "                                LEFT JOIN view_affairs        af ON c.affairs_id = af.id \n" +
            "                              where 1=1\n" +
            "                                       and\n" +
            "    c.C_START_DATE >=  :fromDate\n" +
            "     and c.C_START_DATE <=  :toDate\n" +
            "                                --and  c.C_START_DATE <=@ \n" +
            "                                --and c.C_END_DATE =>@\n" +
            "--                                 and co.id =@\n" +
            "--                                 and si.id =@\n" +
            "--                                 and af.id=@\n" +
            "                      ) p\n" +
            "                     on\n" +
            "                      cs.class_id = p.class_id \n" +
            "            GROUP BY\n" +
            "                cs.class_id,\n" +
            "                p.class_id,\n" +
            "                p.class_code,\n" +
            "                p.mojtama_id,\n" +
            "                p.mojtama,\n" +
            "                p.moavenat_id,\n" +
            "                p.moavenat,\n" +
            "                p.omoor_id,\n" +
            "                p.omoor\n" +
            "            HAVING   ( (MAX(nvl(cs.score, 0)) - MIN(nvl(cs.pre_test_score  , 0))))  !=0\n" +
            "            \n" +
            "          ) nr\n" +
            "        group by\n" +
            "          nr.mojtama\n" +
            "          ,nr.sorat_mojtama\n" +
            "          ,nr.makhraj_mojtama\n" +
            "          ,nr.mojtama_id\n" +
            "          ,nr.moavenat\n" +
            "          ,nr.sorat_moavenat\n" +
            "          ,nr.makhraj_moavenat\n" +
            "          ,nr.moavenat_id\n" +
            "          ,nr.omoor\n" +
            "          ,nr.sorat_omoor\n" +
            "          ,nr.makhraj_omoor\n" +
            "          ,nr.omoor_id\n" +
            " ) vt \n" +
            " on\n" +
            "     co.id  = vt.mojtama_id_vt\n" +
            "     and si.id = vt.moavenat_id_vt\n" +
            "     and af.id  = vt.omoor_id_vt\n" +
            "     \n" +
            "order by\n" +
            " vt.nerkh_mojtama_x \n" +
            ",vt.nerkh_moavenat_x  \n" +
            ",vt.nerkh_omoor_x  \n" +
            ") res\n" +
            "WHERE \n" +
            "            (:complexNull = 1 OR complex IN (:complex))\n" +
            "            AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "            AND (:affairsNull = 1 OR affairs IN (:affairs))", nativeQuery = true)
    List<GenericStatisticalIndexReport> teachingLearningLevelOfFrequentCourses(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);
    @Query(value = "-- nesbat tadris modaresan dakheli(hamkar)\n" +
            "\n" +
            "SELECT\n" +
            "   rowNum AS id, res.* FROM (\n" +
            " with kol as(\n" +
            " \n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "   and  class.C_START_DATE >= :fromDate\n" +
            "          and class.C_START_DATE <= :toDate\n" +
            "     --     and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor  \n" +
            "HAVING  SUM(s.presence_hour) !=0        \n" +
            "        \n" +
            " ),\n" +
            "\n" +
            "modares_hamkar as(\n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_modares_hamkar_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_modares_hamkar_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_modares_hamkar_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std       ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession  ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class     ON csession.f_class_id = class.id\n" +
            "                INNER JOIN TBL_TEACHER teacher   ON teacher.ID = class.F_TEACHER\n" +
            "                LEFT JOIN view_complex           ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs           ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant         ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "              and  teacher.B_PERSONNEL = 1 -- modares hamkar\n" +
            "                       \n" +
            "          and  class.C_START_DATE >= :fromDate\n" +
            "          and class.C_START_DATE <= :toDate\n" +
            "            --and class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE =>@\n" +
            "  --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            ")\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",sum(cast (  (modares_hamkar.sum_presence_hour_modares_hamkar_mojtama /kol.sum_presence_hour_kol_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",sum( cast ( (modares_hamkar.sum_presence_hour_modares_hamkar_moavenat /kol.sum_presence_hour_kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",sum(cast ( (modares_hamkar.sum_presence_hour_modares_hamkar_omoor /kol.sum_presence_hour_kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol\n" +
            "LEFT JOIN   modares_hamkar\n" +
            "on\n" +
            " modares_hamkar.mojtama_id = kol.mojtama_id\n" +
            " and modares_hamkar.moavenat_id = kol.moavenat_id\n" +
            " and modares_hamkar.omoor_id = kol.omoor_id\n" +
            "\n" +
            "WHERE 1=1\n" +
            "AND (\n" +
            "     kol.mojtama_id IS NOT NULL \n" +
            "     AND  kol.moavenat_id IS NOT NULL \n" +
            "     AND  kol.omoor_id IS NOT NULL \n" +
            "   )\n" +
            "\n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",modares_hamkar.sum_presence_hour_modares_hamkar_mojtama\n" +
            ",modares_hamkar.sum_presence_hour_modares_hamkar_moavenat\n" +
            ",modares_hamkar.sum_presence_hour_modares_hamkar_omoor\n" +
            ",kol.sum_presence_hour_kol_mojtama\n" +
            ",kol.sum_presence_hour_kol_moavenat\n" +
            ",kol.sum_presence_hour_kol_omoor\n" +
            ",kol.moavenat_id\n" +
            ",kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            ") res\n" +
            "where\n" +
            "(:complexNull = 1 OR complex IN (:complex))\n" +
            "                     AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                      AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> teachingRatioOfInternalTeachers(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);
    @Query(value = """
           -- Report14- nesbat amozesh hay ojt \s
           
            SELECT\s
                rowNum AS id,\s
                res.* FROM(\s
                     with kol as(\s
                     \s
                         SELECT \s
                              SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_complex.id)      as kol_nafar_satat_pish_bini_mojtama\s
                              ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_assistant.id )  as kol_nafar_satat_pish_bini_moavenat\s
                              ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_affairs.id )    as kol_nafar_satat_pish_bini_omoor\s
                              , view_complex.id          AS mojtama_id,
                              view_complex.c_title       AS mojtama,
                              view_assistant.id          AS moavenat_id,
                              view_assistant.c_title     AS moavenat,
                              view_affairs.id            AS omoor_id,
                              view_affairs.c_title       AS omoor
                  \s
                            FROM tbl_class   class \s
                                    INNER JOIN tbl_class_student ON class.id = tbl_class_student.class_id
                                    INNER JOIN
                                   (
                                     select
                                           tbl_student.id                                                         as id
                                          ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                          ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                          ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                     \s
                                      from tbl_student\s
                                       LEFT JOIN view_last_md_employee_hr
                                       ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                   )
                                   tbl_student  ON tbl_class_student.student_id = tbl_student.id
                                   RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                   RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                   RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE   \s
                  \s
                            WHERE 1=1\s
                                  and class.C_START_DATE >=  :fromDate
                                  and class.C_START_DATE <=  :toDate
           
                  \s
                           GROUP BY\s
                                class.id,\s
                                class.c_code,    \s
                                class.c_start_date,\s
                                class.c_end_date,\s
                                class.n_h_duration,
                                view_complex.id,
                                view_complex.c_title,
                                view_assistant.id,
                                view_assistant.c_title,
                                view_affairs.id,
                                view_affairs.c_title
                           \s
                        having   SUM(class.n_h_duration )  !=0          \s
                            \s
                     ),\s
                    \s
                    ojt as(\s
                        SELECT DISTINCT\s
                            SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_otj_mojtama,\s
                            SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_otj_moavenat,\s
                            SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_otj_omoor,\s
                             s.class_id, \s
                            s.class_end_date,\s
                            s.class_start_date,  \s
                            s.mojtama_id,\s
                            s.mojtama,\s
                            s.moavenat_id,\s
                            s.moavenat,\s
                            s.omoor_id,\s
                            s.omoor\s
                          \s
                        FROM\s
                            (\s
                                SELECT\s
                                    class.id               AS class_id,\s
                                    tbl_student.id                 AS student_id,\s
                                    SUM(\s
                                        CASE\s
                                            WHEN att.c_state IN('1', '2') THEN\s
                                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\s
                                                24, 1)\s
                                            ELSE\s
                                                0\s
                                        END\s
                                    )                      AS presence_hour,\s
                                   \s
                                    class.c_start_date     AS class_start_date ,\s
                                    class.c_end_date       AS class_end_date,\s
                                    view_complex.id          AS mojtama_id,
                                   view_complex.c_title    AS mojtama,
                                   view_assistant.id          AS moavenat_id,
                                   view_assistant.c_title    AS moavenat,
                                   view_affairs.id              AS omoor_id,
                                   view_affairs.c_title        AS omoor
                  \s
                                FROM\s
                                         tbl_attendance att\s
                                    INNER JOIN tbl_session csession ON att.f_session = csession.id\s
                                    INNER JOIN tbl_class   class ON csession.f_class_id = class.id\s
                                    INNER JOIN
                                       (
                                         select
                                               tbl_student.id                                                         as id
                                              ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                              ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                              ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                         \s
                                          from tbl_student\s
                                           LEFT JOIN view_last_md_employee_hr
                                           ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                       )
                                   tbl_student  ON att.f_student = tbl_student.id\s
                                   RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                   RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                   RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                  \s
                              WHERE 1=1\s
                                     and class.C_TEACHING_TYPE  like  '%OJT%'\s
                                      and class.C_START_DATE >=  :fromDate
                                      and class.C_START_DATE <=  :toDate
           
                                            \s
                                GROUP BY\s
                                    class.id,\s
                                    tbl_student.id,\s
                                    class.c_start_date,\s
                                    class.c_end_date,\s
                                    csession.c_session_date,\s
                                    class.c_code,
                                    view_complex.id,
                                   view_complex.c_title,
                                   view_assistant.id,
                                   view_assistant.c_title,
                                   view_affairs.id,
                                   view_affairs.c_title
                  \s
                                   \s
                            ) s\s
                        GROUP BY\s
                            s.presence_hour,\s
                            s.class_id, \s
                            s.class_end_date,\s
                            s.class_start_date,  \s
                            s.mojtama_id,\s
                            s.mojtama,\s
                            moavenat_id,\s
                            s.moavenat,\s
                            s.omoor_id,\s
                            s.omoor\s
                    )\s
                    \s
                    select  DISTINCT \s
                    \s
                    kol.mojtama_id as complex_id\s
                    ,kol.mojtama as complex\s
                    ,sum(cast (  (ojt.sum_presence_hour_otj_mojtama /kol.kol_nafar_satat_pish_bini_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\s
                    \s
                    , kol.moavenat_id  as assistant_id\s
                    , kol.moavenat as assistant\s
                    ,sum( cast ( (ojt.sum_presence_hour_otj_moavenat /kol.kol_nafar_satat_pish_bini_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\s
                    \s
                    ,kol.omoor_id as affairs_id\s
                    ,kol.omoor as affairs\s
                    ,sum(cast ( (ojt.sum_presence_hour_otj_omoor /kol.kol_nafar_satat_pish_bini_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\s
                    \s
                    FROM\s
                     kol\s
                    LEFT JOIN   ojt\s
                    on\s
                     ojt.mojtama_id = kol.mojtama_id\s
                     and ojt.moavenat_id = kol.moavenat_id\s
                     and ojt.omoor_id = kol.omoor_id\s
                    \s
                    group by\s
                    kol.mojtama_id\s
                    ,kol.mojtama\s
                    ,ojt.sum_presence_hour_otj_mojtama \s
                    ,ojt.sum_presence_hour_otj_moavenat \s
                    ,ojt.sum_presence_hour_otj_omoor \s
                    ,kol.kol_nafar_satat_pish_bini_mojtama\s
                    ,kol.kol_nafar_satat_pish_bini_moavenat\s
                    ,kol.kol_nafar_satat_pish_bini_omoor\s
                    ,kol.moavenat_id\s
                    ,kol.moavenat\s
                    ,kol.omoor_id\s
                    ,kol.omoor\s
                    )res\s
            where\s
                (:complexNull = 1 OR complex IN (:complex))\s
                AND (:assistantNull = 1 OR assistant IN (:assistant))\s
                AND (:affairsNull = 1 OR affairs IN (:affairs))
""", nativeQuery = true)
    List<GenericStatisticalIndexReport> ojt(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);




    @Query(value = " -- nesbat amozesh hay kharej az taghvim\n" +
            " SELECT \n" +
            "            rowNum AS id,\n" +
            "               res.* FROM(\n" +
            " with in_taghvim as(\n" +
            " \n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_in_taghvim_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_in_taghvim_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_in_taghvim_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU ON EU.ID = class.CALENDAR_ID\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "          and class.C_START_DATE >= :fromDate\n" +
            "                            and class.C_START_DATE <= :toDate\n" +
            "           --and ( class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE  =>@\n" +
            "           --  )\n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor       \n" +
            "        \n" +
            " ),\n" +
            "\n" +
            "out_taghvim as(\n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_out_taghvim_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_out_taghvim_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_out_taghvim_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "               and class.id not in(\n" +
            "                                     select \n" +
            "                                      class.id\n" +
            "                                     from\n" +
            "                                     tbl_class   class \n" +
            "                                    INNER JOIN TBL_EDUCATIONAL_CALENDER EU \n" +
            "                                        ON EU.ID = class.CALENDAR_ID\n" +
            "                                  )\n" +
            "                                   and class.C_START_DATE >= :fromDate\n" +
            "                            and class.C_START_DATE <= :toDate\n" +
            "          --and  class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE =>@\n" +
            "      --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            ")\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "out_taghvim.mojtama_id as complex_id\n" +
            ",out_taghvim.mojtama as complex\n" +
            ",sum(cast (  (out_taghvim.sum_presence_hour_out_taghvim_mojtama /in_taghvim.sum_presence_hour_in_taghvim_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY out_taghvim.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", out_taghvim.moavenat_id as assistant_id\n" +
            ", out_taghvim.moavenat as assistant\n" +
            ",sum( cast ( (out_taghvim.sum_presence_hour_out_taghvim_moavenat /in_taghvim.sum_presence_hour_in_taghvim_moavenat) *100 as decimal(6,2))) OVER ( PARTITION BY  out_taghvim.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",out_taghvim.omoor_id as affairs_id\n" +
            ",out_taghvim.omoor as affairs\n" +
            ",sum(cast ( (out_taghvim.sum_presence_hour_out_taghvim_omoor /in_taghvim.sum_presence_hour_in_taghvim_omoor) *100 as decimal(6,2)) ) OVER ( PARTITION BY out_taghvim.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " out_taghvim \n" +
            "LEFT JOIN  in_taghvim\n" +
            "on\n" +
            " out_taghvim.mojtama_id = in_taghvim.mojtama_id\n" +
            " and out_taghvim.moavenat_id = in_taghvim.moavenat_id\n" +
            " and out_taghvim.omoor_id = in_taghvim.omoor_id\n" +
            "     \n" +
            "group by\n" +
            "out_taghvim.mojtama_id\n" +
            ",out_taghvim.mojtama\n" +
            ",out_taghvim.sum_presence_hour_out_taghvim_mojtama \n" +
            ",out_taghvim.sum_presence_hour_out_taghvim_moavenat\n" +
            ",out_taghvim.sum_presence_hour_out_taghvim_omoor\n" +
            ",in_taghvim.sum_presence_hour_in_taghvim_mojtama\n" +
            ",in_taghvim.sum_presence_hour_in_taghvim_moavenat\n" +
            ",in_taghvim.sum_presence_hour_in_taghvim_omoor\n" +
            ",out_taghvim.moavenat_id\n" +
            ",out_taghvim.moavenat\n" +
            ",out_taghvim.omoor_id\n" +
            ",out_taghvim.omoor\n" +
            " )res\n" +
            "           where\n" +
            "            (:complexNull = 1 OR complex IN (:complex))\n" +
            "            AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "           AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> proportionOfTrainingOutsideTheCalendar(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);



    @Query(value = "-- doreh hay laghv shodeh\n" +
            " SELECT \n" +
            "            rowNum AS id,\n" +
            "               res.* FROM(\n" +
            " with kol as(\n" +
            " \n" +
            "     SELECT \n" +
            "          SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_complex.id)      as kol_nafar_satat_pish_bini_mojtama\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_assistant.id )  as kol_nafar_satat_pish_bini_moavenat\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_affairs.id )    as kol_nafar_satat_pish_bini_omoor\n" +
            "          ,view_complex.id                                                                    as mojtama_id\n" +
            "          ,view_assistant.id                                                                  as moavenat_id\n" +
            "          ,view_affairs.id                                                                    as omoor_id\n" +
            "          ,view_complex.c_title                                                               as mojtama\n" +
            "          ,view_assistant.c_title                                                             as moavenat\n" +
            "          ,view_affairs.c_title                                                               as omoor\n" +
            "        FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd\n" +
            "                ON classstd.class_id = class.id\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "         and class.C_START_DATE >= :fromDate\n" +
            "                            and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "       GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                class.n_h_duration\n" +
            "       \n" +
            "    having   SUM(class.n_h_duration )  !=0          \n" +
            "        \n" +
            " ),\n" +
            "\n" +
            "laghv as(\n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_laghv_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_laghv_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_klaghv_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "       and class.C_STATUS = 4 -- CANCEL\n" +
            "        and class.C_START_DATE >= :fromDate\n" +
            "                            and class.C_START_DATE <= :toDate\n" +
            "          --and class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE   =>@ \n" +
            "     --     and view_complex.id =@\n" +
            "    --      and view_affairs.id =@\n" +
            "    --      and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            ")\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",sum(cast (  (laghv.sum_presence_hour_laghv_mojtama /kol.kol_nafar_satat_pish_bini_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",sum( cast ( (laghv.sum_presence_hour_laghv_moavenat /kol.kol_nafar_satat_pish_bini_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",sum(cast ( (laghv.sum_presence_hour_klaghv_omoor /kol.kol_nafar_satat_pish_bini_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol \n" +
            "LEFT JOIN  laghv\n" +
            "on\n" +
            " laghv.mojtama_id = kol.mojtama_id\n" +
            " and laghv.moavenat_id = kol.moavenat_id\n" +
            " and laghv.omoor_id = kol.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "and ( kol.mojtama_id is not null\n" +
            "     and kol.moavenat_id is not null\n" +
            "     and kol.omoor_id is not null\n" +
            "     )\n" +
            "     \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",laghv.sum_presence_hour_laghv_mojtama \n" +
            ",laghv.sum_presence_hour_laghv_moavenat \n" +
            ",laghv.sum_presence_hour_klaghv_omoor \n" +
            ",kol.kol_nafar_satat_pish_bini_mojtama\n" +
            ",kol.kol_nafar_satat_pish_bini_moavenat\n" +
            ",kol.kol_nafar_satat_pish_bini_omoor\n" +
            ", kol.moavenat_id\n" +
            ", kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            " )res\n" +
            "           where\n" +
            "            (:complexNull = 1 OR complex IN (:complex))\n" +
            "            AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "           AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> canceledCourses(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);


    @Query(value = " --nesbat amozeshi kharegh sazman\n" +
            " \n" +
            " SELECT \n" +
            "                      rowNum AS id,\n" +
            "                         res.* FROM(\n" +
            "with kol as (SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1     \n" +
            "         and class.C_START_DATE >= :fromDate\n" +
            "                                      and class.C_START_DATE <= :toDate\n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            " having  nvl(SUM(s.presence_hour) ,0)  !=0\n" +
            " ),\n" +
            "\n" +
            "kharej as(SELECT DISTINCT\n" +
            "    SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_kharej_sherkat_mojtama,\n" +
            "    SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_kharej_sherkat_moavenat,\n" +
            "    SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_kharej_sherkat_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "             outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'AbroadExtraOrganizational' ) kharej_keshvar\n" +
            "             outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'InTheCountryExtraOrganizational' )daron_keshvar\n" +
            "           \n" +
            "             \n" +
            "      WHERE 1=1\n" +
            "      AND F_HOLDING_CLASS_TYPE_ID in( kharej_keshvar.id , daron_keshvar.id )\n" +
            "      and class.C_START_DATE >= :fromDate\n" +
            "                                       and class.C_START_DATE <= :toDate\n" +
            "      --and  class.C_START_DATE <=@\n" +
            "      --and class.C_END_DATE =>@\n" +
            "--       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            ")\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "kharej.mojtama_id as complex_id\n" +
            ",kharej.mojtama as complex\n" +
            ",max(cast (kharej.sum_presence_hour_kharej_sherkat_mojtama /kol.sum_presence_hour_kol_mojtama as decimal(6,2)) ) OVER ( PARTITION BY kharej.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kharej.moavenat_id as assistant_id\n" +
            ", kharej.moavenat as assistant \n" +
            ",max( cast ( kharej.sum_presence_hour_kharej_sherkat_moavenat /kol.sum_presence_hour_kol_moavenat as decimal(6,2))) OVER ( PARTITION BY  kharej.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kharej.omoor_id as affairs_id\n" +
            ",kharej.omoor as affairs\n" +
            ",max(cast ( kharej.sum_presence_hour_kharej_sherkat_omoor /kol.sum_presence_hour_kol_omoor as decimal(6,2)) ) OVER ( PARTITION BY kharej.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kharej\n" +
            "LEFT JOIN  kol\n" +
            "on\n" +
            " kharej.mojtama_id = kol.mojtama_id\n" +
            " and kharej.moavenat_id = kol.moavenat_id\n" +
            " and kharej.omoor_id = kol.omoor_id\n" +
            "\n" +
            "group by\n" +
            "kharej.mojtama_id\n" +
            ",kharej.mojtama\n" +
            ",kharej.sum_presence_hour_kharej_sherkat_mojtama \n" +
            ",kharej.sum_presence_hour_kharej_sherkat_moavenat \n" +
            ",kharej.sum_presence_hour_kharej_sherkat_omoor \n" +
            ",kol.sum_presence_hour_kol_mojtama\n" +
            ",kol.sum_presence_hour_kol_moavenat\n" +
            ",kol.sum_presence_hour_kol_omoor\n" +
            ", kharej.moavenat_id\n" +
            ", kharej.moavenat\n" +
            ",kharej.omoor_id\n" +
            ",kharej.omoor\n" +
            ")res \n" +
            "                      where\n" +
            "                      (:complexNull = 1 OR complex IN (:complex))\n" +
            "                      AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                     AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> trainingOutsideTheOrganization(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);

    @Query(value = " --nesbat amozeshi dakhel sazman\n" +
            "  SELECT \n" +
            "                      rowNum AS id,\n" +
            "                         res.* FROM(\n" +
            "with kol as (SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1  \n" +
            "             and class.C_START_DATE >= :fromDate\n" +
            "                                       and class.C_START_DATE <= :toDate\n" +
            "       --and  class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE  =>@\n" +
            "--       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            " having  nvl(SUM(s.presence_hour) ,0)  !=0),\n" +
            "\n" +
            "dakhel as(SELECT DISTINCT\n" +
            "    SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_dakhel_sherkat_mojtama,\n" +
            "    SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_dakhel_sherkat_moavenat,\n" +
            "    SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_dakhel_sherkat_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "             outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'intraOrganizational' ) daron_sazmani\n" +
            "               \n" +
            "      WHERE 1=1\n" +
            "      AND F_HOLDING_CLASS_TYPE_ID = daron_sazmani.id\n" +
            "            and class.C_START_DATE >= :fromDate\n" +
            "                                       and class.C_START_DATE <= :toDate\n" +
            "      --and class.C_START_DATE <=@\n" +
            "      --and class.C_END_DATE  =>@\n" +
            "--        and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            ")\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "dakhel.mojtama_id as complex_id\n" +
            ",dakhel.mojtama as complex\n" +
            ",max(cast (dakhel.sum_presence_hour_dakhel_sherkat_mojtama /kol.sum_presence_hour_kol_mojtama as decimal(6,2)) ) OVER ( PARTITION BY dakhel.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", dakhel.moavenat_id as assistant_id\n" +
            ", dakhel.moavenat as assistant\n" +
            ",max( cast ( dakhel.sum_presence_hour_dakhel_sherkat_moavenat /kol.sum_presence_hour_kol_moavenat as decimal(6,2))) OVER ( PARTITION BY  dakhel.moavenat_id ) AS n_base_on_assistant\n" +
            " \n" +
            ",dakhel.omoor_id as affairs_id\n" +
            ",dakhel.omoor as affairs\n" +
            ",max(cast ( dakhel.sum_presence_hour_dakhel_sherkat_omoor /kol.sum_presence_hour_kol_omoor as decimal(6,2)) ) OVER ( PARTITION BY dakhel.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " dakhel\n" +
            "LEFT JOIN  kol\n" +
            "on\n" +
            " dakhel.mojtama_id = kol.mojtama_id\n" +
            " and dakhel.moavenat_id = kol.moavenat_id\n" +
            " and dakhel.omoor_id = kol.omoor_id\n" +
            "\n" +
            "group by\n" +
            "dakhel.mojtama_id\n" +
            ",dakhel.mojtama\n" +
            ",dakhel.sum_presence_hour_dakhel_sherkat_mojtama \n" +
            ",dakhel.sum_presence_hour_dakhel_sherkat_moavenat \n" +
            ",dakhel.sum_presence_hour_dakhel_sherkat_omoor \n" +
            ",kol.sum_presence_hour_kol_mojtama\n" +
            ",kol.sum_presence_hour_kol_moavenat\n" +
            ",kol.sum_presence_hour_kol_omoor\n" +
            ", dakhel.moavenat_id\n" +
            ", dakhel.moavenat\n" +
            ",dakhel.omoor_id\n" +
            ",dakhel.omoor\n" +
            ")res \n" +
            "                      where\n" +
            "                      (:complexNull = 1 OR complex IN (:complex))\n" +
            "                      AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                     AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> trainingWithInTheOrganization(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);


    @Query(value = "-- misan amozesh hay takhasosi be moshtarian\n" +
            " SELECT \n" +
            "                      rowNum AS id,\n" +
            "                         res.* FROM(\n" +
            "\n" +
            " with kol as(\n" +
            " \n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "                  and class.C_START_DATE >= :fromDate \n" +
            "                                                 and class.C_START_DATE <= :toDate \n" +
            "          --and  class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE =>@\n" +
            "     --     and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor  \n" +
            "HAVING  SUM(s.presence_hour) !=0        \n" +
            "        \n" +
            " )\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            " view_complex.id      as  complex_id\n" +
            ",view_complex.c_title as  complex\n" +
            ",kol.sum_presence_hour_kol_mojtama   AS n_base_on_complex\n" +
            "\n" +
            ", view_assistant.id      as assistant_id\n" +
            ", view_assistant.c_title as assistant\n" +
            ",kol.sum_presence_hour_kol_moavenat  AS n_base_on_assistant\n" +
            "\n" +
            " ,view_affairs.id      as affairs_id\n" +
            ", view_affairs.c_title as affairs\n" +
            ",kol.sum_presence_hour_kol_omoor     AS n_base_on_affairs\n" +
            "\n" +
            "FROM kol\n" +
            "LEFT JOIN  view_complex \n" +
            "    ON\n" +
            "      view_complex.id = kol.mojtama_id\n" +
            "LEFT JOIN view_affairs \n" +
            "    ON\n" +
            "      view_affairs.id = kol.omoor_id\n" +
            "LEFT JOIN view_assistant\n" +
            "    ON\n" +
            "       view_assistant.id = kol.moavenat_id\n" +
            "\n" +
            "WHERE 1=1\n" +
            "AND (\n" +
            "     kol.mojtama_id IS NOT NULL \n" +
            "     AND  kol.moavenat_id IS NOT NULL \n" +
            "     AND  kol.omoor_id IS NOT NULL \n" +
            "   )\n" +
            "   )res \n" +
            "                      where\n" +
            "                      (:complexNull = 1 OR complex IN (:complex))\n" +
            "                      AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                     AND (:affairsNull = 1 OR affairs IN (:affairs))", nativeQuery = true)
    List<GenericStatisticalIndexReport> specializedTrainingForCustomers(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);

    @Query(value = "-- saraneh amozeshay HSE\n" +
            "SELECT  \n" +
            "                                rowNum AS id, \n" +
            "                                  res.* FROM(\n" +
            "\n" +
            "with kol_hour as (\n" +
            "SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            INNER JOIN TBL_COURSE  course ON course.id = class.F_COURSE\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1  \n" +
            "        and course.C_CODE like 'SA%'\n" +
            "        \n" +
            "                            and class.C_START_DATE >= :fromDate \n" +
            "                                                 and class.C_START_DATE <= :toDate \n" +
            "            \n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "\n" +
            " ),\n" +
            "\n" +
            "karkonan as (\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as karkonan_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as karkonan_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as karkonan_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title    as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED = 0\n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title  \n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "karkonan.mojtama_id as complex_id\n" +
            ",karkonan.mojtama as complex\n" +
            ",max(cast (kol_hour.sum_presence_hour_kol_mojtama /karkonan.karkonan_mojtama as decimal(6,2)) ) OVER ( PARTITION BY karkonan.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", karkonan.moavenat_id as assistant_id\n" +
            ", karkonan.moavenat as assistant\n" +
            ",max( cast ( kol_hour.sum_presence_hour_kol_moavenat /karkonan.karkonan_moavenat as decimal(6,2))) OVER ( PARTITION BY  karkonan.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",karkonan.omoor_id as affairs_id\n" +
            ",karkonan.omoor as affairs\n" +
            ",max(cast ( kol_hour.sum_presence_hour_kol_omoor /karkonan.karkonan_omoor as decimal(6,2)) ) OVER ( PARTITION BY karkonan.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "karkonan \n" +
            "LEFT JOIN  kol_hour\n" +
            "on\n" +
            " kol_hour.mojtama_id = karkonan.mojtama_id\n" +
            " and kol_hour.moavenat_id = karkonan.moavenat_id\n" +
            " and kol_hour.omoor_id = karkonan.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           karkonan.mojtama_id is not null\n" +
            "           and karkonan.moavenat_id is not null\n" +
            "           and karkonan.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "karkonan.mojtama_id\n" +
            ",karkonan.mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_moavenat\n" +
            ",kol_hour.sum_presence_hour_kol_omoor\n" +
            ",karkonan.karkonan_mojtama\n" +
            ",karkonan.karkonan_moavenat\n" +
            ",karkonan.karkonan_omoor\n" +
            ",karkonan.moavenat_id\n" +
            ",karkonan.moavenat\n" +
            ",karkonan.omoor_id\n" +
            ",karkonan.omoor\n" +
            ")res  \n" +
            "                               where \n" +
            "                                  (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                             AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                  AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> HSE(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);
    @Query(value = " -- saraneh amozeshi paeen tar az karshenasi\n" +
            "\n" +
            "SELECT  \n" +
            "                                rowNum AS id, \n" +
            "                                  res.* FROM(\n" +
            "with kol_hour as (\n" +
            "SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM                                   \n" +
            "                 tbl_attendance att     \n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1 \n" +
            "       and ( \n" +
            "            std.POST_GRADE_TITLE is not null\n" +
            "            and std.POST_GRADE_TITLE not like '%سرپرست و کارشناس ارشد%' --farsi\n" +
            "            and std.POST_GRADE_TITLE not like '%رئیس%'  --farsi\n" +
            "            and std.POST_GRADE_TITLE not like '%معاون مدیرعامل%'  --farsi\n" +
            "            and std.POST_GRADE_TITLE not like  '%اجرایی%' --farsi\n" +
            "            and std.POST_GRADE_TITLE not like  '%مدیرعامل%' --farsi\n" +
            "            and std.POST_GRADE_TITLE not like  '%مسئول و کارشناس%' --farsi\n" +
            "            and std.POST_GRADE_TITLE not like  '%مدیر%' --farsi\n" +
            "           \n" +
            "           and std.POST_GRADE_TITLE not like '%سرپرست و کارشناس ارشد%' --arabic\n" +
            "           and std.POST_GRADE_TITLE not like '%رئیس%' --arabic\n" +
            "           and std.POST_GRADE_TITLE not like '%معاون مدیرعامل%' --arabic\n" +
            "           and std.POST_GRADE_TITLE not like '%اجرایی%' --arabic\n" +
            "           and std.POST_GRADE_TITLE not like '%مدیرعامل%' --arabic\n" +
            "           and std.POST_GRADE_TITLE not like '%مسئول و کارشناس%' --arabic\n" +
            "           and std.POST_GRADE_TITLE not like '%مدیر%' --arabic\n" +
            "            )\n" +
            "                    and class.C_START_DATE >= :fromDate \n" +
            "                                                 and class.C_START_DATE <= :toDate \n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "\n" +
            " ),\n" +
            "\n" +
            "karkonan as (\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as karkonan_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as karkonan_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as karkonan_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title    as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED =0\n" +
            "         and ( \n" +
            "            p.POST_GRADE_TITLE is not null\n" +
            "            and p.post_grade_code not in (0,10,20,21,22,23,30,31,32,33,50,51,52,60,61,62,70,71,72,73,90,91,92)--farsi\n" +

            "            )\n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title  \n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "karkonan.mojtama_id as complex_id\n" +
            ",karkonan.mojtama as complex\n" +
            ",max(cast (kol_hour.sum_presence_hour_kol_mojtama /karkonan.karkonan_mojtama as decimal(6,2)) ) OVER ( PARTITION BY karkonan.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", karkonan.moavenat_id as assistant_id\n" +
            ", karkonan.moavenat as assistant\n" +
            ",max( cast ( kol_hour.sum_presence_hour_kol_moavenat /karkonan.karkonan_moavenat as decimal(6,2))) OVER ( PARTITION BY  karkonan.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",karkonan.omoor_id as affairs_id\n" +
            ",karkonan.omoor as affairs\n" +
            ",max(cast ( kol_hour.sum_presence_hour_kol_omoor /karkonan.karkonan_omoor as decimal(6,2)) ) OVER ( PARTITION BY karkonan.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "karkonan \n" +
            "LEFT JOIN  kol_hour\n" +
            "on\n" +
            " kol_hour.mojtama_id = karkonan.mojtama_id\n" +
            " and kol_hour.moavenat_id = karkonan.moavenat_id\n" +
            " and kol_hour.omoor_id = karkonan.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           karkonan.mojtama_id is not null\n" +
            "           and karkonan.moavenat_id is not null\n" +
            "           and karkonan.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "karkonan.mojtama_id\n" +
            ",karkonan.mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_moavenat\n" +
            ",kol_hour.sum_presence_hour_kol_omoor\n" +
            ",karkonan.karkonan_mojtama\n" +
            ",karkonan.karkonan_moavenat\n" +
            ",karkonan.karkonan_omoor\n" +
            ",karkonan.moavenat_id\n" +
            ",karkonan.moavenat\n" +
            ",karkonan.omoor_id\n" +
            ",karkonan.omoor\n" +
            ")res  \n" +
            "                               where \n" +
            "                                  (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                             AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                  AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> lowerThanBachelor(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);


    @Query(value = " -- saraneh amozeshi sarparastan\n" +
            "\n" +
            "SELECT  \n" +
            "                                rowNum AS id, \n" +
            "                                  res.* FROM(\n" +
            "with kol_hour as (\n" +
            "SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM                                   \n" +
            "                 tbl_attendance att     \n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1 \n" +
            "       and (\n" +
            "            std.POST_GRADE_TITLE like '%سرپرست و کارشناس ارشد%' --farsi\n" +
            "            or\n" +
            "            std.POST_GRADE_TITLE like '%سرپرست و کارشناس ارشد%' --arabic\n" +
            "            )\n" +
            "                           and class.C_START_DATE >= :fromDate \n" +
            "                                                 and class.C_START_DATE <= :toDate \n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "\n" +
            " ),\n" +
            "\n" +
            "karkonan as (\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as karkonan_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as karkonan_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as karkonan_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title    as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED =0\n" +
            "         and ( p.post_grade_code in (60,61,62) --farsi\n" +
            "             )\n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title  \n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "karkonan.mojtama_id as complex_id\n" +
            ",karkonan.mojtama as complex\n" +
            ",max(cast (kol_hour.sum_presence_hour_kol_mojtama /karkonan.karkonan_mojtama as decimal(6,2)) ) OVER ( PARTITION BY karkonan.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", karkonan.moavenat_id as assistant_id\n" +
            ", karkonan.moavenat as assistant\n" +
            ",max( cast ( kol_hour.sum_presence_hour_kol_moavenat /karkonan.karkonan_moavenat as decimal(6,2))) OVER ( PARTITION BY  karkonan.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",karkonan.omoor_id as affairs_id\n" +
            ",karkonan.omoor as affairs\n" +
            ",max(cast ( kol_hour.sum_presence_hour_kol_omoor /karkonan.karkonan_omoor as decimal(6,2)) ) OVER ( PARTITION BY karkonan.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "karkonan \n" +
            "LEFT JOIN  kol_hour\n" +
            "on\n" +
            " kol_hour.mojtama_id = karkonan.mojtama_id\n" +
            " and kol_hour.moavenat_id = karkonan.moavenat_id\n" +
            " and kol_hour.omoor_id = karkonan.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           karkonan.mojtama_id is not null\n" +
            "           and karkonan.moavenat_id is not null\n" +
            "           and karkonan.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "karkonan.mojtama_id\n" +
            ",karkonan.mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_moavenat\n" +
            ",kol_hour.sum_presence_hour_kol_omoor\n" +
            ",karkonan.karkonan_mojtama\n" +
            ",karkonan.karkonan_moavenat\n" +
            ",karkonan.karkonan_omoor\n" +
            ",karkonan.moavenat_id\n" +
            ",karkonan.moavenat\n" +
            ",karkonan.omoor_id\n" +
            ",karkonan.omoor\n" +
            ")res  \n" +
            "                               where \n" +
            "                                  (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                             AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                  AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> trainingOfSupervisors(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);//



    @Query(value = " -- saraneh amozeshi modiran\n" +
            "\n" +
            "SELECT  \n" +
            "                                rowNum AS id, \n" +
            "                                  res.* FROM(\n" +
            "with kol_hour as (\n" +
            "SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM                                   \n" +
            "                 tbl_attendance att     \n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1 \n" +
            "       and (\n" +
            "            std.POST_GRADE_TITLE like '%مدیر%' --farsi\n" +
            "            or\n" +
            "            std.POST_GRADE_TITLE like '%مدیر%' --arabic\n" +
            "            )\n" +
            "                    and class.C_START_DATE >= :fromDate \n" +
            "                                                 and class.C_START_DATE <= :toDate \n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "\n" +
            " ),\n" +
            "\n" +
            "karkonan as (\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as karkonan_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as karkonan_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as karkonan_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title    as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED =0\n" +
            "         and ( p.post_grade_code in (30,31,32,33) --farsi\n" +
            "             )\n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title  \n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "karkonan.mojtama_id as complex_id\n" +
            ",karkonan.mojtama as complex\n" +
            ",max(cast (kol_hour.sum_presence_hour_kol_mojtama /karkonan.karkonan_mojtama as decimal(6,2)) ) OVER ( PARTITION BY karkonan.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", karkonan.moavenat_id as assistant_id\n" +
            ", karkonan.moavenat as assistant\n" +
            ",max( cast ( kol_hour.sum_presence_hour_kol_moavenat /karkonan.karkonan_moavenat as decimal(6,2))) OVER ( PARTITION BY  karkonan.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",karkonan.omoor_id as affairs_id\n" +
            ",karkonan.omoor as affairs\n" +
            ",max(cast ( kol_hour.sum_presence_hour_kol_omoor /karkonan.karkonan_omoor as decimal(6,2)) ) OVER ( PARTITION BY karkonan.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "karkonan \n" +
            "LEFT JOIN  kol_hour\n" +
            "on\n" +
            " kol_hour.mojtama_id = karkonan.mojtama_id\n" +
            " and kol_hour.moavenat_id = karkonan.moavenat_id\n" +
            " and kol_hour.omoor_id = karkonan.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           karkonan.mojtama_id is not null\n" +
            "           and karkonan.moavenat_id is not null\n" +
            "           and karkonan.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "karkonan.mojtama_id\n" +
            ",karkonan.mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_moavenat\n" +
            ",kol_hour.sum_presence_hour_kol_omoor\n" +
            ",karkonan.karkonan_mojtama\n" +
            ",karkonan.karkonan_moavenat\n" +
            ",karkonan.karkonan_omoor\n" +
            ",karkonan.moavenat_id\n" +
            ",karkonan.moavenat\n" +
            ",karkonan.omoor_id\n" +
            ",karkonan.omoor\n" +
            ")res  \n" +
            "                               where \n" +
            "                                  (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                             AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                  AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> managersTrainingPerCapita(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);



    @Query(value = " -- saraneh amozeshi peymankari\n" +
            "\n" +
            "SELECT  \n" +
            "                                rowNum AS id, \n" +
            "                                  res.* FROM(\n" +
            "with kol_hour as (\n" +
            "SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM                                   \n" +
            "                 tbl_attendance att     \n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            INNER JOIN TBL_PERSONNEL_REGISTERED R ON std.NATIONAL_CODE = R.NATIONAL_CODE -- PERSONEL_MOTEFAREGHE\n" +
            "                         \n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1 \n" +
            "         AND std.POST_GRADE_TITLE is null\n" +
            "         AND R.E_DELETED is null\n" +
            "         AND R.NATIONAL_CODE NOT IN (\n" +
            "                                     SELECT NATIONAL_CODE\n" +
            "                                     FROM\n" +
            "                                       TBL_PERSONNEL\n" +
            "                                    )\n" +
            "                                       and class.C_START_DATE >= :fromDate \n" +
            "                                                 and class.C_START_DATE <= :toDate \n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "\n" +
            " ),\n" +
            "\n" +
            "karkonan as (\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as karkonan_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as karkonan_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as karkonan_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title    as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "           INNER JOIN tbl_student std ON std.NATIONAL_CODE = p.NATIONAL_CODE\n" +
            "           INNER JOIN TBL_PERSONNEL_REGISTERED R ON std.NATIONAL_CODE = R.NATIONAL_CODE -- PERSONEL_MOTEFAREGHE\n" +
            "           \n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         AND p.DELETED =0\n" +
            "         AND p.POST_GRADE_TITLE is null\n" +
            "         AND R.E_DELETED is null\n" +
            "         AND R.NATIONAL_CODE NOT IN (\n" +
            "                                     SELECT NATIONAL_CODE\n" +
            "                                     FROM\n" +
            "                                       TBL_PERSONNEL\n" +
            "                                    ) \n" +
            "            \n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title  \n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "karkonan.mojtama_id as complex_id\n" +
            ",karkonan.mojtama as complex\n" +
            ",max(cast (kol_hour.sum_presence_hour_kol_mojtama /karkonan.karkonan_mojtama as decimal(6,2)) ) OVER ( PARTITION BY karkonan.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", karkonan.moavenat_id as assistant_id\n" +
            ", karkonan.moavenat as assistant\n" +
            ",max( cast ( kol_hour.sum_presence_hour_kol_moavenat /karkonan.karkonan_moavenat as decimal(6,2))) OVER ( PARTITION BY  karkonan.moavenat_id ) AS n_base_on_assistant\n" +
            " \n" +
            ",karkonan.omoor_id as affairs_id\n" +
            ",karkonan.omoor as affairs\n" +
            ",max(cast ( kol_hour.sum_presence_hour_kol_omoor /karkonan.karkonan_omoor as decimal(6,2)) ) OVER ( PARTITION BY karkonan.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "karkonan \n" +
            "LEFT JOIN  kol_hour\n" +
            "on\n" +
            " kol_hour.mojtama_id = karkonan.mojtama_id\n" +
            " and kol_hour.moavenat_id = karkonan.moavenat_id\n" +
            " and kol_hour.omoor_id = karkonan.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           karkonan.mojtama_id is not null\n" +
            "           and karkonan.moavenat_id is not null\n" +
            "           and karkonan.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "karkonan.mojtama_id\n" +
            ",karkonan.mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_moavenat\n" +
            ",kol_hour.sum_presence_hour_kol_omoor\n" +
            ",karkonan.karkonan_mojtama\n" +
            ",karkonan.karkonan_moavenat\n" +
            ",karkonan.karkonan_omoor\n" +
            ",karkonan.moavenat_id\n" +
            ",karkonan.moavenat\n" +
            ",karkonan.omoor_id\n" +
            ",karkonan.omoor\n" +
            ")res  \n" +
            "                               where \n" +
            "                                  (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                             AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                  AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> capitaOfContractingForces(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);



    @Query(value = "-- saraneh saat amozeshi sherkat\n" +
            "SELECT  \n" +
            "                                rowNum AS id, \n" +
            "                                  res.* FROM(\n" +
            "\n" +
            "with kol_hour as (SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1\n" +
            "          and class.C_START_DATE >= :fromDate \n" +
            "                                                 and class.C_START_DATE <= :toDate \n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "\n" +
            " ),\n" +
            "\n" +
            "karkonan as (\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as karkonan_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as karkonan_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as karkonan_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title    as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED =0\n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title  \n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "karkonan.mojtama_id as complex_id\n" +
            ",karkonan.mojtama as complex\n" +
            ",max(cast (kol_hour.sum_presence_hour_kol_mojtama /karkonan.karkonan_mojtama as decimal(6,2)) ) OVER ( PARTITION BY karkonan.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", karkonan.moavenat_id as assistant_id\n" +
            ", karkonan.moavenat as assistant\n" +
            ",max( cast ( kol_hour.sum_presence_hour_kol_moavenat /karkonan.karkonan_moavenat as decimal(6,2))) OVER ( PARTITION BY  karkonan.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",karkonan.omoor_id as affairs_id\n" +
            ",karkonan.omoor as affairs\n" +
            ",max(cast ( kol_hour.sum_presence_hour_kol_omoor /karkonan.karkonan_omoor as decimal(6,2)) ) OVER ( PARTITION BY karkonan.omoor_id ) AS n_base_on_affairs\n" +
            "FROM\n" +
            "karkonan \n" +
            "LEFT JOIN  kol_hour\n" +
            "on\n" +
            " kol_hour.mojtama_id = karkonan.mojtama_id\n" +
            " and kol_hour.moavenat_id = karkonan.moavenat_id\n" +
            " and kol_hour.omoor_id = karkonan.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           karkonan.mojtama_id is not null\n" +
            "           and karkonan.moavenat_id is not null\n" +
            "           and karkonan.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "karkonan.mojtama_id\n" +
            ",karkonan.mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_mojtama\n" +
            ",kol_hour.sum_presence_hour_kol_moavenat\n" +
            ",kol_hour.sum_presence_hour_kol_omoor\n" +
            ",karkonan.karkonan_mojtama\n" +
            ",karkonan.karkonan_moavenat\n" +
            ",karkonan.karkonan_omoor\n" +
            ",karkonan.moavenat_id\n" +
            ",karkonan.moavenat\n" +
            ",karkonan.omoor_id\n" +
            ",karkonan.omoor\n" +
            ")res  \n" +
            "                               where \n" +
            "                                  (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                             AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                  AND (:affairsNull = 1 OR affairs IN (:affairs))", nativeQuery = true)
    List<GenericStatisticalIndexReport> trainingHoursOfTheCompany(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);


    @Query(value = " -- nerkh mosharekat dar amozesh\n" +
            " SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "with kol as(\n" +
            "    select distinct \n" +
            "           sum (count_class_student)  over (partition by mojtama_id)                      as count_student_sabtenam_mojtama\n" +
            "          ,sum (count_class_student)   over (partition by moavenat_id )                 as  count_student_sabtenam_moavenat\n" +
            "          ,sum (count_class_student)  over (partition by omoor_id )                     as count_student_sabtenam_omoor\n" +
            "          ,mojtama_id\n" +
            "          ,moavenat_id\n" +
            "          ,omoor_id \n" +
            "          ,mojtama\n" +
            "          ,moavenat\n" +
            "          ,omoor \n" +
            "    from\n" +
            "    (\n" +
            "    SELECT  distinct\n" +
            "\n" +
            "          ( select count(classstd.id) from tbl_class_student classstd where classstd.class_id = class.id ) as count_class_student\n" +
            "          ,view_complex.id                                                                    as mojtama_id\n" +
            "          ,view_assistant.id                                                                  as moavenat_id\n" +
            "          ,view_affairs.id                                                                    as omoor_id \n" +
            "          ,view_complex.c_title                                                               as mojtama\n" +
            "          ,view_assistant.c_title                                                             as moavenat\n" +
            "          ,view_affairs.c_title                                                               as omoor \n" +
            "        FROM\n" +
            "                 tbl_class   class\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "        )    \n" +
            "       GROUP BY\n" +
            "           count_class_student\n" +
            "          ,mojtama_id\n" +
            "          ,moavenat_id\n" +
            "          ,omoor_id \n" +
            "          ,mojtama\n" +
            "          ,moavenat\n" +
            "          ,omoor \n" +
            "         \n" +
            "        \n" +
            " ),\n" +
            "  hazer as(\n" +
            "  \n" +
            "  select distinct \n" +
            "           sum (count_class_student)  over (partition by mojtama_id)                    as count_hazer_mojtama\n" +
            "          ,sum (count_class_student)   over (partition by moavenat_id )                 as  count_hazer_moavenat\n" +
            "          ,sum (count_class_student)  over (partition by omoor_id )                     as count_hazer_omoor\n" +
            "          ,mojtama_id\n" +
            "          ,moavenat_id\n" +
            "          ,omoor_id \n" +
            "          ,mojtama\n" +
            "          ,moavenat\n" +
            "          ,omoor \n" +
            "    from\n" +
            "    (\n" +
            "    SELECT  distinct   \n" +
            "          ( select count(classstd.id) from tbl_class_student classstd where classstd.class_id = class.id )  as count_class_student\n" +
            "          ,view_complex.id                                                                    as mojtama_id\n" +
            "          ,view_assistant.id                                                                  as moavenat_id\n" +
            "          ,view_affairs.id                                                                    as omoor_id \n" +
            "          ,view_complex.c_title                                                               as mojtama\n" +
            "          ,view_assistant.c_title                                                             as moavenat\n" +
            "          ,view_affairs.c_title                                                               as omoor \n" +
            "        FROM\n" +
            "             tbl_attendance att\n" +
            "              INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "              INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "              INNER JOIN tbl_class class on csession.f_class_id = class.id\n" +
            "           \n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "            AND att.C_STATE IN ('1','2') --hazer/ezafeh_kar\n" +
            "             and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "        group by\n" +
            "            class.id\n" +
            "           ,att.id\n" +
            "          ,view_complex.id                                                                   \n" +
            "          ,view_assistant.id                                                                  \n" +
            "          ,view_affairs.id                                                                    \n" +
            "          ,view_complex.c_title                                                              \n" +
            "          ,view_assistant.c_title                                                             \n" +
            "          ,view_affairs.c_title \n" +
            "            \n" +
            "        )    \n" +
            "       GROUP BY\n" +
            "           count_class_student\n" +
            "          ,mojtama_id\n" +
            "          ,moavenat_id\n" +
            "          ,omoor_id \n" +
            "          ,mojtama\n" +
            "          ,moavenat\n" +
            "          ,omoor \n" +
            "         \n" +
            "  \n" +
            " )\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",sum(cast (  (hazer.count_hazer_mojtama /kol.count_student_sabtenam_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",sum( cast ( (hazer.count_hazer_moavenat /kol.count_student_sabtenam_moavenat) *100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",sum(cast ( (hazer.count_hazer_omoor /kol.count_student_sabtenam_omoor) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol \n" +
            "LEFT JOIN  hazer\n" +
            "on\n" +
            " kol.mojtama_id = hazer.mojtama_id\n" +
            " and kol.moavenat_id = hazer.moavenat_id\n" +
            " and kol.omoor_id = hazer.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and ( kol.mojtama_id is not null\n" +
            "            and kol.moavenat_id is not null\n" +
            "            and kol.omoor_id is not null\n" +
            "          )\n" +
            "     \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",kol.count_student_sabtenam_mojtama \n" +
            ",kol.count_student_sabtenam_moavenat\n" +
            ",kol.count_student_sabtenam_omoor\n" +
            ",hazer.count_hazer_mojtama\n" +
            ",hazer.count_hazer_moavenat\n" +
            ",hazer.count_hazer_omoor\n" +
            ",kol.moavenat_id\n" +
            ",kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            " )res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> educationParticipationRateIndex(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);




    @Query(value = " -- nesbat amozeshay ejra shode\n" +
            "\n" +
            "SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            " with kol_barnameh as(\n" +
            " \n" +
            "     SELECT \n" +
            "          SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_complex.id)      as kol_barnameh_mojtama\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_assistant.id )  as kol_barnameh_moavenat\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_affairs.id )    as kol_barnameh_omoor\n" +
            "          ,view_complex.id                                                                    as mojtama_id\n" +
            "          ,view_assistant.id                                                                  as moavenat_id\n" +
            "          ,view_affairs.id                                                                    as omoor_id\n" +
            "          ,view_complex.c_title                                                               as mojtama\n" +
            "          ,view_assistant.c_title                                                             as moavenat\n" +
            "          ,view_affairs.c_title                                                               as omoor\n" +
            "        FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd\n" +
            "                ON classstd.class_id = class.id\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "        and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "       GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                class.n_h_duration\n" +
            "       \n" +
            "    having   SUM(class.n_h_duration )  !=0          \n" +
            "        \n" +
            " ),\n" +
            "\n" +
            "ejra as(\n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_ejra_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_ejra_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_ejra_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "           and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "           --and class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE   =>@ \n" +
            "     --     and view_complex.id =@\n" +
            "    --      and view_affairs.id =@\n" +
            "    --      and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            ")\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "kol_barnameh.mojtama_id as complex_id\n" +
            ",kol_barnameh.mojtama as complex\n" +
            ",sum(cast (  (ejra.sum_presence_hour_ejra_mojtama /kol_barnameh.kol_barnameh_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol_barnameh.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol_barnameh.moavenat_id as assistant_id\n" +
            ", kol_barnameh.moavenat as assistant\n" +
            ",sum( cast ( (ejra.sum_presence_hour_ejra_moavenat /kol_barnameh.kol_barnameh_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol_barnameh.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol_barnameh.omoor_id as affairs_id\n" +
            ",kol_barnameh.omoor as affairs\n" +
            ",sum(cast ( (ejra.sum_presence_hour_ejra_omoor /kol_barnameh.kol_barnameh_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol_barnameh.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol_barnameh \n" +
            "LEFT JOIN  ejra\n" +
            "on\n" +
            " ejra.mojtama_id = kol_barnameh.mojtama_id\n" +
            " and ejra.moavenat_id = kol_barnameh.moavenat_id\n" +
            " and ejra.omoor_id = kol_barnameh.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "and ( kol_barnameh.mojtama_id is not null\n" +
            "     and kol_barnameh.moavenat_id is not null\n" +
            "     and kol_barnameh.omoor_id is not null\n" +
            "     )\n" +
            "     \n" +
            "group by\n" +
            "kol_barnameh.mojtama_id\n" +
            ",kol_barnameh.mojtama\n" +
            ",ejra.sum_presence_hour_ejra_mojtama \n" +
            ",ejra.sum_presence_hour_ejra_moavenat \n" +
            ",ejra.sum_presence_hour_ejra_omoor\n" +
            ",kol_barnameh.kol_barnameh_mojtama\n" +
            ",kol_barnameh.kol_barnameh_moavenat\n" +
            ",kol_barnameh.kol_barnameh_omoor\n" +
            ",kol_barnameh.moavenat_id\n" +
            ",kol_barnameh.moavenat\n" +
            ",kol_barnameh.omoor_id\n" +
            ",kol_barnameh.omoor\n" +
            ")res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> indexOfTheRatioOfImplementedTrainings(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);


    @Query(value = " -- nesbat tahaghogh taghvim amozeshi(onvan doreh)\n" +
            " SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "with kol as(\n" +
            " \n" +
            "     SELECT distinct\n" +
            "            COUNT(distinct class.id)  over (partition by view_complex.id)                     as kol_doreh_pish_bini_mojtama\n" +
            "           ,COUNT(distinct class.id)   over (partition by view_assistant.id )                 as kol_doreh_pish_bini_moavenat\n" +
            "          , COUNT(distinct class.id)  over (partition by view_affairs.id )                    as kol_doreh_pish_bini_omoor\n" +
            "          ,view_complex.id                                                                    as mojtama_id\n" +
            "          ,view_assistant.id                                                                  as moavenat_id\n" +
            "          ,view_affairs.id                                                                    as omoor_id \n" +
            "          ,view_complex.c_title                                                               as mojtama\n" +
            "          ,view_assistant.c_title                                                             as moavenat\n" +
            "          ,view_affairs.c_title                                                               as omoor \n" +
            "        FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd    ON classstd.class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU   ON EU.ID = class.CALENDAR_ID\n" +
            "                 LEFT JOIN view_complex                  ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs                   ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant                 ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "           and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "       GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                class.n_h_duration\n" +
            "       \n" +
            "    having   COUNT(class.id)  !=0          \n" +
            "        \n" +
            " ),\n" +
            "  ejra_taghvim as(\n" +
            "  \n" +
            "   SELECT  distinct\n" +
            "            COUNT( distinct class.id )  over (partition by view_complex.id)                   as count_doreh_mojtama\n" +
            "           ,COUNT(distinct class.id)   over (partition by view_assistant.id )                 as  count_doreh_moavenat\n" +
            "          , COUNT(distinct class.id)  over (partition by view_affairs.id )                    as count_doreh_omoor\n" +
            "          ,view_complex.id                                                                    as mojtama_id\n" +
            "          ,view_assistant.id                                                                  as moavenat_id\n" +
            "          ,view_affairs.id                                                                    as omoor_id \n" +
            "          ,view_complex.c_title                                                               as mojtama\n" +
            "          ,view_assistant.c_title                                                             as moavenat\n" +
            "          ,view_affairs.c_title                                                               as omoor \n" +
            "        FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU ON EU.ID = class.CALENDAR_ID\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "         and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "       GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title\n" +
            "  \n" +
            " )\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",sum(cast (  (ejra_taghvim.count_doreh_mojtama /kol.kol_doreh_pish_bini_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",sum( cast ( (ejra_taghvim.count_doreh_moavenat /kol.kol_doreh_pish_bini_moavenat) *100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",sum(cast ( (ejra_taghvim.count_doreh_omoor /kol.kol_doreh_pish_bini_omoor) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol \n" +
            "LEFT JOIN  ejra_taghvim\n" +
            "on\n" +
            " kol.mojtama_id = ejra_taghvim.mojtama_id\n" +
            " and kol.moavenat_id = ejra_taghvim.moavenat_id\n" +
            " and kol.omoor_id = ejra_taghvim.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and ( kol.mojtama_id is not null\n" +
            "            and kol.moavenat_id is not null\n" +
            "            and kol.omoor_id is not null\n" +
            "          )\n" +
            "     \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",kol.kol_doreh_pish_bini_mojtama \n" +
            ",kol.kol_doreh_pish_bini_moavenat\n" +
            ",kol.kol_doreh_pish_bini_omoor\n" +
            ",ejra_taghvim.count_doreh_mojtama\n" +
            ",ejra_taghvim.count_doreh_moavenat\n" +
            ",ejra_taghvim.count_doreh_omoor\n" +
            ",kol.moavenat_id\n" +
            ",kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            ")res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> percentageOfcalendarTitleOfTheCourse(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);


    @Query(value = " -- nesbat tahaghogh taghvim amozeshi(nafar saat)\n" +
            " SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "with kol as(\n" +
            " \n" +
            "     SELECT \n" +
            "          SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_complex.id)      as kol_nafar_satat_pish_bini_mojtama\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_assistant.id )  as kol_nafar_satat_pish_bini_moavenat\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_affairs.id )    as kol_nafar_satat_pish_bini_omoor\n" +
            "          ,view_complex.id                                                                    as mojtama_id\n" +
            "          ,view_assistant.id                                                                  as moavenat_id\n" +
            "          ,view_affairs.id                                                                    as omoor_id \n" +
            "          ,view_complex.c_title                                                               as mojtama\n" +
            "          ,view_assistant.c_title                                                             as moavenat\n" +
            "          ,view_affairs.c_title                                                               as omoor \n" +
            "        FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd    ON classstd.class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU   ON EU.ID = class.CALENDAR_ID\n" +
            "                 LEFT JOIN view_complex                  ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs                   ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant                 ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "         and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "       GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                class.n_h_duration\n" +
            "       \n" +
            "    having   SUM(class.n_h_duration )  !=0          \n" +
            "        \n" +
            " ),\n" +
            "  in_taghvim as(\n" +
            " \n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_in_taghvim_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_in_taghvim_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_in_taghvim_omoor,\n" +
            "         s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "      \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU ON EU.ID = class.CALENDAR_ID\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "           and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "           --and ( class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE  =>@\n" +
            "           --  )\n" +
            "    --         and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.class_id, \n" +
            "        s.class_end_date,\n" +
            "        s.class_start_date,  \n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor       \n" +
            "        \n" +
            " )\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",sum(cast (  (in_taghvim.sum_presence_hour_in_taghvim_mojtama /kol.kol_nafar_satat_pish_bini_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",sum( cast ( (in_taghvim.sum_presence_hour_in_taghvim_moavenat /kol.kol_nafar_satat_pish_bini_moavenat) *100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id \n" +
            ",kol.omoor as affairs\n" +
            ",sum(cast ( (in_taghvim.sum_presence_hour_in_taghvim_omoor /kol.kol_nafar_satat_pish_bini_omoor) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol \n" +
            "LEFT JOIN  in_taghvim\n" +
            "on\n" +
            " kol.mojtama_id = in_taghvim.mojtama_id\n" +
            " and kol.moavenat_id = in_taghvim.moavenat_id\n" +
            " and kol.omoor_id = in_taghvim.omoor_id\n" +
            "     \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",kol.kol_nafar_satat_pish_bini_mojtama \n" +
            ",kol.kol_nafar_satat_pish_bini_moavenat\n" +
            ",kol.kol_nafar_satat_pish_bini_omoor\n" +
            ",in_taghvim.sum_presence_hour_in_taghvim_mojtama\n" +
            ",in_taghvim.sum_presence_hour_in_taghvim_moavenat\n" +
            ",in_taghvim.sum_presence_hour_in_taghvim_omoor\n" +
            ",kol.moavenat_id\n" +
            ",kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            " )res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))", nativeQuery = true)
    List<GenericStatisticalIndexReport> percentageOfcalendarTitleOfTheStudent(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);




    @Query(value = " -- tedad kol modaresan shenasai shodeh dar bank modaresan\n" +
            "SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "  SELECT  distinct\n" +
            "            view_complex.id                                                                    as complex_id\n" +
            "           ,view_complex.c_title                                                               as complex\n" +
            "          , COUNT(distinct teacher.id)  over (partition by view_complex.id)      as n_base_on_complex\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as assistant_id\n" +
            "          ,view_assistant.c_title                                                              as assistant\n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_assistant.id )   as n_base_on_assistant\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as affairs_id \n" +
            "          ,view_affairs.c_title                                                                as affairs \n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_affairs.id )     as n_base_on_affairs\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN TBL_TEACHER teacher   ON teacher.ID = class.F_TEACHER\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "           and teacher.E_DELETED is null\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "                and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                teacher.id,\n" +
            "                view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title\n" +
            "             )res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n" +
            "\n" +
            " ", nativeQuery = true)
    List<GenericStatisticalIndexReport> totalNumberOfTeachers(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = " -- tedad kol modaresan shenasai shodeh dar bank modaresan (dakheli)\n" +
            "SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "  SELECT  distinct \n" +
            "            view_complex.id                                                                    as complex_id\n" +
            "           ,view_complex.c_title                                                               as complex\n" +
            "          , COUNT(distinct teacher.id)  over (partition by view_complex.id)      as n_base_on_complex\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as assistant_id\n" +
            "          ,view_assistant.c_title                                                              as assistant\n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_assistant.id )   as n_base_on_assistant\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as affairs_id \n" +
            "          ,view_affairs.c_title                                                                as affairs \n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_affairs.id )     as n_base_on_affairs\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN TBL_TEACHER teacher   ON teacher.ID = class.F_TEACHER\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "           and teacher.E_DELETED is null\n" +
            "           and  teacher.B_PERSONNEL = 1 -- modares hamkar\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "               and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                teacher.id,\n" +
            "                view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title\n" +
            "             \n" +
            "\n" +
            " )res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> totalNumberOfInnerTeachers(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = " -- nesbat modaresan arzyabi shodeh\n" +
            " SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "with kol as(\n" +
            "  SELECT  distinct \n" +
            "            view_complex.id                                                                    as mojtama_id\n" +
            "           ,view_complex.c_title                                                               as mojtama\n" +
            "          , COUNT(distinct teacher.id)  over (partition by view_complex.id)      as kol_modares_mojtama\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as moavenat_id\n" +
            "          ,view_assistant.c_title                                                              as moavenat\n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_assistant.id )   as kol_modares_moavenat\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as omoor_id \n" +
            "          ,view_affairs.c_title                                                                as omoor \n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_affairs.id )     as kol_modares_omoor\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN TBL_TEACHER teacher   ON teacher.ID = class.F_TEACHER\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "           and teacher.E_DELETED is null\n" +
            "            and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "                and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                teacher.id,\n" +
            "                view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title\n" +
            "                \n" +
            " having COUNT(distinct teacher.id) !=0 \n" +
            " \n" +
            "  ),\n" +
            "  arzyabi as(\n" +
            "  \n" +
            "   SELECT  distinct \n" +
            "            view_complex.id                                                                    as mojtama_id\n" +
            "           ,view_complex.c_title                                                               as mojtama\n" +
            "          , COUNT(distinct teacher.id)  over (partition by view_complex.id)      as count_have_arzyabi_mojtama\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as moavenat_id\n" +
            "          ,view_assistant.c_title                                                              as moavenat\n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_assistant.id )   as count_have_arzyabi_moavenat\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as omoor_id \n" +
            "          ,view_affairs.c_title                                                                as omoor \n" +
            "          ,COUNT(distinct teacher.id)  over (partition by view_affairs.id )     as count_have_arzyabi_omoor\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN TBL_TEACHER teacher   ON teacher.ID = class.F_TEACHER\n" +
            "                 LEFT JOIN TBL_EVALUATION_ANALYSIS   n   on  n.F_TCLASS = class.id \n" +
            "                 \n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "                \n" +
            "                  \n" +
            "     WHERE 1=1\n" +
            "           and teacher.E_DELETED is null\n" +
            "           and n.C_TEACHER_GRADE is not null -- modares arzyabi shode\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "                and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                teacher.id,\n" +
            "                view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title\n" +
            "  \n" +
            "  )\n" +
            "\n" +
            "select  DISTINCT \n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama  as complex\n" +
            ",sum(cast (  (arzyabi.count_have_arzyabi_mojtama /kol.kol_modares_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",sum( cast ( (arzyabi.count_have_arzyabi_moavenat /kol.kol_modares_moavenat) *100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS  n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",sum(cast ( (arzyabi.count_have_arzyabi_omoor /kol.kol_modares_omoor) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS  n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol \n" +
            "LEFT JOIN  arzyabi\n" +
            "on\n" +
            " kol.mojtama_id = arzyabi.mojtama_id\n" +
            " and kol.moavenat_id = arzyabi.moavenat_id\n" +
            " and kol.omoor_id = arzyabi.omoor_id\n" +
            "     \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",kol.kol_modares_mojtama \n" +
            ",kol.kol_modares_moavenat\n" +
            ",kol.kol_modares_omoor\n" +
            ",arzyabi.count_have_arzyabi_mojtama\n" +
            ",arzyabi.count_have_arzyabi_moavenat\n" +
            ",arzyabi.count_have_arzyabi_omoor\n" +
            ",kol.moavenat_id\n" +
            ",kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor  \n" +
            "  )res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n" +
            "\n" +
            " ", nativeQuery = true)
    List<GenericStatisticalIndexReport> ratioOfEvaluatedTeachers(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = "   --nesbat amozeshay electronici ejra shodeh\n" +
            "   SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "with kol as (SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1   \n" +
            "        and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            " having  nvl(SUM(s.presence_hour) ,0)  !=0\n" +
            " ),\n" +
            "\n" +
            "electronic as(\n" +
            "        SELECT DISTINCT\n" +
            "            SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_electronic_mojtama,\n" +
            "            SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_electronic_moavenat,\n" +
            "            SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_electronic_omoor,\n" +
            "             s.class_id, \n" +
            "            s.class_end_date,\n" +
            "            s.class_start_date,  \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    std.id                 AS student_id,\n" +
            "                    SUM(\n" +
            "                        CASE\n" +
            "                            WHEN att.c_state IN('1', '2') THEN\n" +
            "                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                                24, 1)\n" +
            "                            ELSE\n" +
            "                                0\n" +
            "                        END\n" +
            "                    )                      AS presence_hour,\n" +
            "                   \n" +
            "                    class.c_start_date     AS class_start_date ,\n" +
            "                    class.c_end_date       AS class_end_date,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor      \n" +
            "                    , ca.C_TITLE_FA\n" +
            "                FROM\n" +
            "                         tbl_attendance att\n" +
            "                    INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                    INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                    INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                    INNER JOIN TBL_COURSE  course ON course.id = class.F_COURSE\n" +
            "                    LEFT JOIN  tbl_category ca ON ca.id = course.CATEGORY_ID\n" +
            "                     \n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "                     \n" +
            "              WHERE 1=1\n" +
            "               and  ca.C_TITLE_FA like '%برق%'\n" +
            "                --and  class.C_START_DATE <=@\n" +
            "              --and class.C_END_DATE =>@\n" +
            "        --       and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    std.id,\n" +
            "                    class.c_start_date,\n" +
            "                    class.c_end_date,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title,\n" +
            "                    csession.c_session_date,\n" +
            "                    class.c_code  \n" +
            "                    , ca.C_TITLE_FA\n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "            s.presence_hour,\n" +
            "            s.class_id, \n" +
            "            s.class_end_date,\n" +
            "            s.class_start_date,  \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            ")\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",max(cast (electronic.sum_presence_hour_electronic_mojtama /kol.sum_presence_hour_kol_mojtama as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",max( cast ( electronic.sum_presence_hour_electronic_moavenat /kol.sum_presence_hour_kol_moavenat as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",max(cast ( electronic.sum_presence_hour_electronic_omoor /kol.sum_presence_hour_kol_omoor as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "kol \n" +
            "LEFT JOIN  electronic\n" +
            "on\n" +
            " electronic.mojtama_id = kol.mojtama_id\n" +
            " and electronic.moavenat_id = kol.moavenat_id\n" +
            " and electronic.omoor_id = kol.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           kol.mojtama_id is not null\n" +
            "           and kol.moavenat_id is not null\n" +
            "           and kol.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",electronic.sum_presence_hour_electronic_mojtama \n" +
            ",electronic.sum_presence_hour_electronic_moavenat \n" +
            ",electronic.sum_presence_hour_electronic_omoor \n" +
            ",kol.sum_presence_hour_kol_mojtama\n" +
            ",kol.sum_presence_hour_kol_moavenat\n" +
            ",kol.sum_presence_hour_kol_omoor\n" +
            ", kol.moavenat_id\n" +
            ", kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            ")res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> electronicallyExecuted(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = "--nesbat amozeshay gheir hozori ejra shodeh\n" +
            "\n" +
            "SELECT \n" +
            "                                          rowNum AS id,\n" +
            "                                           res.* FROM(\n" +
            "with kol as (SELECT DISTINCT\n" +
            "    SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "     SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "     SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "     s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            "  \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            class.id               AS class_id,\n" +
            "            std.id                 AS student_id,\n" +
            "            SUM(\n" +
            "                CASE\n" +
            "                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                        24, 1)\n" +
            "                    ELSE\n" +
            "                        0\n" +
            "                END\n" +
            "            )                      AS presence_hour,\n" +
            "           \n" +
            "            class.c_start_date     AS class_start_date ,\n" +
            "            class.c_end_date       AS class_end_date,\n" +
            "            class.complex_id       AS mojtama_id,\n" +
            "            view_complex.c_title   AS mojtama,\n" +
            "            class.assistant_id     AS moavenat_id,\n" +
            "            view_assistant.c_title AS moavenat,\n" +
            "            class.affairs_id       AS omoor_id,\n" +
            "            view_affairs.c_title   AS omoor\n" +
            "        FROM\n" +
            "                 tbl_attendance att\n" +
            "            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "       where 1=1     \n" +
            "        and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "       --and class.C_START_DATE <=@\n" +
            "       --and class.C_END_DATE =>@\n" +
            " --       and view_complex.id =@\n" +
            "--       and view_affairs.id =@\n" +
            "--       and view_assistant.id =@\n" +
            "            \n" +
            "        GROUP BY\n" +
            "            class.id,\n" +
            "            std.id,\n" +
            "            class.c_start_date,\n" +
            "            class.c_end_date,\n" +
            "            view_complex.c_title,\n" +
            "            class.complex_id,\n" +
            "            class.assistant_id,\n" +
            "            class.affairs_id,\n" +
            "            view_assistant.c_title,\n" +
            "            view_affairs.c_title,\n" +
            "            csession.c_session_date,\n" +
            "            class.c_code\n" +
            "    ) s\n" +
            "GROUP BY\n" +
            "    s.presence_hour,\n" +
            "    s.class_id, \n" +
            "    s.class_end_date,\n" +
            "    s.class_start_date,  \n" +
            "    s.mojtama_id,\n" +
            "    s.mojtama,\n" +
            "    moavenat_id,\n" +
            "    s.moavenat,\n" +
            "    s.omoor_id,\n" +
            "    s.omoor\n" +
            " having  nvl(SUM(s.presence_hour) ,0)  !=0\n" +
            " ),\n" +
            "\n" +
            "electronic as(\n" +
            "        SELECT DISTINCT\n" +
            "            SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_electronic_mojtama,\n" +
            "            SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_electronic_moavenat,\n" +
            "            SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_electronic_omoor,\n" +
            "             s.class_id, \n" +
            "            s.class_end_date,\n" +
            "            s.class_start_date,  \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    std.id                 AS student_id,\n" +
            "                    SUM(\n" +
            "                        CASE\n" +
            "                            WHEN att.c_state IN('1', '2') THEN\n" +
            "                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                                24, 1)\n" +
            "                            ELSE\n" +
            "                                0\n" +
            "                        END\n" +
            "                    )                      AS presence_hour,\n" +
            "                   \n" +
            "                    class.c_start_date     AS class_start_date ,\n" +
            "                    class.c_end_date       AS class_end_date,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                         tbl_attendance att\n" +
            "                    INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                    INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                    INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                    INNER JOIN TBL_CLASS_STUDENT class_std on class_std.class_id = class.id\n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "                      outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'kh' ) khod_amokhteh\n" +
            "                     \n" +
            "              WHERE 1=1\n" +
            "              AND  class.C_TEACHING_TYPE = 'مجازی'\n" +
            "              AND class_std.PRESENCE_TYPE_ID = khod_amokhteh.id\n" +
            "               and class.C_START_DATE >= :fromDate  \n" +
            "                                                             and class.C_START_DATE <= :toDate\n" +
            "              \n" +
            "                --and  class.C_START_DATE <=@\n" +
            "              --and class.C_END_DATE =>@\n" +
            "        --       and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    std.id,\n" +
            "                    class.c_start_date,\n" +
            "                    class.c_end_date,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title,\n" +
            "                    csession.c_session_date,\n" +
            "                    class.c_code\n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "            s.presence_hour,\n" +
            "            s.class_id, \n" +
            "            s.class_end_date,\n" +
            "            s.class_start_date,  \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            ")\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",max(cast (electronic.sum_presence_hour_electronic_mojtama /kol.sum_presence_hour_kol_mojtama as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",max( cast ( electronic.sum_presence_hour_electronic_moavenat /kol.sum_presence_hour_kol_moavenat as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",max(cast ( electronic.sum_presence_hour_electronic_omoor /kol.sum_presence_hour_kol_omoor as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "kol \n" +
            "LEFT JOIN  electronic\n" +
            "on\n" +
            " electronic.mojtama_id = kol.mojtama_id\n" +
            " and electronic.moavenat_id = kol.moavenat_id\n" +
            " and electronic.omoor_id = kol.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           kol.mojtama_id is not null\n" +
            "           and kol.moavenat_id is not null\n" +
            "           and kol.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",electronic.sum_presence_hour_electronic_mojtama \n" +
            ",electronic.sum_presence_hour_electronic_moavenat \n" +
            ",electronic.sum_presence_hour_electronic_omoor \n" +
            ",kol.sum_presence_hour_kol_mojtama\n" +
            ",kol.sum_presence_hour_kol_moavenat\n" +
            ",kol.sum_presence_hour_kol_omoor\n" +
            ", kol.moavenat_id\n" +
            ", kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            " )res\n" +
            "\n" +
            " where \n" +
            "                                             (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                       AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                             AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> performedInAbsentia(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = "  SELECT \n" +
            "                                                      rowNum AS id,\n" +
            "                                                   res.* FROM(\n" +
            " SELECT\n" +
            "     case\n" +
            "when kol = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(modiriati / kol , 2)  \n" +
            "end AS n_base_on_complex\n" +
            "\n" +
            "\n" +
            "\n" +
            "     FROM \n" +
            "     \n" +
            "     (\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "\n" +
            "  \n" +
            "\n" +
            "     count(distinct case when e_technical_type = 3 then id end)  OVER(PARTITION BY e_technical_type)  as modiriati \n" +
            " \n" +
            ",\n" +
            "     (\n" +
            "SELECT\n" +
            " \n" +
            "\n" +
            "    COUNT(*) as kol\n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_course.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_course.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')) as kol\n" +
            " \n" +
            "\n" +
            "from\n" +
            "(\n" +
            "\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "\n" +
            "    tbl_course.id,\n" +
            "    tbl_course.e_technical_type,\n" +
            "    \n" +
            "    CASE\n" +
            "        WHEN tbl_course.e_technical_type = '1' THEN\n" +
            "            'عمومی'\n" +
            "        WHEN tbl_course.e_technical_type = '2' THEN\n" +
            "            'تخصصی'\n" +
            "        WHEN tbl_course.e_technical_type = '3' THEN\n" +
            "            'مدیریتی'\n" +
            "    END AS technical_title,\n" +
            "   \n" +
            "     TO_CHAR(tbl_course.d_created_date,'yyyy/mm/dd','nls_calendar=persian') as date_time\n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL\n" +
            "\n" +
            "    and\n" +
            "    e_technical_type = 3 \n" +
            "    and\n" +
            "     tbl_course.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_course.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            ") ) ) res", nativeQuery = true)
    List<Object> proportionOfDesignedManagementCourses(String fromDate,
                                                       String toDate);







    @Query(value = "  SELECT \n" +
            "                                                      rowNum AS id,\n" +
            "                                                   res.* FROM(\n" +
            " SELECT\n" +
            " DISTINCT\n" +
            "     case\n" +
            "when kol = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(inRange / kol , 5) * 100  \n" +
            "end AS n_base_on_complex\n" +
            " \n" +
            "\n" +
            "     FROM \n" +
            "     \n" +
            "     \n" +
            "     (SELECT\n" +
            " COUNT(*) as kol\n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL)  kol ,\n" +
            "    (SELECT\n" +
            " \n" +
            "\n" +
            "    COUNT(*)  as inRange\n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_course.d_last_modified_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_course.d_last_modified_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  inRange\n" +
            "     \n" +
            "    , (SELECT\n" +
            " \n" +
            "\n" +
            "   TO_CHAR(tbl_course.d_last_modified_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime,\n" +
            "    tbl_course.c_last_modified_by as modified_by\n" +
            " \n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_course.d_last_modified_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_course.d_last_modified_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  dateTime\n" +
            "-- \n" +
            "  ) res", nativeQuery = true)
    List<Object> revisedLessonPlansRatio(String fromDate,
                                                       String toDate);






    @Query(value = "  SELECT \n" +
            "                                                      rowNum AS id,\n" +
            "                                                   res.* FROM(\n" +
            " SELECT\n" +
            " DISTINCT\n" +
            "     case\n" +
            "when kol = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(inRange / kol , 5) * 100  \n" +
            "end AS n_base_on_complex\n" +
            " \n" +
            "   \n" +
            "     FROM \n" +
            "     \n" +
            "     \n" +
            "     (SELECT\n" +
            " COUNT(*) as kol\n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL)  kol ,\n" +
            "    (SELECT\n" +
            " \n" +
            "\n" +
            "    COUNT(*)  as inRange\n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_course.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_course.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  inRange\n" +
            "     \n" +
            "    , (SELECT\n" +
            " \n" +
            "\n" +
            "   TO_CHAR(tbl_course.d_created_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime\n" +
            " \n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_course\n" +
            "WHERE\n" +
            "    tbl_course.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_course.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_course.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  dateTime\n" +
            "  \n" +
            "  ) res", nativeQuery = true)
    List<Object> proportionOfNewLessonPlans(String fromDate,
                                                       String toDate);





    @Query(value = """
            -- Report38 nerkh nofoz amozesh\s
          \s
           SELECT  \s
          rowNum AS id, \s
           res.* FROM( \s
                           SELECT DISTINCT \s
                    \s
                               s.mojtama_id  as complex_id, \s
                               s.mojtama     as complex, \s
                               SUM(s.presence_hour) over (partition by  s.mojtama)  AS n_base_on_complex, \s
                                \s
                               s.moavenat_id as assistant_id, \s
                               s.moavenat    as assistant, \s
                               SUM(s.presence_hour) over (partition by  s.moavenat)  AS n_base_on_assistant, \s
                                \s
                               s.omoor_id   as affairs_id, \s
                               s.omoor      as affairs, \s
                               SUM(s.presence_hour) over (partition by  s.omoor)  AS n_base_on_affairs \s
                            \s
                           FROM \s
                               ( \s
                                   SELECT \s
                                       class.id               AS class_id, \s
                                       tbl_student.id                 AS student_id, \s
                                       SUM( \s
                                           CASE \s
                                               WHEN att.c_state IN('1', '2') THEN \s
                                                   round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) * \s
                                                   24, 1) \s
                                               ELSE \s
                                                   0 \s
                                           END \s
                                       )                      AS presence_hour, \s
                                       \s
                                       class.c_start_date     AS class_start_date , \s
                                       class.c_end_date       AS class_end_date, \s
                                       view_complex.id        AS mojtama_id,
                                       view_complex.c_title   AS mojtama,
                                       view_assistant.id      AS moavenat_id,
                                       view_assistant.c_title AS moavenat,
                                       view_affairs.id        AS omoor_id,
                                       view_affairs.c_title   AS omoor
             \s
                                   FROM \s
                                            tbl_attendance att \s
                                       INNER JOIN tbl_session csession ON att.f_session = csession.id \s
                                       INNER JOIN tbl_class   class ON csession.f_class_id = class.id \s
                                      \s
                                       INNER JOIN
                                          (
                                            select
                                                  tbl_student.id                                                         as id
                                                 ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                                 ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                                 ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                            \s
                                             from tbl_student\s
                                              LEFT JOIN view_last_md_employee_hr
                                              ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                          )
                                           tbl_student ON att.f_student = tbl_student.id\s
                                          RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                          RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                          RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
          \s
                                 WHERE 1=1 \s
                                 and class.C_START_DATE >=  :fromDate
                                 and class.C_START_DATE <=  :toDate
                       --        and class.C_STATUS in (3,5) --finish/lock \s
                                  \s
                                 GROUP BY \s
                                       class.id, \s
                                       tbl_student.id, \s
                                       class.c_start_date, \s
                                       class.c_end_date,\s
                                       csession.c_session_date, \s
                                       class.c_code, \s
                                       view_complex.id,
                                      view_complex.c_title,
                                      view_assistant.id,
                                      view_assistant.c_title,
                                      view_affairs.id,
                                      view_affairs.c_title
            \s
                               ) s \s
                               where 1=1 \s
                                    and (  s.mojtama_id is not null \s
                                            and moavenat_id is not null \s
                                            and s.omoor_id is not null \s
                                            and  s.omoor is not null \s
                                        ) \s
                           GROUP BY \s
                               s.presence_hour, \s
                               s.mojtama_id, \s
                               s.mojtama, \s
                               s.moavenat_id, \s
                               s.moavenat, \s
                               s.omoor_id, \s
                               s.omoor, \s
                               s.omoor  \s
                       \s
                       )res \s
                                  \s
          where  \s
               (:complexNull = 1 OR complex IN (:complex))  \s
               AND (:assistantNull = 1 OR assistant IN (:assistant))  \s
               AND (:affairsNull = 1 OR affairs IN (:affairs))\s
  """, nativeQuery = true)
    List<GenericStatisticalIndexReport> educationPenetrationRate(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = "  -- nerkh nofoz amozesh dar kol\n" +
            "\n" +
            "\n" +
            "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "\n" +
            "    SELECT DISTINCT\n" +
            "        s.mojtama_id as complex_id,\n" +
            "        s.mojtama as complex,\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS n_base_on_complex,\n" +
            "        \n" +
            "        s.moavenat_id as assistant_id,\n" +
            "         s.moavenat as assistant,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS n_base_on_assistant,\n" +
            "        \n" +
            "        s.omoor_id as affairs_id,\n" +
            "        s.omoor as affairs,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS n_base_on_affairs\n" +
            "   \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "           and class.C_STATUS in (3,5) --finish/lock\n" +
            "               and class.C_START_DATE >= :fromDate  \n" +
            "                                                                       and class.C_START_DATE <= :toDate\n" +
            "           --and class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE   =>@ \n" +
            "     --     and view_complex.id =@\n" +
            "    --      and view_affairs.id =@\n" +
            "    --      and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "        where 1=1\n" +
            "             and (  s.mojtama_id is not null\n" +
            "                     and moavenat_id is not null\n" +
            "                     and s.omoor_id is not null\n" +
            "                 )\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            ")res\n" +
            "          \n" +
            "            where \n" +
            "                                                        (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                                  AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                                        AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> rateOfEducationInGeneral(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);




    @Query(value = "   -- nerkh nofoz amozesh dar yek sal morede andazeh ghiri\n" +
            "\n" +
            "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "\n" +
            "    SELECT DISTINCT\n" +
            "       s.mojtama_id as complex_id,\n" +
            "        s.mojtama as complex,\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS n_base_on_complex,\n" +
            "        \n" +
            "         s.moavenat_id as assistant_id,\n" +
            "        s.moavenat as assistant,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS n_base_on_assistant,\n" +
            "        \n" +
            "       s.omoor_id as affairs_id,\n" +
            "        s.omoor as affairs,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS n_base_on_affairs\n" +
            "   \n" +
            "    FROM\n" +
            "        (\n" +
            "            SELECT\n" +
            "                class.id               AS class_id,\n" +
            "                std.id                 AS student_id,\n" +
            "                SUM(\n" +
            "                    CASE\n" +
            "                        WHEN att.c_state IN('1', '2') THEN\n" +
            "                            round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                            24, 1)\n" +
            "                        ELSE\n" +
            "                            0\n" +
            "                    END\n" +
            "                )                      AS presence_hour,\n" +
            "               \n" +
            "                class.c_start_date     AS class_start_date ,\n" +
            "                class.c_end_date       AS class_end_date,\n" +
            "                class.complex_id       AS mojtama_id,\n" +
            "                view_complex.c_title   AS mojtama,\n" +
            "                class.assistant_id     AS moavenat_id,\n" +
            "                view_assistant.c_title AS moavenat,\n" +
            "                class.affairs_id       AS omoor_id,\n" +
            "                view_affairs.c_title   AS omoor\n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "           and class.C_STATUS in (3,5) --finish/lock\n" +
            "                 and class.C_START_DATE >= :fromDate  \n" +
            "                                                                       and class.C_START_DATE <= :toDate\n" +
            "           --and class.C_START_DATE <=@\n" +
            "          --and class.C_END_DATE   =>@ \n" +
            "     --     and view_complex.id =@\n" +
            "    --      and view_affairs.id =@\n" +
            "    --      and view_assistant.id =@\n" +
            "                \n" +
            "            GROUP BY\n" +
            "                class.id,\n" +
            "                std.id,\n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                view_complex.c_title,\n" +
            "                class.complex_id,\n" +
            "                class.assistant_id,\n" +
            "                class.affairs_id,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                csession.c_session_date,\n" +
            "                class.c_code\n" +
            "        ) s\n" +
            "        where 1=1\n" +
            "             and (  s.mojtama_id is not null\n" +
            "                     and moavenat_id is not null\n" +
            "                     and s.omoor_id is not null\n" +
            "                 )\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor\n" +
            "   -- nerkh nofoz amozesh dar yek sal morede andazeh ghiri\n" +
            "\n" +
            "\n" +
            ")res\n" +
            "          \n" +
            "            where \n" +
            "                                                        (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                                  AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                                        AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> rateOfEducationInOneYear(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = "\n" +
            "\n" +
            "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "\n" +
            "    \n" +
            "    CASE\n" +
            "        WHEN kol = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round( post / kol, 5) * 100\n" +
            "    END       AS  n_base_on_complex \n" +
            "    \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as kol\n" +
            "        FROM\n" +
            "            (\n" +
            "             SELECT DISTINCT\n" +
            "    tbl_post_grade.c_title_fa\n" +
            "FROM\n" +
            "    tbl_post_grade\n" +
            "WHERE\n" +
            "    tbl_post_grade.e_deleted IS NULL\n" +
            "    AND tbl_post_grade.d_created_date >= to_date(:fromDate , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "    AND tbl_post_grade.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "    AND\n" +
            "    (\n" +
            "    tbl_post_grade.c_title_fa LIKE '%تکنسین%'\n" +
            "    )\n" +
            "             \n" +
            "            )\n" +
            "    ) kol ,\n" +
            "    \n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as post\n" +
            "        FROM\n" +
            "            (\n" +
            "                \n" +
            "SELECT DISTINCT\n" +
            "    * FROM\n" +
            "    (\n" +
            "\n" +
            "select tposttitle as post from (\n" +
            "SELECT\n" +
            "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_needs_assessment.c_object_type,\n" +
            "            tbl_needs_assessment.f_object,\n" +
            "            tpost.f_post_grade_id AS tpost,\n" +
            "            post.f_post_grade_id  AS post,\n" +
            "            tbl_post_grade.c_title_fa as postTitle\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment left\n" +
            "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
            "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
            "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
            "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
            "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
            "        WHERE\n" +
            "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
            "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
            "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                   \n" +
            "    ) f left\n" +
            "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
            "    WHERE\n" +
            "    (\n" +
            "    tbl_post_grade.c_title_fa LIKE '%تکنسین%'\n" +
            "    OR\n" +
            "    postTitle LIKE '%تکنسین%'\n" +
            "    )\n" +
            "\n" +
            ")\n" +
            "union\n" +
            "select postTitle as post from (\n" +
            "SELECT\n" +
            "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_needs_assessment.c_object_type,\n" +
            "            tbl_needs_assessment.f_object,\n" +
            "            tpost.f_post_grade_id AS tpost,\n" +
            "            post.f_post_grade_id  AS post,\n" +
            "            tbl_post_grade.c_title_fa as postTitle\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment left\n" +
            "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
            "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
            "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
            "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
            "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
            "        WHERE\n" +
            "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
            "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
            "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                   \n" +
            "    ) f left\n" +
            "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
            "    WHERE\n" +
            "    tbl_post_grade.c_title_fa LIKE '%تکنسین%'\n" +
            "    OR\n" +
            "    postTitle LIKE '%تکنسین%'\n" +
            ")\n" +
            ")\n" +
            " where\n" +
            "post is not null\n" +
            "     ) \n" +
            "    ) post  , (SELECT\n" +
            " \n" +
            "\n" +
            "   TO_CHAR(tbl_needs_assessment.d_created_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime\n" +
            " \n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_needs_assessment\n" +
            "WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate , 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  dateTime\n" +
            " \n" +
            "     )res\n" +
            " ", nativeQuery = true)
    List<Object> lowerThanExpertise(String fromDate,
                                                       String toDate);




    @Query(value = "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "\n" +
            "    \n" +
            "    CASE\n" +
            "        WHEN kol = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round( post / kol, 5) * 100\n" +
            "    END       AS  n_base_on_complex\n" +
            "    \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as kol\n" +
            "        FROM\n" +
            "            (\n" +
            "             SELECT DISTINCT\n" +
            "    tbl_post_grade.c_title_fa\n" +
            "FROM\n" +
            "    tbl_post_grade\n" +
            "WHERE\n" +
            "    tbl_post_grade.e_deleted IS NULL\n" +
            "    AND tbl_post_grade.d_created_date >= to_date(:fromDate  , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "    AND tbl_post_grade.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "    AND\n" +
            "    (\n" +
            "    tbl_post_grade.c_title_fa LIKE '%سرپرست%'\n" +
            "    )\n" +
            "             \n" +
            "            )\n" +
            "    ) kol ,\n" +
            "    \n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as post\n" +
            "        FROM\n" +
            "            (\n" +
            "                \n" +
            "SELECT DISTINCT\n" +
            "    * FROM\n" +
            "    (\n" +
            "\n" +
            "select tposttitle as post from (\n" +
            "SELECT\n" +
            "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_needs_assessment.c_object_type,\n" +
            "            tbl_needs_assessment.f_object,\n" +
            "            tpost.f_post_grade_id AS tpost,\n" +
            "            post.f_post_grade_id  AS post,\n" +
            "            tbl_post_grade.c_title_fa as postTitle\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment left\n" +
            "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
            "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
            "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
            "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
            "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
            "        WHERE\n" +
            "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
            "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
            "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate  , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                   \n" +
            "    ) f left\n" +
            "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
            "    WHERE\n" +
            "    (\n" +
            "   tbl_post_grade.c_title_fa LIKE '%سرپرست%'\n" +
            "    OR\n" +
            "    postTitle LIKE '%سرپرست%'\n" +
            "    )\n" +
            "\n" +
            ")\n" +
            "union\n" +
            "select postTitle as post from (\n" +
            "SELECT\n" +
            "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_needs_assessment.c_object_type,\n" +
            "            tbl_needs_assessment.f_object,\n" +
            "            tpost.f_post_grade_id AS tpost,\n" +
            "            post.f_post_grade_id  AS post,\n" +
            "            tbl_post_grade.c_title_fa as postTitle\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment left\n" +
            "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
            "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
            "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
            "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
            "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
            "        WHERE\n" +
            "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
            "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
            "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate  , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                   \n" +
            "    ) f left\n" +
            "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
            "    WHERE\n" +
            "    tbl_post_grade.c_title_fa LIKE '%سرپرست%'\n" +
            "    OR\n" +
            "    postTitle LIKE '%سرپرست%'\n" +
            ")\n" +
            ")\n" +
            "where\n" +
            "post is not null\n" +
            " \n" +
            "     ) \n" +
            "    ) post  , (SELECT\n" +
            " \n" +
            "\n" +
            "   TO_CHAR(tbl_needs_assessment.d_created_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime\n" +
            " \n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_needs_assessment\n" +
            "WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate  , 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  dateTime\n" +
            " \n" +
            "     )res\n" +
            " ", nativeQuery = true)
    List<Object> supervisionJob(String fromDate,
                                                       String toDate);



    @Query(value = "\n" +
            "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "\n" +
            "    \n" +
            "    CASE\n" +
            "        WHEN kol = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round( post / kol, 5) * 100\n" +
            "    END       AS  n_base_on_complex\n" +
            "     \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as kol\n" +
            "        FROM\n" +
            "            (\n" +
            "             SELECT DISTINCT\n" +
            "    tbl_post_grade.c_title_fa\n" +
            "FROM\n" +
            "    tbl_post_grade\n" +
            "WHERE\n" +
            "    tbl_post_grade.e_deleted IS NULL\n" +
            "    AND tbl_post_grade.d_created_date >= to_date(:fromDate , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "    AND tbl_post_grade.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "    AND\n" +
            "    (\n" +
            "    tbl_post_grade.c_title_fa LIKE '%مسئول و کارشناس%'\n" +
            "   \n" +
            "    )\n" +
            "             \n" +
            "            )\n" +
            "    ) kol ,\n" +
            "    \n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as post\n" +
            "        FROM\n" +
            "            (\n" +
            "                \n" +
            "SELECT DISTINCT\n" +
            "    * FROM\n" +
            "    (\n" +
            "\n" +
            "select tposttitle as post from (\n" +
            "SELECT\n" +
            "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_needs_assessment.c_object_type,\n" +
            "            tbl_needs_assessment.f_object,\n" +
            "            tpost.f_post_grade_id AS tpost,\n" +
            "            post.f_post_grade_id  AS post,\n" +
            "            tbl_post_grade.c_title_fa as postTitle\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment left\n" +
            "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
            "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
            "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
            "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
            "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
            "        WHERE\n" +
            "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
            "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
            "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                   \n" +
            "    ) f left\n" +
            "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
            "    WHERE\n" +
            "    (\n" +
            "   tbl_post_grade.c_title_fa LIKE '%مسئول و کارشناس%'\n" +
            "    OR\n" +
            "    postTitle LIKE '%مسئول و کارشناس%'\n" +
            "  \n" +
            "    )\n" +
            "\n" +
            ")\n" +
            "union\n" +
            "select postTitle as post from (\n" +
            "SELECT\n" +
            "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_needs_assessment.c_object_type,\n" +
            "            tbl_needs_assessment.f_object,\n" +
            "            tpost.f_post_grade_id AS tpost,\n" +
            "            post.f_post_grade_id  AS post,\n" +
            "            tbl_post_grade.c_title_fa as postTitle\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment left\n" +
            "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
            "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
            "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
            "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
            "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
            "        WHERE\n" +
            "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
            "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
            "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate , 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
            "                   \n" +
            "    ) f left\n" +
            "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
            "    WHERE\n" +
            "    tbl_post_grade.c_title_fa LIKE '%مسئول و کارشناس%'\n" +
            "    OR\n" +
            "    postTitle LIKE '%مسئول و کارشناس%'\n" +
            "  \n" +
            ")\n" +
            ")\n" +
            "where\n" +
            "post is not null\n" +
            " \n" +
            "     ) \n" +
            "    ) post  , (SELECT\n" +
            " \n" +
            "\n" +
            "   TO_CHAR(tbl_needs_assessment.d_created_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime\n" +
            " \n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_needs_assessment\n" +
            "WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate , 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  dateTime\n" +
            " \n" +
            "     )res\n" +
            " ", nativeQuery = true)
    List<Object> mastersJob(String fromDate,
                                                       String toDate);


        @Query(value = "\n" +
                "SELECT \n" +
                "                                                   rowNum AS id,\n" +
                "                                                    res.* FROM(\n" +
                "SELECT\n" +
                "DISTINCT\n" +
                "\n" +
                "    \n" +
                "    CASE\n" +
                "        WHEN kol = 0 THEN\n" +
                "            0\n" +
                "        ELSE\n" +
                "            round( post / kol, 5) * 100\n" +
                "    END       AS  n_base_on_complex\n" +
                " \n" +
                "    \n" +
                "FROM\n" +
                "    (\n" +
                "        SELECT\n" +
                "            COUNT(*) as kol\n" +
                "        FROM\n" +
                "            (\n" +
                "             SELECT DISTINCT\n" +
                "    tbl_post_grade.c_title_fa\n" +
                "FROM\n" +
                "    tbl_post_grade\n" +
                "WHERE\n" +
                "    tbl_post_grade.e_deleted IS NULL\n" +
                "    AND tbl_post_grade.d_created_date >= to_date(:fromDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
                "    AND tbl_post_grade.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
                "    AND\n" +
                "    (\n" +
                "    tbl_post_grade.c_title_fa LIKE '%مدیر%'\n" +
                "    )\n" +
                "             \n" +
                "            )\n" +
                "    ) kol ,\n" +
                "    \n" +
                "    (\n" +
                "        SELECT\n" +
                "            COUNT(*) as post\n" +
                "        FROM\n" +
                "            (\n" +
                "                \n" +
                "SELECT DISTINCT\n" +
                "    * FROM\n" +
                "    (\n" +
                "\n" +
                "select tposttitle as post from (\n" +
                "SELECT\n" +
                "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
                "FROM\n" +
                "         (\n" +
                "        SELECT DISTINCT\n" +
                "            tbl_needs_assessment.c_object_type,\n" +
                "            tbl_needs_assessment.f_object,\n" +
                "            tpost.f_post_grade_id AS tpost,\n" +
                "            post.f_post_grade_id  AS post,\n" +
                "            tbl_post_grade.c_title_fa as postTitle\n" +
                "        FROM\n" +
                "                 tbl_needs_assessment left\n" +
                "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
                "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
                "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
                "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
                "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
                "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
                "        WHERE\n" +
                "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
                "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
                "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
                "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
                "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
                "                   \n" +
                "    ) f left\n" +
                "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
                "    WHERE\n" +
                "    (\n" +
                "    tbl_post_grade.c_title_fa LIKE '%مدیر%'\n" +
                "    OR\n" +
                "    postTitle LIKE '%مدیر%'\n" +
                "    )\n" +
                "\n" +
                ")\n" +
                "union\n" +
                "select postTitle as post from (\n" +
                "SELECT\n" +
                "    tbl_post_grade.c_title_fa AS tposttitle, postTitle \n" +
                "FROM\n" +
                "         (\n" +
                "        SELECT DISTINCT\n" +
                "            tbl_needs_assessment.c_object_type,\n" +
                "            tbl_needs_assessment.f_object,\n" +
                "            tpost.f_post_grade_id AS tpost,\n" +
                "            post.f_post_grade_id  AS post,\n" +
                "            tbl_post_grade.c_title_fa as postTitle\n" +
                "        FROM\n" +
                "                 tbl_needs_assessment left\n" +
                "            JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id\n" +
                "            LEFT JOIN tbl_training_post tpost ON tbl_needs_assessment.f_object = tpost.id\n" +
                "                                                             AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
                "            LEFT JOIN tbl_post          post ON tbl_needs_assessment.f_object = post.id\n" +
                "                                                   AND tbl_needs_assessment.c_object_type = 'Post'\n" +
                "            LEFT JOIN tbl_post_grade ON post.f_post_grade_id = tbl_post_grade.id\n" +
                "        WHERE\n" +
                "            ( tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
                "              OR tbl_needs_assessment.c_object_type = 'Post' )\n" +
                "            AND tbl_needs_assessment.e_deleted IS NULL\n" +
                "                AND tbl_needs_assessment.d_created_date >= to_date(:fromDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
                "                    AND tbl_needs_assessment.d_created_date < to_date(:toDate, 'yyyy/mm/dd', 'nls_calendar=persian')\n" +
                "                   \n" +
                "    ) f left\n" +
                "    JOIN tbl_post_grade ON tpost = tbl_post_grade.id\n" +
                "    WHERE\n" +
                "    tbl_post_grade.c_title_fa LIKE '%مدیر%'\n" +
                "    OR\n" +
                "    postTitle LIKE '%مدیر%'\n" +
                ")\n" +
                ")\n" +
                " where\n" +
                "post is not null\n" +
                "     ) \n" +
                "    ) post  , (SELECT\n" +
                " \n" +
                "\n" +
                "   TO_CHAR(tbl_needs_assessment.d_created_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime\n" +
                " \n" +
                "   \n" +
                "  \n" +
                "FROM\n" +
                "    tbl_needs_assessment\n" +
                "WHERE\n" +
                "    tbl_needs_assessment.e_deleted IS NULL\n" +
                "\n" +
                "\n" +
                "    and\n" +
                "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
                "     and\n" +
                "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  dateTime\n" +
                " \n" +
                "       )res\n" +
                " ", nativeQuery = true)
    List<Object> jobModiriati(String fromDate,
                                                       String toDate);





    @Query(value = "\n" +
            "\n" +
            "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "    \n" +
            "    \n" +
            "\n" +
            "    CASE\n" +
            "        when kol = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round( omor / kol, 5) * 100\n" +
            "    END       AS  n_base_on_complex\n" +
            "    \n" +
            "FROM\n" +
            " \n" +
            " (SELECT\n" +
            " \n" +
            "\n" +
            "   TO_CHAR(tbl_needs_assessment.d_created_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime\n" +
            " \n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_needs_assessment\n" +
            "WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     \n" +
            "     )  dateTime  ,  \n" +
            "     \n" +
            "     (\n" +
            "     SELECT\n" +
            "    COUNT(*) kol FROM(\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "    view_synonym_personnel.ccp_affairs\n" +
            "FROM\n" +
            "    view_synonym_personnel)\n" +
            "     ) kol    ,\n" +
            "     \n" +
            "     (\n" +
            "     SELECT\n" +
            "    count(*) omor FROM\n" +
            "    (\n" +
            "\n" +
            "SELECT DISTINCT\n" +
            "\n" +
            " CASE\n" +
            "        WHEN tbl_training_post.c_affairs is null THEN\n" +
            "            tbl_post.c_affairs\n" +
            "        ELSE\n" +
            "             tbl_training_post.c_affairs\n" +
            "    END       as omor\n" +
            "    \n" +
            "\n" +
            "FROM\n" +
            "    tbl_needs_assessment\n" +
            "    LEFT JOIN tbl_training_post ON tbl_needs_assessment.f_object = tbl_training_post.id\n" +
            "                                   AND tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "    LEFT JOIN tbl_post ON tbl_needs_assessment.f_object = tbl_post.id AND tbl_needs_assessment.c_object_type = 'Post'\n" +
            "WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "    and\n" +
            "    (\n" +
            "    tbl_training_post.c_affairs is not null OR\n" +
            "       tbl_post.c_affairs is not null \n" +
            "\n" +
            "    )\n" +
            "        and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian') \n" +
            "    )\n" +
            "     \n" +
            "     )  omor\n" +
            " \n" +
            "      )res\n" +
            " ", nativeQuery = true)
    List<Object> jobNeedAssessment(String fromDate,
                                                       String toDate);





    @Query(value = "\n" +
            "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "     \n" +
            "    CASE\n" +
            "        WHEN kol = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round( post / kol, 5) * 100\n" +
            "    END       AS  n_base_on_complex\n" +
            "     \n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as kol\n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT DISTINCT\n" +
            "                    tbl_needs_assessment.c_object_type,\n" +
            "                    tbl_needs_assessment.f_object\n" +
            "--                    ,tbl_needs_assessment.d_created_date\n" +
            "                FROM\n" +
            "                    tbl_needs_assessment\n" +
            "                    WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "    \n" +
            "    and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "            )\n" +
            "    ) kol ,\n" +
            "    \n" +
            "    (\n" +
            "        SELECT\n" +
            "            COUNT(*) as post\n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT DISTINCT\n" +
            "                    tbl_needs_assessment.c_object_type,\n" +
            "                    tbl_needs_assessment.f_object\n" +
            "--                    ,tbl_needs_assessment.d_created_date\n" +
            "                FROM\n" +
            "                    tbl_needs_assessment\n" +
            "                    WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "    \n" +
            "    and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian') \n" +
            "     and (\n" +
            "     tbl_needs_assessment.c_object_type = 'TrainingPost'\n" +
            "     OR\n" +
            "          tbl_needs_assessment.c_object_type = 'Post'\n" +
            "\n" +
            "     )\n" +
            "     \n" +
            "     ) \n" +
            "    ) post  , (SELECT\n" +
            " \n" +
            "\n" +
            "   TO_CHAR(tbl_needs_assessment.d_created_date,'yyyy/mm/dd','nls_calendar=persian')     as createTime\n" +
            " \n" +
            "   \n" +
            "  \n" +
            "FROM\n" +
            "    tbl_needs_assessment\n" +
            "WHERE\n" +
            "    tbl_needs_assessment.e_deleted IS NULL\n" +
            "\n" +
            "\n" +
            "    and\n" +
            "     tbl_needs_assessment.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "     and\n" +
            "     tbl_needs_assessment.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian'))  dateTime\n" +
            "    )res\n" +
            "     \n" +
            " ", nativeQuery = true)
    List<Object> postNeedAssessment(String fromDate,
                                                       String toDate);


    @Query(value = """
         --Report47- nerkh_poshesh_arzeshyabi_sathe_vakoneshi\s
        
        SELECT rowNum AS id,
               res.*
        FROM(     \s
        
         with kol as (SELECT DISTINCT
                    count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_kol_mojtama,
                     count(distinct s.class_id)  over (partition by  s.moavenat)  AS count__kol_moavenat,
                     count(distinct s.class_id)  over (partition by s.omoor)      AS count__kol_omoor,
                     s.mojtama_id,
                    s.mojtama,
                    moavenat_id,
                    s.moavenat,
                    s.omoor_id,
                    s.omoor
                 \s
                FROM
                    (
                        SELECT
                            class.id               AS class_id,
                            view_complex.id        AS mojtama_id,
                            view_complex.c_title   AS mojtama,
                            view_assistant.id      AS moavenat_id,
                            view_assistant.c_title AS moavenat,
                            view_affairs.id      AS omoor_id,
                            view_affairs.c_title   AS omoor
                        FROM
                            tbl_class   class\s
                            INNER JOIN tbl_class_student ON class.id = tbl_class_student.class_id
                            INNER JOIN
                            (
                              select
                                    tbl_student.id                                                         as id
                                   ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                   ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                   ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                              \s
                               from tbl_student\s
                                LEFT JOIN view_last_md_employee_hr
                                ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                            )
                            tbl_student  ON tbl_class_student.student_id = tbl_student.id
                            RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                            RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                            RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                       where 1=1
                        and class.c_status IN ( 2, 3, 5 )\s
                        and class.C_START_DATE >=  :fromDate
                        and class.C_START_DATE <=  :toDate
        
                        \s
                        GROUP BY
                            class.id,
                            view_complex.c_title,
                            view_complex.id,
                            view_assistant.id,
                             view_affairs.id,
                            view_assistant.c_title,
                            view_affairs.c_title
            \s
                    ) s
                GROUP BY
                \s
                    s.class_id,\s
                    s.mojtama_id,
                    s.mojtama,
                    moavenat_id,
                    s.moavenat,
                    s.omoor_id,
                    s.omoor
                 having  nvl(count( s.class_id) ,0)  !=0
                 ),
               \s
                khod as(
                    SELECT DISTINCT
                         count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_raftar_mojtama,
                         count(distinct s.class_id)  over (partition by  s.moavenat)  AS count_raftar_moavenat,
                         count(distinct s.class_id)  over (partition by s.omoor)      AS count_raftar_omoor,
                         s.mojtama_id,
                         s.mojtama,
                         moavenat_id,
                         s.moavenat,
                         s.omoor_id,
                         s.omoor
                 \s
                   FROM
                    (
                        SELECT
                            class.class_id         AS class_id,
                            view_complex.id        AS mojtama_id,
                            view_complex.c_title   AS mojtama,
                            view_assistant.id      AS moavenat_id,
                            view_assistant.c_title AS moavenat,
                            view_affairs.id        AS omoor_id,
                            view_affairs.c_title   AS omoor
                        FROM
                          ( \s
                              select  \s
                                  c.id             as class_id\s
                                  ,c.C_START_DATE  as C_START_DATE
                              from \s
                                       TBL_CLASS c \s
                                       inner join tbl_evaluation e \s
                                         on  e.f_class_id = c.id \s
                                          \s
                                         left join (select c.id as id \s
                                                     from \s
                                                    TBL_CLASS c \s
                                                left join TBL_EVALUATION_ANALYSIS   n     \s
                                                  on  n.F_TCLASS = c.id  \s
                                                where  n.B_REACTION_PASS = 1 -- pass shodeh \s
                                                  )pass \s
                                                 on pass.id = c.id \s
                                       outer apply ( select to_number(c_value) as c_value from TBL_PARAMETER_VALUE v where v.C_CODE = 'minQusER' ) nr     \s
                                       outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = '52' ) faraghir \s
                                       outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'Reactive' ) arzyabi_vakoneshi \s
                                where \s
                                   e.F_EVALUATED_TYPE_ID = faraghir.id  -- 188 --faraghir  \s
                                   and  e.f_evaluation_level_id =  arzyabi_vakoneshi.id --154  -- arzyabi_vakoneshi \s
                                  \s
                               group by \s
                                   c.id
                                   ,c.C_START_DATE
                                  ,e.id \s
                                  ,nr.c_value \s
                                  ,pass.id \s
                                   \s
                               having ( cast ((count(pass.id) / count(e.id)  )*100 as decimal(6,2)) )  >= nr.c_value \s
                             )    class
                            INNER JOIN tbl_class_student ON class.class_id = tbl_class_student.class_id
                             INNER JOIN
                            (
                              select
                                    tbl_student.id                                                         as id
                                   ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                   ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                   ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                              \s
                               from tbl_student\s
                                LEFT JOIN view_last_md_employee_hr
                                ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                            )
                            tbl_student  ON tbl_class_student.student_id = tbl_student.id
                            RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                            RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                            RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                       where 1=1\s
         \s
                         and class.C_START_DATE >=  :fromDate
                         and class.C_START_DATE <=  :toDate
                           \s
                        GROUP BY
                            class.class_id,
                            view_complex.c_title,
                             view_complex.id,
                            view_assistant.id,
                            view_affairs.id ,
                            view_assistant.c_title,
                            view_affairs.c_title
            \s
                    ) s
                GROUP BY
                \s
                    s.class_id,\s
                    s.mojtama_id,
                    s.mojtama,
                    moavenat_id,
                    s.moavenat,
                    s.omoor_id,
                    s.omoor
             \s
                 )
               \s
                select DISTINCT
               \s
                kol.mojtama_id     as complex_id
                ,kol.mojtama       as complex
                ,  max(cast ((khod.count_raftar_mojtama /kol.count_kol_mojtama)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex
               \s
                , kol.moavenat_id  as assistant_id
                , kol.moavenat     as assistant
                ,max( cast ( (khod.count_raftar_moavenat /kol.count__kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant
               \s
                ,kol.omoor_id     as affairs_id
                ,kol.omoor        as affairs
                ,max(cast ( (khod.count_raftar_omoor /kol.count__kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs
        
                FROM
                kol\s
                LEFT JOIN  khod
                on
                 khod.mojtama_id = kol.mojtama_id
                 and khod.moavenat_id = kol.moavenat_id
                 and khod.omoor_id = kol.omoor_id
          \s
                where 1=1
                      and (
                           kol.mojtama_id is not null
                           and kol.moavenat_id is not null
                           and kol.omoor_id is not null
                          )
                \s
                group by
                kol.mojtama_id
                ,kol.mojtama
                ,khod.count_raftar_mojtama\s
                ,khod.count_raftar_moavenat\s
                ,khod.count_raftar_omoor\s
                ,kol.count_kol_mojtama
                ,kol.count__kol_moavenat
                ,kol.count__kol_omoor
                , kol.moavenat_id
                , kol.moavenat
                ,kol.omoor_id
                ,kol.omoor
        ) res
         where 1=1
             AND (:complexNull = 1 OR complex IN (:complex))\s
             AND (:assistantNull = 1 OR assistant IN (:assistant))\s
             AND (:affairsNull = 1 OR affairs IN (:affairs))\s  
"""
, nativeQuery = true)
    List<GenericStatisticalIndexReport> reactiveEvaluationCoverage(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);




    @Query(value = " -- nesbat dorehay daray ravesh arzeshyabi taeen shodeh\n" +
            "\n" +
            "SELECT rowNum AS id,\n" +
            "                                          res.*\n" +
            "                                   FROM (\n" +
            "with kol as (\n" +
            "SELECT  distinct\n" +
            "            view_complex.id                                                                    as mojtama_id\n" +
            "           ,view_complex.c_title                                                               as mojtama\n" +
            "          , COUNT(distinct class.id)  over (partition by view_complex.id)      as class_mojtama\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as moavenat_id\n" +
            "          ,view_assistant.c_title                                                              as moavenat\n" +
            "          , COUNT(distinct class.id)  over (partition by view_assistant.id )   as class_moavenat\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as omoor_id \n" +
            "          ,view_affairs.c_title                                                                as omoor \n" +
            "          , COUNT(distinct class.id)  over (partition by view_affairs.id )     as class_omoor\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd ON classstd.class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU ON EU.ID = class.CALENDAR_ID\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "                 and class.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title\n" +
            "              \n" +
            "\n" +
            " ),\n" +
            "\n" +
            "ravesh as (\n" +
            "     SELECT  distinct\n" +
            "            view_complex.id                                                                    as mojtama_id\n" +
            "           ,view_complex.c_title                                                               as mojtama\n" +
            "          ,COUNT( distinct class.id)  over (partition by view_complex.id)      as count_class_ravesh_mojtama\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as moavenat_id\n" +
            "          ,view_assistant.c_title                                                              as moavenat\n" +
            "          ,COUNT( distinct class.id)  over (partition by view_assistant.id )   as count_class_ravesh_moavenat\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as omoor_id \n" +
            "          ,view_affairs.c_title                                                                as omoor \n" +
            "          ,COUNT( distinct class.id)  over (partition by view_affairs.id )     as count_class_ravesh_omoor\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd ON classstd.class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "            and class.C_EVALUATION is not null\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "               and class.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                class.n_h_duration\n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",max(cast ( (ravesh.count_class_ravesh_mojtama /kol.class_mojtama)*100  as decimal(6,2))  ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id  as assistant_id\n" +
            ", kol.moavenat  as assistant\n" +
            ",max( cast ( (ravesh.count_class_ravesh_moavenat /kol.class_moavenat)*100 as decimal(6,2))  *100) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",max(cast ( (ravesh.count_class_ravesh_omoor /kol.class_omoor)*100 as decimal(6,2))  *100 ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "kol  \n" +
            "LEFT JOIN  ravesh\n" +
            "on\n" +
            " kol.mojtama_id = ravesh.mojtama_id\n" +
            " and kol.moavenat_id = ravesh.moavenat_id\n" +
            " and kol.omoor_id = ravesh.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           kol.mojtama_id is not null\n" +
            "           and kol.moavenat_id is not null\n" +
            "           and kol.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",kol.class_mojtama\n" +
            ",kol.class_moavenat\n" +
            ",kol.class_omoor\n" +
            ",ravesh.count_class_ravesh_mojtama\n" +
            ",ravesh.count_class_ravesh_moavenat\n" +
            ",ravesh.count_class_ravesh_omoor\n" +
            ",kol.moavenat_id\n" +
            ",kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            ") res\n" +
            "  where  \n" +
            "                                                                    (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                                               AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                                                                     AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> coursesDeterminedEvaluationMethod(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);




    @Query(value = "  -- nesbat dorehay daray hadaf raftary \n" +
            "SELECT rowNum AS id,\n" +
            "                                          res.*\n" +
            "                                   FROM (\n" +
            "\n" +
            "with kol as (\n" +
            "SELECT  distinct\n" +
            "            view_complex.id                                                                    as mojtama_id\n" +
            "           ,view_complex.c_title                                                               as mojtama\n" +
            "          , COUNT(distinct class.id)  over (partition by view_complex.id)      as class_mojtama\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as moavenat_id\n" +
            "          ,view_assistant.c_title                                                              as moavenat\n" +
            "          , COUNT(distinct class.id)  over (partition by view_assistant.id )   as class_moavenat\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as omoor_id \n" +
            "          ,view_affairs.c_title                                                                as omoor \n" +
            "          , COUNT(distinct class.id)  over (partition by view_affairs.id )     as class_omoor\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd ON classstd.class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU ON EU.ID = class.CALENDAR_ID\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "                   and class.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title\n" +
            "              \n" +
            "\n" +
            " ),\n" +
            "\n" +
            "rftari as (\n" +
            "     SELECT  distinct\n" +
            "            view_complex.id                                                                    as mojtama_id\n" +
            "           ,view_complex.c_title                                                               as mojtama\n" +
            "          ,COUNT( distinct class.id)  over (partition by view_complex.id)      as count_class_raftari_mojtama\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as moavenat_id\n" +
            "          ,view_assistant.c_title                                                              as moavenat\n" +
            "          ,COUNT( distinct class.id)  over (partition by view_assistant.id )   as count_class_raftari_moavenat\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as omoor_id \n" +
            "          ,view_affairs.c_title                                                                as omoor \n" +
            "          ,COUNT( distinct class.id)  over (partition by view_affairs.id )     as count_class_raftari_omoor\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd ON classstd.class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "           and class.C_EVALUATION = '3' --raftari\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "                     and class.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                class.n_h_duration\n" +
            ")\n" +
            "\n" +
            "\n" +
            "select DISTINCT\n" +
            "\n" +
            "kol.mojtama_id as complex_id\n" +
            ",kol.mojtama as complex\n" +
            ",max(cast ( (rftari.count_class_raftari_mojtama /kol.class_mojtama)*100  as decimal(6,2))  ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",max( cast ( (rftari.count_class_raftari_moavenat /kol.class_moavenat)*100 as decimal(6,2))  *100) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",max(cast ( (rftari.count_class_raftari_omoor /kol.class_omoor)*100 as decimal(6,2))  *100 ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            "kol  \n" +
            "LEFT JOIN  rftari\n" +
            "on\n" +
            " kol.mojtama_id = rftari.mojtama_id\n" +
            " and kol.moavenat_id = rftari.moavenat_id\n" +
            " and kol.omoor_id = rftari.omoor_id\n" +
            "\n" +
            "where 1=1\n" +
            "      and (\n" +
            "           kol.mojtama_id is not null\n" +
            "           and kol.moavenat_id is not null\n" +
            "           and kol.omoor_id is not null\n" +
            "          )\n" +
            " \n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",kol.class_mojtama\n" +
            ",kol.class_moavenat\n" +
            ",kol.class_omoor\n" +
            ",rftari.count_class_raftari_mojtama\n" +
            ",rftari.count_class_raftari_moavenat\n" +
            ",rftari.count_class_raftari_omoor\n" +
            ",kol.moavenat_id\n" +
            ",kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            "\n" +
            " ) res\n" +
            "  where  \n" +
            "                                                                    (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                                               AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                                                                     AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> coursesTargetDeterminedEvaluationMethod(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);





    @Query(value = " -- mizan amozeshay barnameh rizi shodeh\n" +
            "\n" +
            " SELECT rowNum AS id,\n" +
            "                                          res.*\n" +
            "                                   FROM (\n" +
            "     SELECT  distinct\n" +
            "            view_complex.id                                                                    as complex_id\n" +
            "           ,view_complex.c_title                                                               as complex\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_complex.id)      as n_base_on_complex\n" +
            "          \n" +
            "          ,view_assistant.id                                                                   as assistant_id\n" +
            "          ,view_assistant.c_title                                                              as assistant\n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_assistant.id )   as n_base_on_assistant\n" +
            "          \n" +
            "          ,view_affairs.id                                                                     as affairs_id \n" +
            "          ,view_affairs.c_title                                                                as affairs \n" +
            "          ,SUM(class.n_h_duration * COUNT(class.id))  over (partition by view_affairs.id )     as n_base_on_affairs\n" +
            "    \n" +
            "     FROM tbl_class   class \n" +
            "                INNER JOIN tbl_class_student classstd ON classstd.class_id = class.id\n" +
            "                INNER JOIN TBL_EDUCATIONAL_CALENDER EU ON EU.ID = class.CALENDAR_ID\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "     WHERE 1=1\n" +
            "           and (\n" +
            "                 view_complex.id is not null\n" +
            "                 and view_affairs.id  is not null\n" +
            "                 and view_assistant.id  is not null\n" +
            "               )\n" +
            "                   and class.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and class.C_START_DATE <= :toDate\n" +
            "                 --and class.C_START_DATE <=@\n" +
            "                  --and class.C_END_DATE =>@\n" +
            "         --         and view_complex.id =@\n" +
            "            --       and view_affairs.id =@\n" +
            "            --       and view_assistant.id =@\n" +
            "    GROUP BY\n" +
            "                class.id,\n" +
            "                class.c_code,    \n" +
            "                class.c_start_date,\n" +
            "                class.c_end_date,\n" +
            "                 view_complex.id,\n" +
            "                view_assistant.id,\n" +
            "                 view_affairs.id,\n" +
            "                view_complex.c_title,\n" +
            "                view_assistant.c_title,\n" +
            "                view_affairs.c_title,\n" +
            "                class.n_h_duration\n" +
            "       \n" +
            "          \n" +
            "         ) res\n" +
            "  where  \n" +
            "                                                                    (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                                               AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                                                                     AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n" +
            "\n", nativeQuery = true)
    List<GenericStatisticalIndexReport> scheduledTraining(String fromDate,
                                                       String toDate,
                                                       List<Object> complex,
                                                       int complexNull,
                                                       List<Object> assistant,
                                                       int assistantNull,
                                                       List<Object> affairs,
                                                       int affairsNull);
    @Query(value =  "SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM( \n" +
            "        select DISTINCT\n" +
            "         round(\n" +
            "                (\n" +
            "                     (   select  count(distinct t_post.id) as count_has_need\n" +
            "                        from \n" +
            "                             TBL_TRAINING_POST t_post \n" +
            "                             inner join TBL_NEEDS_ASSESSMENT need    \n" +
            "                             on t_post.id = need.F_OBJECT\n" +
            "                        where  1=1 \n" +
            "                         and t_post.E_DELETED is null\n" +
            "                            and  need.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                            and  need.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                            and (  t_post.C_TITLE_FA    like  '%رئیس%'\n" +
            "                                  or t_post.C_TITLE_FA  like  '%مجری%'\n" +
            "                                  or t_post.C_TITLE_FA  like  ' %مجریان%'\n" +
            "                                )\n" +
            "                     )/   \n" +
            "                     (   select count(distinct t_post.id) as count_kol  \n" +
            "                         \n" +
            "                        from \n" +
            "                           TBL_TRAINING_POST t_post\n" +
            "                        where  1=1 \n" +
            "                            and t_post.E_DELETED is null\n" +
            "                            and (  t_post.C_TITLE_FA    like  '%رئیس%'\n" +
            "                                  or t_post.C_TITLE_FA  like  '%مجری%'\n" +
            "                                  or t_post.C_TITLE_FA  like  ' %مجریان%'\n" +
            "                                )\n" +
            "                       )\n" +
            "                   )*100\n" +
            "          , 2)      \n" +
            "          AS n_base_on_complex     \n" +
            "               \n" +
            "from\n" +
            "    TBL_TRAINING_POST\n" +
            ") res"
, nativeQuery = true)
    List<Object> proportionOfkeyOccupationsWithQualifications(String fromDate,
                                    String toDate);

    @Query(value = " --3330  nesbat niazhay amozeshi khodamokhteh\n" +
            "\n" +
            "SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            "        with kol as (SELECT DISTINCT\n" +
            "            SUM(s.presence_hour)  over (partition by  s.mojtama)  AS sum_presence_hour_kol_mojtama,\n" +
            "             SUM(s.presence_hour)  over (partition by  s.moavenat)  AS sum_presence_hour_kol_moavenat,\n" +
            "             SUM(s.presence_hour)  over (partition by s.omoor)  AS sum_presence_hour_kol_omoor,\n" +
            "             s.class_id, \n" +
            "            s.class_end_date,\n" +
            "            s.class_start_date,  \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    std.id                 AS student_id,\n" +
            "                    SUM(\n" +
            "                        CASE\n" +
            "                            WHEN att.c_state IN('1', '2') THEN\n" +
            "                                round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                                24, 1)\n" +
            "                            ELSE\n" +
            "                                0\n" +
            "                        END\n" +
            "                    )                      AS presence_hour,\n" +
            "                   \n" +
            "                    class.c_start_date     AS class_start_date ,\n" +
            "                    class.c_end_date       AS class_end_date,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                         tbl_attendance att\n" +
            "                    INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                    INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                    INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1 \n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    std.id,\n" +
            "                    class.c_start_date,\n" +
            "                    class.c_end_date,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title,\n" +
            "                    csession.c_session_date,\n" +
            "                    class.c_code\n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "            s.presence_hour,\n" +
            "            s.class_id, \n" +
            "            s.class_end_date,\n" +
            "            s.class_start_date,  \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "         having  nvl(SUM(s.presence_hour) ,0)  !=0\n" +
            "         ),\n" +
            "        \n" +
            "        khod as(\n" +
            "                SELECT DISTINCT\n" +
            "                    SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_khod_mojtama,\n" +
            "                    SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_khod_moavenat,\n" +
            "                    SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_khod_omoor,\n" +
            "                     s.class_id, \n" +
            "                    s.class_end_date,\n" +
            "                    s.class_start_date,  \n" +
            "                    s.mojtama_id,\n" +
            "                    s.mojtama,\n" +
            "                    moavenat_id,\n" +
            "                    s.moavenat,\n" +
            "                    s.omoor_id,\n" +
            "                    s.omoor\n" +
            "                  \n" +
            "                FROM\n" +
            "                    (\n" +
            "                        SELECT\n" +
            "                            class.id               AS class_id,\n" +
            "                            std.id                 AS student_id,\n" +
            "                            SUM(\n" +
            "                                CASE\n" +
            "                                    WHEN att.c_state IN('1', '2') THEN\n" +
            "                                        round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') - to_date(csession.c_session_start_hour, 'HH24:MI')) *\n" +
            "                                        24, 1)\n" +
            "                                    ELSE\n" +
            "                                        0\n" +
            "                                END\n" +
            "                            )                      AS presence_hour,\n" +
            "                           \n" +
            "                            class.c_start_date     AS class_start_date ,\n" +
            "                            class.c_end_date       AS class_end_date,\n" +
            "                            class.complex_id       AS mojtama_id,\n" +
            "                            view_complex.c_title   AS mojtama,\n" +
            "                            class.assistant_id     AS moavenat_id,\n" +
            "                            view_assistant.c_title AS moavenat,\n" +
            "                            class.affairs_id       AS omoor_id,\n" +
            "                            view_affairs.c_title   AS omoor\n" +
            "                        FROM\n" +
            "                                 tbl_attendance att\n" +
            "                            INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                            INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                            INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                            INNER JOIN TBL_CLASS_STUDENT class_std on class_std.class_id = class.id\n" +
            "                            LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                            LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                            LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "                              outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'kh' ) khod_amokhteh\n" +
            "                             \n" +
            "                      WHERE 1=1\n" +
            "                      AND class_std.PRESENCE_TYPE_ID = khod_amokhteh.id\n" +
            "                       and class.C_START_DATE >= :fromDate\n" +
            "                       and class.C_START_DATE <= :toDate\n" +
            "                      \n" +
            "                --       and view_complex.id =@\n" +
            "                --       and view_affairs.id =@\n" +
            "                --       and view_assistant.id =@\n" +
            "                            \n" +
            "                        GROUP BY\n" +
            "                            class.id,\n" +
            "                            std.id,\n" +
            "                            class.c_start_date,\n" +
            "                            class.c_end_date,\n" +
            "                            view_complex.c_title,\n" +
            "                            class.complex_id,\n" +
            "                            class.assistant_id,\n" +
            "                            class.affairs_id,\n" +
            "                            view_assistant.c_title,\n" +
            "                            view_affairs.c_title,\n" +
            "                            csession.c_session_date,\n" +
            "                            class.c_code\n" +
            "                    ) s\n" +
            "                GROUP BY\n" +
            "                    s.presence_hour,\n" +
            "                    s.class_id, \n" +
            "                    s.class_end_date,\n" +
            "                    s.class_start_date,  \n" +
            "                    s.mojtama_id,\n" +
            "                    s.mojtama,\n" +
            "                    moavenat_id,\n" +
            "                    s.moavenat,\n" +
            "                    s.omoor_id,\n" +
            "                    s.omoor\n" +
            "        )\n" +
            "        \n" +
            "        select DISTINCT\n" +
            "        \n" +
            "        kol.mojtama_id     as complex_id\n" +
            "        ,kol.mojtama       as complex\n" +
            "        ,max(cast ( (khod.sum_presence_hour_khod_mojtama /kol.sum_presence_hour_kol_mojtama)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex\n" +
            "        \n" +
            "        , kol.moavenat_id  as assistant_id\n" +
            "        , kol.moavenat     as assistant\n" +
            "        ,max( cast ( (khod.sum_presence_hour_khod_moavenat /kol.sum_presence_hour_kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "        \n" +
            "        ,kol.omoor_id     as affairs_id\n" +
            "        ,kol.omoor        as affairs\n" +
            "        ,max(cast ( (khod.sum_presence_hour_khod_omoor /kol.sum_presence_hour_kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "        \n" +
            "        FROM\n" +
            "        kol \n" +
            "        LEFT JOIN  khod\n" +
            "        on\n" +
            "         khod.mojtama_id = kol.mojtama_id\n" +
            "         and khod.moavenat_id = kol.moavenat_id\n" +
            "         and khod.omoor_id = kol.omoor_id\n" +
            "        \n" +
            "        where 1=1\n" +
            "              and (\n" +
            "                   kol.mojtama_id is not null\n" +
            "                   and kol.moavenat_id is not null\n" +
            "                   and kol.omoor_id is not null\n" +
            "                  )\n" +
            "         \n" +
            "        group by\n" +
            "        kol.mojtama_id\n" +
            "        ,kol.mojtama\n" +
            "        ,khod.sum_presence_hour_khod_mojtama \n" +
            "        ,khod.sum_presence_hour_khod_moavenat \n" +
            "        ,khod.sum_presence_hour_khod_omoor \n" +
            "        ,kol.sum_presence_hour_kol_mojtama\n" +
            "        ,kol.sum_presence_hour_kol_moavenat\n" +
            "        ,kol.sum_presence_hour_kol_omoor\n" +
            "        , kol.moavenat_id\n" +
            "        , kol.moavenat\n" +
            "        ,kol.omoor_id\n" +
            "        ,kol.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs)) ", nativeQuery = true)
    List<GenericStatisticalIndexReport> theProportionOfSelfTaughtEducationalNeedsOffline(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);

    @Query(value =  "SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM( \n" +
            "\n" +
            "         select  DISTINCT \n" +
            "        round(\n" +
            "        (\n" +
            "          \n" +
            "            SELECT distinct\n" +
            "                    COUNT(distinct course.id)  as goal_doreh\n" +
            "                  \n" +
            "                FROM   TBL_COURSE course\n" +
            "                       inner join TBL_COURSE_GOAL course_goal\n" +
            "                           on course.id = course_goal.F_COURSE_ID\n" +
            "                WHERE 1=1\n" +
            "                    and E_DELETED is null\n" +
            "                    and  course.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                    and  course.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "      \n" +
            "         ) /\n" +
            "         (\n" +
            "         \n" +
            "             SELECT distinct\n" +
            "                    COUNT(distinct course.id)  as kol_doreh\n" +
            "                  \n" +
            "                FROM   TBL_COURSE course\n" +
            "                   \n" +
            "                WHERE 1=1\n" +
            "                    and E_DELETED is null\n" +
            "                    and  course.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                    and  course.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "      \n" +
            "         ) \n" +
            "        , 2) \n" +
            "         AS n_base_on_complex\n" +
            "        \n" +
            "        FROM\n" +
            "        TBL_COURSE\n" +
            "\n" +
            ") res ", nativeQuery = true)
    List<Object> numberOfStandardDesignedCourses(String fromDate,
                                                 String toDate);
    @Query(value ="SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            " with kol as (SELECT DISTINCT\n" +
            "            count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_kol_mojtama,\n" +
            "             count(distinct s.class_id)  over (partition by  s.moavenat)  AS count__kol_moavenat,\n" +
            "             count(distinct s.class_id)  over (partition by s.omoor)      AS count__kol_omoor,\n" +
            "             s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class \n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1 \n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "     \n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "         \n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "         having  nvl(count( s.class_id) ,0)  !=0\n" +
            "         ),\n" +
            "        \n" +
            "        khod as(SELECT DISTINCT\n" +
            "            count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_electronic_mojtama,\n" +
            "             count(distinct s.class_id)  over (partition by  s.moavenat)  AS count_electronic_moavenat,\n" +
            "             count(distinct s.class_id)  over (partition by s.omoor)      AS count_electronic_omoor,\n" +
            "             s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class \n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1 \n" +
            "                AND  class.C_TEACHING_TYPE = 'مجازی'\n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "     \n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "         \n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "      \n" +
            "         )\n" +
            "        \n" +
            "        select DISTINCT\n" +
            "        \n" +
            "        kol.mojtama_id     as complex_id\n" +
            "        ,kol.mojtama       as complex\n" +
            "        ,max(cast ((khod.count_electronic_mojtama /kol.count_kol_mojtama)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex\n" +
            "        \n" +
            "        , kol.moavenat_id  as assistant_id\n" +
            "        , kol.moavenat     as assistant\n" +
            "        ,max( cast ( (khod.count_electronic_moavenat /kol.count__kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "        \n" +
            "        ,kol.omoor_id     as affairs_id\n" +
            "        ,kol.omoor        as affairs\n" +
            "        ,max(cast ( (khod.count_electronic_omoor /kol.count__kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "        \n" +
            "        FROM\n" +
            "        kol \n" +
            "        LEFT JOIN  khod\n" +
            "        on\n" +
            "         khod.mojtama_id = kol.mojtama_id\n" +
            "         and khod.moavenat_id = kol.moavenat_id\n" +
            "         and khod.omoor_id = kol.omoor_id\n" +
            "        \n" +
            "        where 1=1\n" +
            "              and (\n" +
            "                   kol.mojtama_id is not null\n" +
            "                   and kol.moavenat_id is not null\n" +
            "                   and kol.omoor_id is not null\n" +
            "                  )\n" +
            "         \n" +
            "        group by\n" +
            "        kol.mojtama_id\n" +
            "        ,kol.mojtama\n" +
            "        ,khod.count_electronic_mojtama \n" +
            "        ,khod.count_electronic_moavenat \n" +
            "        ,khod.count_electronic_omoor \n" +
            "        ,kol.count_kol_mojtama\n" +
            "        ,kol.count__kol_moavenat\n" +
            "        ,kol.count__kol_omoor\n" +
            "        , kol.moavenat_id\n" +
            "        , kol.moavenat\n" +
            "        ,kol.omoor_id\n" +
            "        ,kol.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs)) ", nativeQuery = true)
    List<GenericStatisticalIndexReport> theAmountOfVirtualCoursesProducedElectronic(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
    @Query(value ="SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            "SELECT DISTINCT\n" +
            "              s.mojtama_id  as complex_id,\n" +
            "              s.mojtama      as complex,\n" +
            "              count(distinct s.class_id)  over (partition by  s.mojtama)    AS n_base_on_complex,\n" +
            "              \n" +
            "              moavenat_id    as assistant_id,\n" +
            "              s.moavenat     as assistant,\n" +
            "              count(distinct s.class_id)  over (partition by  s.moavenat)  AS n_base_on_assistant,\n" +
            "              \n" +
            "               s.omoor_id     as affairs_id,\n" +
            "               s.omoor        as affairs, \n" +
            "              count(distinct s.class_id)  over (partition by s.omoor)      AS n_base_on_affairs\n" +
            " \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class \n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1 \n" +
            "                AND  class.C_TEACHING_TYPE like '%چند رسانه ایی%'\n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "     \n" +
            "            ) s\n" +
            "          where 1=1\n" +
            "              and (\n" +
            "                   s.mojtama_id is not null\n" +
            "                   and s.moavenat_id is not null\n" +
            "                   and s.omoor_id is not null\n" +
            "                  )    \n" +
            "            \n" +
            "        GROUP BY\n" +
            "         \n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs))   " , nativeQuery = true)
    List<GenericStatisticalIndexReport> theNumberOfEditedNewMultimediaContents(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
    @Query(value ="SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            "SELECT DISTINCT\n" +
            "              s.mojtama_id  as complex_id,\n" +
            "              s.mojtama      as complex,\n" +
            "              count(distinct s.class_id)  over (partition by  s.mojtama)    AS n_base_on_complex,\n" +
            "              \n" +
            "              moavenat_id    as assistant_id,\n" +
            "              s.moavenat     as assistant,\n" +
            "              count(distinct s.class_id)  over (partition by  s.moavenat)  AS n_base_on_assistant,\n" +
            "              \n" +
            "               s.omoor_id     as affairs_id,\n" +
            "               s.omoor        as affairs, \n" +
            "              count(distinct s.class_id)  over (partition by s.omoor)      AS n_base_on_affairs\n" +
            " \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class \n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1 \n" +
            "                AND  ( class.C_TEACHING_TYPE like '%بازی وار%'\n" +
            "                       or class.C_TEACHING_TYPE like '%gamification%'  \n" +
            "                     )\n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "     \n" +
            "            ) s\n" +
            "          where 1=1\n" +
            "              and (\n" +
            "                   s.mojtama_id is not null\n" +
            "                   and s.moavenat_id is not null\n" +
            "                   and s.omoor_id is not null\n" +
            "                  )    \n" +
            "            \n" +
            "        GROUP BY\n" +
            "         \n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs))   ", nativeQuery = true)
    List<GenericStatisticalIndexReport> theNumberOfGamifiedContentProduced(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
    @Query(value ="SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            " with kol as(\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as personel_kol_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as personel_kol_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as personel_kol_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title   as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED = 0\n" +
            "    --       and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title   \n" +
            "),\n" +
            "        \n" +
            "khod as(\n" +
            "          SELECT DISTINCT\n" +
            "            sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by  s.mojtama)   AS count_hazineh_mojtama,\n" +
            "             sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by  s.moavenat)  AS count_hazineh_moavenat,\n" +
            "             sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by s.omoor)      AS count_hazineh_omoor,\n" +
            "             s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "         FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    (\n" +
            "                       select count(s.ID)*  nvl(to_number(c.C_STUDENT_COST),0)\n" +
            "                       from TBL_CLASS c \n" +
            "                            inner join TBL_CLASS_STUDENT s  on c.ID = s.CLASS_ID\n" +
            "                       where C.ID = class.ID \n" +
            "                       group by c.C_STUDENT_COST\n" +
            "                    )                      AS COUNT_HAZINEH_PER_CLASS,\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class \n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1  \n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "             ) s\n" +
            "        GROUP BY\n" +
            "            s.COUNT_HAZINEH_PER_CLASS,\n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "      \n" +
            "         )\n" +
            "        \n" +
            "        select DISTINCT\n" +
            "        \n" +
            "        kol.mojtama_id     as complex_id\n" +
            "        ,kol.mojtama       as complex\n" +
            "        ,SUM(cast (khod.count_hazineh_mojtama /kol.personel_kol_mojtama as decimal(20,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex\n" +
            "        \n" +
            "        , kol.moavenat_id  as assistant_id\n" +
            "        , kol.moavenat     as assistant\n" +
            "        ,SUM( cast (khod.count_hazineh_moavenat /kol.personel_kol_moavenat as decimal(20,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "        \n" +
            "        ,kol.omoor_id     as affairs_id\n" +
            "        ,kol.omoor        as affairs\n" +
            "        ,SUM(cast (khod.count_hazineh_omoor /kol.personel_kol_omoor as decimal(20,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "        \n" +
            "        FROM\n" +
            "        kol \n" +
            "        LEFT JOIN  khod\n" +
            "        on\n" +
            "         khod.mojtama_id = kol.mojtama_id\n" +
            "         and khod.moavenat_id = kol.moavenat_id\n" +
            "         and khod.omoor_id = kol.omoor_id\n" +
            "        \n" +
            "        where 1=1\n" +
            "              and (\n" +
            "                   kol.mojtama_id is not null\n" +
            "                   and kol.moavenat_id is not null\n" +
            "                   and kol.omoor_id is not null\n" +
            "                  )\n" +
            "         \n" +
            "        group by\n" +
            "        kol.mojtama_id\n" +
            "        ,kol.mojtama\n" +
            "        ,khod.count_hazineh_mojtama \n" +
            "        ,khod.count_hazineh_moavenat \n" +
            "        ,khod.count_hazineh_omoor \n" +
            "        ,kol.personel_kol_mojtama\n" +
            "        ,kol.personel_kol_moavenat\n" +
            "        ,kol.personel_kol_omoor\n" +
            "        , kol.moavenat_id\n" +
            "        , kol.moavenat\n" +
            "        ,kol.omoor_id\n" +
            "        ,kol.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs)) ", nativeQuery = true)
    List<GenericStatisticalIndexReport> totalEducationCostPerCapita(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
    @Query(value ="SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            " with kol as(\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as personel_kol_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as personel_kol_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as personel_kol_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title   as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED = 0\n" +
            "         and ( p.post_grade_code in (30,31,32,33) --farsi\n" +
            "             )\n" +
            "    --       and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title   \n" +
            "),\n" +
            "        \n" +
            "khod as(\n" +
            "          SELECT DISTINCT\n" +
            "            sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by  s.mojtama)   AS count_hazineh_mojtama,\n" +
            "             sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by  s.moavenat)  AS count_hazineh_moavenat,\n" +
            "             sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by s.omoor)      AS count_hazineh_omoor,\n" +
            "             s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "         FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    (\n" +
            "                       select count(s.ID)*  nvl(to_number(c.C_STUDENT_COST),0)\n" +
            "                       from TBL_CLASS c \n" +
            "                            inner join TBL_CLASS_STUDENT s  on c.ID = s.CLASS_ID\n" +
            "                       where C.ID = class.ID \n" +
            "                       group by c.C_STUDENT_COST\n" +
            "                    )                      AS COUNT_HAZINEH_PER_CLASS,\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class\n" +
            "                    inner join TBL_CLASS_STUDENT CLASS_std  ON class.ID = CLASS_std.CLASS_ID\n" +
            "                    inner join TBL_STUDENT std ON  std.id = CLASS_std.STUDENT_ID\n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1\n" +
            "                and (\n" +
            "                        std.POST_GRADE_TITLE like '%مدیر%' --farsi\n" +
            "                        or\n" +
            "                        std.POST_GRADE_TITLE like '%مدیر%' --arabic\n" +
            "                    )\n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "--                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "             ) s\n" +
            "        GROUP BY\n" +
            "            s.COUNT_HAZINEH_PER_CLASS,\n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "      \n" +
            "         )\n" +
            "        \n" +
            "        select DISTINCT\n" +
            "        \n" +
            "        kol.mojtama_id     as complex_id\n" +
            "        ,kol.mojtama       as complex\n" +
            "        ,SUM(cast ( khod.count_hazineh_mojtama /kol.personel_kol_mojtama as decimal(20,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex\n" +
            "        \n" +
            "        , kol.moavenat_id  as assistant_id\n" +
            "        , kol.moavenat     as assistant\n" +
            "        ,SUM( cast ( khod.count_hazineh_moavenat /kol.personel_kol_moavenat as decimal(20,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "        \n" +
            "        ,kol.omoor_id     as affairs_id\n" +
            "        ,kol.omoor        as affairs\n" +
            "        ,SUM(cast ( khod.count_hazineh_omoor /kol.personel_kol_omoor as decimal(20,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "        \n" +
            "        FROM\n" +
            "        kol \n" +
            "        LEFT JOIN  khod\n" +
            "        on\n" +
            "         khod.mojtama_id = kol.mojtama_id\n" +
            "         and khod.moavenat_id = kol.moavenat_id\n" +
            "         and khod.omoor_id = kol.omoor_id\n" +
            "        \n" +
            "        where 1=1\n" +
            "              and (\n" +
            "                   kol.mojtama_id is not null\n" +
            "                   and kol.moavenat_id is not null\n" +
            "                   and kol.omoor_id is not null\n" +
            "                  )\n" +
            "         \n" +
            "        group by\n" +
            "        kol.mojtama_id\n" +
            "        ,kol.mojtama\n" +
            "        ,khod.count_hazineh_mojtama \n" +
            "        ,khod.count_hazineh_moavenat \n" +
            "        ,khod.count_hazineh_omoor \n" +
            "        ,kol.personel_kol_mojtama\n" +
            "        ,kol.personel_kol_moavenat\n" +
            "        ,kol.personel_kol_omoor\n" +
            "        , kol.moavenat_id\n" +
            "        , kol.moavenat\n" +
            "        ,kol.omoor_id\n" +
            "        ,kol.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs)) "  , nativeQuery = true)
    List<GenericStatisticalIndexReport> perCapitaCostOfTrainingManagers(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
    @Query(value ="SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            " with kol as(\n" +
            "        select distinct\n" +
            "        count(distinct p.id) over (partition by view_complex.c_title ) as personel_kol_mojtama\n" +
            "        ,count(distinct p.id) over (partition by view_assistant.c_title ) as personel_kol_moavenat\n" +
            "        ,count(distinct p.id) over (partition by view_affairs.c_title ) as personel_kol_omoor\n" +
            "        ,view_complex.id        as mojtama_id\n" +
            "        ,view_complex.c_title   as mojtama\n" +
            "        ,view_assistant.id      as moavenat_id\n" +
            "        ,view_assistant.c_title as moavenat\n" +
            "        ,view_affairs.id        as omoor_id\n" +
            "        ,view_affairs.c_title   as omoor\n" +
            "        from  \n" +
            "        VIEW_SYNONYM_PERSONNEL p\n" +
            "             LEFT JOIN view_complex ON p.COMPLEX_TITLE = view_complex.c_title \n" +
            "             LEFT JOIN view_assistant ON p.CCP_ASSISTANT = view_assistant.c_title\n" +
            "             LEFT JOIN view_affairs ON p.CCP_AFFAIRS = view_affairs.c_title\n" +
            "        where \n" +
            "         p.employment_status_code = 1 --eshteghal\n" +
            "         and p.DELETED = 0\n" +
            "    --       and view_complex.id =@\n" +
            "    --       and view_affairs.id =@\n" +
            "    --       and view_assistant.id =@\n" +
            "        \n" +
            "        group by\n" +
            "        p.id\n" +
            "        , view_complex.id       \n" +
            "        ,view_complex.c_title   \n" +
            "        ,view_assistant.id      \n" +
            "        ,view_assistant.c_title \n" +
            "        ,view_affairs.id        \n" +
            "        ,view_affairs.c_title   \n" +
            "),\n" +
            "        \n" +
            "khod as(\n" +
            "          SELECT DISTINCT\n" +
            "            sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by  s.mojtama)   AS count_hazineh_mojtama,\n" +
            "             sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by  s.moavenat)  AS count_hazineh_moavenat,\n" +
            "             sum(distinct s.COUNT_HAZINEH_PER_CLASS)  over (partition by s.omoor)      AS count_hazineh_omoor,\n" +
            "             s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "          \n" +
            "         FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    (\n" +
            "                       select count(s.ID)*  nvl(to_number(c.C_STUDENT_COST),0)\n" +
            "                       from TBL_CLASS c \n" +
            "                            inner join TBL_CLASS_STUDENT s  on c.ID = s.CLASS_ID\n" +
            "                       where C.ID = class.ID \n" +
            "                       group by c.C_STUDENT_COST\n" +
            "                    )                      AS COUNT_HAZINEH_PER_CLASS,\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class \n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1  \n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "             ) s\n" +
            "        GROUP BY\n" +
            "            s.COUNT_HAZINEH_PER_CLASS,\n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            "      \n" +
            "         )\n" +
            "        \n" +
            "        select DISTINCT\n" +
            "        \n" +
            "        kol.mojtama_id     as complex_id\n" +
            "        ,kol.mojtama       as complex\n" +
            "        ,SUM(cast (khod.count_hazineh_mojtama /kol.personel_kol_mojtama as decimal(20,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex\n" +
            "        \n" +
            "        , kol.moavenat_id  as assistant_id\n" +
            "        , kol.moavenat     as assistant\n" +
            "        ,SUM( cast (khod.count_hazineh_moavenat /kol.personel_kol_moavenat as decimal(20,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "        \n" +
            "        ,kol.omoor_id     as affairs_id\n" +
            "        ,kol.omoor        as affairs\n" +
            "        ,SUM(cast (khod.count_hazineh_omoor /kol.personel_kol_omoor as decimal(20,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "        \n" +
            "        FROM\n" +
            "        kol \n" +
            "        LEFT JOIN  khod\n" +
            "        on\n" +
            "         khod.mojtama_id = kol.mojtama_id\n" +
            "         and khod.moavenat_id = kol.moavenat_id\n" +
            "         and khod.omoor_id = kol.omoor_id\n" +
            "        \n" +
            "        where 1=1\n" +
            "              and (\n" +
            "                   kol.mojtama_id is not null\n" +
            "                   and kol.moavenat_id is not null\n" +
            "                   and kol.omoor_id is not null\n" +
            "                  )\n" +
            "         \n" +
            "        group by\n" +
            "        kol.mojtama_id\n" +
            "        ,kol.mojtama\n" +
            "        ,khod.count_hazineh_mojtama \n" +
            "        ,khod.count_hazineh_moavenat \n" +
            "        ,khod.count_hazineh_omoor \n" +
            "        ,kol.personel_kol_mojtama\n" +
            "        ,kol.personel_kol_moavenat\n" +
            "        ,kol.personel_kol_omoor\n" +
            "        , kol.moavenat_id\n" +
            "        , kol.moavenat\n" +
            "        ,kol.omoor_id\n" +
            "        ,kol.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs)) " , nativeQuery = true)
    List<GenericStatisticalIndexReport> perCapitaCostOfEmployeeTraining(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
    @Query(value ="SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            "SELECT DISTINCT\n" +
            "              s.mojtama_id  as complex_id,\n" +
            "              s.mojtama      as complex,\n" +
            "              sum( cast(sum( s.C_BEHAVIORAL_GRADE) /(select count(c.id) from   tbl_class c where c.C_EVALUATION = '3') as decimal(6,2)))  over (partition by  s.mojtama_id)    AS n_base_on_complex,\n" +
            "              \n" +
            "              s.moavenat_id    as assistant_id,\n" +
            "              s.moavenat     as assistant,\n" +
            "              sum( cast(sum( s.C_BEHAVIORAL_GRADE) /(select count(c.id) from   tbl_class c where c.C_EVALUATION = '3') as decimal(6,2)))  over (partition by  s.moavenat_id)  AS n_base_on_assistant,\n" +
            "              \n" +
            "               s.omoor_id     as affairs_id,\n" +
            "               s.omoor        as affairs, \n" +
            "              sum( cast(sum( s.C_BEHAVIORAL_GRADE) /(select count(c.id) from   tbl_class c where c.C_EVALUATION = '3') as decimal(6,2)))  over (partition by s.omoor_id)      AS n_base_on_affairs\n" +
            " \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    nvl(a.C_BEHAVIORAL_GRADE,0)   AS C_BEHAVIORAL_GRADE,\n" +
            "                    class.id               AS class_id,\n" +
            "                    class.complex_id       AS mojtama_id,\n" +
            "                    view_complex.c_title   AS mojtama,\n" +
            "                    class.assistant_id     AS moavenat_id,\n" +
            "                    view_assistant.c_title AS moavenat,\n" +
            "                    class.affairs_id       AS omoor_id,\n" +
            "                    view_affairs.c_title   AS omoor\n" +
            "                FROM\n" +
            "                    tbl_class   class \n" +
            "                    INNER JOIN TBL_EVALUATION_ANALYSIS a ON  a.F_TCLASS = class.id\n" +
            "                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "               where 1=1 \n" +
            "                AND   class.C_EVALUATION = '3' --raftari\n" +
            "    \n" +
            "                and class.C_START_DATE >= :fromDate\n" +
            "                and class.C_START_DATE <= :toDate\n" +
            "                   \n" +
            "         --      and view_complex.id =@\n" +
            "        --       and view_affairs.id =@\n" +
            "        --       and view_assistant.id =@\n" +
            "                    \n" +
            "                GROUP BY\n" +
            "                    a.C_BEHAVIORAL_GRADE,\n" +
            "                    class.id,\n" +
            "                    view_complex.c_title,\n" +
            "                    class.complex_id,\n" +
            "                    class.assistant_id,\n" +
            "                    class.affairs_id,\n" +
            "                    view_assistant.c_title,\n" +
            "                    view_affairs.c_title\n" +
            "     \n" +
            "            ) s\n" +
            "          where 1=1\n" +
            "              and (\n" +
            "                   s.mojtama_id is not null\n" +
            "                   and s.moavenat_id is not null\n" +
            "                   and s.omoor_id is not null\n" +
            "                  )    \n" +
            "            \n" +
            "        GROUP BY\n" +
            "         \n" +
            "            s.class_id, \n" +
            "            s.mojtama_id,\n" +
            "            s.mojtama,\n" +
            "            moavenat_id,\n" +
            "            s.moavenat,\n" +
            "            s.omoor_id,\n" +
            "            s.omoor\n" +
            ") res\n" +
            " where 1=1\n" +
            "     AND (:complexNull = 1 OR complex IN (:complex)) \n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs))   ", nativeQuery = true)
    List<GenericStatisticalIndexReport> effectivenessRateOfOutputLevelTrainingBehavior(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
    @Query(value = """
                    -- Report62- nerkh poshesh arzyabi (sathe raftar)
                  
                  SELECT rowNum AS id,
                         res.*
                  FROM(     \s
                  
                   with kol as (SELECT DISTINCT
                              count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_kol_mojtama,
                               count(distinct s.class_id)  over (partition by  s.moavenat)  AS count__kol_moavenat,
                               count(distinct s.class_id)  over (partition by s.omoor)      AS count__kol_omoor,
                               s.mojtama_id,
                              s.mojtama,
                              moavenat_id,
                              s.moavenat,
                              s.omoor_id,
                              s.omoor
                           \s
                          FROM
                              (
                                  SELECT
                                      class.id               AS class_id,
                                      view_complex.id        AS mojtama_id,
                                      view_complex.c_title   AS mojtama,
                                      view_assistant.id      AS moavenat_id,
                                      view_assistant.c_title AS moavenat,
                                      view_affairs.id      AS omoor_id,
                                      view_affairs.c_title   AS omoor
                                  FROM
                                      tbl_class   class\s
                                      INNER JOIN tbl_class_student ON class.id = tbl_class_student.class_id
                                      INNER JOIN
                                      (
                                        select
                                              tbl_student.id                                                         as id
                                             ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                             ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                             ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                        \s
                                         from tbl_student\s
                                          LEFT JOIN view_last_md_employee_hr
                                          ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                      )
                                      tbl_student  ON tbl_class_student.student_id = tbl_student.id
                                      RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                      RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                      RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                 where 1=1
                                  and class.c_status IN ( 2, 3, 5 )\s
                                  and class.C_START_DATE >=:fromDate
                                  and class.C_START_DATE <=:toDate
                                  \s
                                  GROUP BY
                                      class.id,
                                      view_complex.c_title,
                                      view_complex.id,
                                      view_assistant.id,
                                       view_affairs.id,
                                      view_assistant.c_title,
                                      view_affairs.c_title
                      \s
                              ) s
                          GROUP BY
                          \s
                              s.class_id,\s
                              s.mojtama_id,
                              s.mojtama,
                              moavenat_id,
                              s.moavenat,
                              s.omoor_id,
                              s.omoor
                           having  nvl(count( s.class_id) ,0)  !=0
                           ),
                         \s
                          khod as(
                              SELECT DISTINCT
                                   count(distinct s.class_id)  over (partition by  s.mojtama)   AS count_raftar_mojtama,
                                   count(distinct s.class_id)  over (partition by  s.moavenat)  AS count_raftar_moavenat,
                                   count(distinct s.class_id)  over (partition by s.omoor)      AS count_raftar_omoor,
                                   s.mojtama_id,
                                   s.mojtama,
                                   moavenat_id,
                                   s.moavenat,
                                   s.omoor_id,
                                   s.omoor
                           \s
                             FROM
                              (
                                  SELECT
                                      class.class_id               AS class_id,
                                      view_complex.id        AS mojtama_id,
                                      view_complex.c_title   AS mojtama,
                                      view_assistant.id      AS moavenat_id,
                                      view_assistant.c_title AS moavenat,
                                      view_affairs.id        AS omoor_id,
                                      view_affairs.c_title   AS omoor
                                  FROM
                                      (\s
                                \s
                                                SELECT\s
                                                    class_id      AS class_id,\s
                                                    C_START_DATE  AS C_START_DATE,
                                                    CASE\s
                                                        WHEN all_behavioral_eval = 0 THEN\s
                                                            0\s
                                                        ELSE\s
                                                            CAST((filled_behavior_eval / all_behavioral_eval) * 100 AS DECIMAL(6, 2))\s
                                                    END AS percent_behavior\s
                                                FROM\s
                                                    (\s
                                                        SELECT DISTINCT\s
                                                            class.id           AS class_id,
                                                            class.C_START_DATE AS C_START_DATE,\s
                                                              (\s
                                                                SELECT\s
                                                                    COUNT(DISTINCT ex.id)\s
                                                                    from\s
                                                                tbl_class  cx        \s
                                                                  inner join TBL_EVALUATION   ex\s
                                                                   on ex.F_CLASS_ID = cx.id \s
                                                                    outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'Behavioral' ) raftari\s
                                                                where 1=1\s
                                                                and class.id =  cx.id\s
                                                                and ex.F_EVALUATION_LEVEL_ID = raftari.id --   156\s
                                                                and      ex.B_STATUS= 1 \s
                                                    \s
                                                            ) AS filled_behavior_eval,\s
                                                            (\s
                                                                 SELECT\s
                                                                    COUNT(DISTINCT ex.id)\s
                                                                    from\s
                                                                tbl_class  cx        \s
                                                                  inner join TBL_EVALUATION   ex\s
                                                                   on ex.F_CLASS_ID = cx.id \s
                                                                    outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'Behavioral' ) raftari\s
                                                                where 1=1\s
                                                                and class.id =  cx.id\s
                                                                and ex.F_EVALUATION_LEVEL_ID = raftari.id --   156\s
                                                                    \s
                                                            ) AS all_behavioral_eval\s
                                                        FROM\s
                                                               tbl_class  class        \s
                                                            inner join TBL_EVALUATION   e\s
                                                              on e.F_CLASS_ID = class.id\s
                                                              outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'Behavioral' ) raftari_id\s
                                                              \s
                                                              where 1=1\s
                                                                and e.F_EVALUATION_LEVEL_ID = raftari_id.id --   156\s
                                                \s
                                                    )\s
                                                   outer apply ( select C_VALUE as C_VALUE from TBL_PARAMETER_VALUE v where v.C_CODE = 'minQusEB' ) hadenesab\s
                                     \s
                                   where    CAST((filled_behavior_eval / all_behavioral_eval) * 100 AS DECIMAL(6, 2)) >= to_number(hadenesab.C_VALUE)\s
                                )    class
                                      INNER JOIN tbl_class_student ON class.class_id = tbl_class_student.class_id
                                       INNER JOIN
                                      (
                                        select
                                              tbl_student.id                                                         as id
                                             ,NVL(tbl_student.COMPLEX_TITLE,view_last_md_employee_hr.ccp_complex )   as COMPLEX_TITLE
                                             ,NVL(tbl_student.CCP_ASSISTANT,view_last_md_employee_hr.ccp_assistant ) as CCP_ASSISTANT
                                             ,NVL(tbl_student.CCP_AFFAIRS,view_last_md_employee_hr.ccp_affairs )     as CCP_AFFAIRS
                                        \s
                                         from tbl_student\s
                                          LEFT JOIN view_last_md_employee_hr
                                          ON tbl_student.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
                                      )
                                      tbl_student  ON tbl_class_student.student_id = tbl_student.id
                                      RIGHT JOIN view_complex ON tbl_student.COMPLEX_TITLE = view_complex.C_TITLE
                                      RIGHT JOIN view_affairs ON tbl_student.CCP_AFFAIRS = view_affairs.C_TITLE
                                      RIGHT JOIN view_assistant ON tbl_student.CCP_ASSISTANT = view_assistant.C_TITLE
                                 where 1=1\s
                   \s
                                  and class.C_START_DATE >= :fromDate
                                  and class.C_START_DATE <= :toDate
                                     \s
                                  GROUP BY
                                      class.class_id,
                                      view_complex.c_title,
                                       view_complex.id,
                                      view_assistant.id,
                                      view_affairs.id ,
                                      view_assistant.c_title,
                                      view_affairs.c_title
                      \s
                              ) s
                          GROUP BY
                          \s
                              s.class_id,\s
                              s.mojtama_id,
                              s.mojtama,
                              moavenat_id,
                              s.moavenat,
                              s.omoor_id,
                              s.omoor
                       \s
                           )
                         \s
                          select DISTINCT
                         \s
                          kol.mojtama_id     as complex_id
                          ,kol.mojtama       as complex
                          ,  max(cast ((khod.count_raftar_mojtama /kol.count_kol_mojtama)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS  n_base_on_complex
                         \s
                          , kol.moavenat_id  as assistant_id
                          , kol.moavenat     as assistant
                          ,max( cast ( (khod.count_raftar_moavenat /kol.count__kol_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant
                         \s
                          ,kol.omoor_id     as affairs_id
                          ,kol.omoor        as affairs
                          ,max(cast ( (khod.count_raftar_omoor /kol.count__kol_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs
                  
                          FROM
                          kol\s
                          LEFT JOIN  khod
                          on
                           khod.mojtama_id = kol.mojtama_id
                           and khod.moavenat_id = kol.moavenat_id
                           and khod.omoor_id = kol.omoor_id
                    \s
                          where 1=1
                                and (
                                     kol.mojtama_id is not null
                                     and kol.moavenat_id is not null
                                     and kol.omoor_id is not null
                                    )
                          \s
                          group by
                          kol.mojtama_id
                          ,kol.mojtama
                          ,khod.count_raftar_mojtama\s
                          ,khod.count_raftar_moavenat\s
                          ,khod.count_raftar_omoor\s
                          ,kol.count_kol_mojtama
                          ,kol.count__kol_moavenat
                          ,kol.count__kol_omoor
                          , kol.moavenat_id
                          , kol.moavenat
                          ,kol.omoor_id
                          ,kol.omoor
                  ) res
                   where 1=1
                       AND (:complexNull = 1 OR complex IN (:complex))\s
                       AND (:assistantNull = 1 OR assistant IN (:assistant))\s
                       AND (:affairsNull = 1 OR affairs IN (:affairs))\s  
 """ , nativeQuery = true)
    List<GenericStatisticalIndexReport> evaluationCoverageRateBehaviorLevel(String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);




    @Query(value =" SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            "SELECT DISTINCT     \n" +
            "               s.place_id                                          as complex_id,\n" +
            "               s.place_title                                       as complex,\n" +
            "               sum( cast(s.zarfiat as decimal(8,2)) )  over (partition by  s.place_id)    as n_base_on_complex\n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    nvl(to_number(place.C_CAPACITY),0) * 6 * 5  as zarfiat,\n" +
            "                    place.id                                    as place_id,\n" +
            "                   place.C_TITLE_FA                             as place_title\n" +
            "                FROM\n" +
            "                    TBL_TRAINING_PLACE place    \n" +
            "               \n" +
            "               where 1=1 \n" +
            "               and place.E_DELETED is null  \n" +
            "               and  place.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "               and  place.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                     \n" +
            "                GROUP BY\n" +
            "                    place.id,\n" +
            "                    place.C_TITLE_FA,\n" +
            "                    place.C_CAPACITY\n" +
            "            ) s\n" +
            "          where 1=1\n" +
            "     \n" +
            "        GROUP BY\n" +
            "            s.place_id,\n" +
            "            s.place_title,\n" +
            "            s.zarfiat\n" +
            ") res ", nativeQuery = true)
    List<Object> nominalTrainingCapacity(String fromDate,
                                                                           String toDate);


    @Query(value =" SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM(      \n" +
            "\n" +
            " with kol as (SELECT DISTINCT\n" +
            "            count(distinct s.COMMITTEE_id)  over (partition by  s.mojtama)   AS count_kol_mojtama,\n" +
            "            s.mojtama,\n" +
            "            s.COMMITTEE_id\n" +
            " \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    COMMITTEE.id               AS COMMITTEE_id,\n" +
            "                    TBL_COMMITTEE_OF_EXPERTS_COMPLEX.COMPLEX_VALUES   AS mojtama\n" +
            "                   \n" +
            "                FROM\n" +
            "                    TBL_COMMITTEE_OF_EXPERTS   COMMITTEE \n" +
            "                    INNER JOIN TBL_COMMITTEE_OF_EXPERTS_PERSONNEL PER ON COMMITTEE.id = PER.F_COMMITTEE_ID\n" +
            "                    LEFT JOIN TBL_COMMITTEE_OF_EXPERTS_COMPLEX ON  COMMITTEE.id  = TBL_COMMITTEE_OF_EXPERTS_COMPLEX.COMMITTEE_OF_EXPERTS_ID \n" +
            "                   \n" +
            "              where  1=1 \n" +
            "                     and COMMITTEE.E_DELETED is null\n" +
            "                     and  COMMITTEE.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                     and  COMMITTEE.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                           \n" +
            "                GROUP BY\n" +
            "                    COMMITTEE.id,\n" +
            "                    TBL_COMMITTEE_OF_EXPERTS_COMPLEX.COMPLEX_VALUES\n" +
            "\n" +
            "     \n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "            s.COMMITTEE_id, \n" +
            "            s.mojtama\n" +
            "          \n" +
            "         having  nvl(count( s.COMMITTEE_id) ,0)  !=0\n" +
            "         ),\n" +
            "        \n" +
            "        khod as( SELECT DISTINCT\n" +
            "            count(distinct s.COMMITTEE_id)  over (partition by  s.mojtama)   AS count_faal_mojtama,\n" +
            "            s.mojtama,\n" +
            "            s.COMMITTEE_id\n" +
            " \n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    COMMITTEE.id               AS COMMITTEE_id,\n" +
            "                    TBL_COMMITTEE_OF_EXPERTS_COMPLEX.COMPLEX_VALUES   AS mojtama\n" +
            "                   \n" +
            "                FROM\n" +
            "                    TBL_COMMITTEE_OF_EXPERTS   COMMITTEE \n" +
            "                    INNER JOIN TBL_COMMITTEE_OF_EXPERTS_PERSONNEL PER ON COMMITTEE.id = PER.F_COMMITTEE_ID\n" +
            "                    INNER JOIN  TBL_COMMITTEE_OF_EXPERTS_POST POST   ON COMMITTEE.id = POST.F_COMMITTEE_ID\n" +
            "                    LEFT JOIN TBL_COMMITTEE_OF_EXPERTS_COMPLEX ON  COMMITTEE.id  = TBL_COMMITTEE_OF_EXPERTS_COMPLEX.COMMITTEE_OF_EXPERTS_ID \n" +
            "                   \n" +
            "              where  1=1 \n" +
            "                     and COMMITTEE.E_DELETED is null\n" +
            "                     and  COMMITTEE.d_created_date >=  TO_DATE(:fromDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                     and  COMMITTEE.d_created_date <  TO_DATE(:toDate, 'yyyy/mm/dd','nls_calendar=persian')\n" +
            "                           \n" +
            "              GROUP BY\n" +
            "                    COMMITTEE.id,\n" +
            "                    TBL_COMMITTEE_OF_EXPERTS_COMPLEX.COMPLEX_VALUES\n" +
            "\n" +
            "            ) s\n" +
            "        GROUP BY\n" +
            "         \n" +
            "            s.COMMITTEE_id, \n" +
            "            s.mojtama\n" +
            "         )\n" +
            "        \n" +
            "        select DISTINCT\n" +
            "        \n" +
            "        kol.COMMITTEE_id            as complex_id,\n" +
            "         kol.mojtama     as complex\n" +
            "        ,sum(cast ((khod.count_faal_mojtama /kol.count_kol_mojtama)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama ) AS  n_base_on_complex\n" +
            "       \n" +
            "        FROM\n" +
            "        kol \n" +
            "        LEFT JOIN  khod\n" +
            "        on\n" +
            "         khod.mojtama = kol.mojtama\n" +
            "           \n" +
            "        where 1=1\n" +
            "              and   kol.mojtama is not null\n" +
            "                          \n" +
            "        group by\n" +
            "            kol.mojtama\n" +
            "            ,khod.count_faal_mojtama \n" +
            "            ,kol.count_kol_mojtama\n" +
            "            , kol.COMMITTEE_id\n" +
            "       \n" +
            ") res\n" +
            "where\n" +
            "  (:complexNull = 1 OR complex IN (:complex))", nativeQuery = true)
    List<Object> numberOfActiveExpertCommittees(String fromDate, String toDate, int complexNull, List<Object> complex);
}