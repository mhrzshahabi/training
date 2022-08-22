package com.nicico.training.repository;

import com.nicico.training.model.GenericStatisticalIndexReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GenericStatisticalIndexReportDAO extends JpaRepository<GenericStatisticalIndexReport, Long>, JpaSpecificationExecutor<GenericStatisticalIndexReport> {


    @Query(value = "SELECT rowNum AS id,\n" +
            "       res.*\n" +
            "FROM (\n" +
            "         SELECT DISTINCT complex,\n" +
            "                         complex_id,\n" +
            "                         CASE\n" +
            "                             WHEN SUM(sum_presence_hour)\n" +
            "                                      OVER (PARTITION BY complex) = 0 THEN\n" +
            "                                 0\n" +
            "                             ELSE\n" +
            "                                     round(SUM(DISTINCT\n" +
            "                                               CASE\n" +
            "                                                   WHEN tbl_course.e_technical_type = 2 THEN\n" +
            "                                                       sum_presence_hour\n" +
            "                                                   END\n" +
            "                                               )\n" +
            "                                               OVER (PARTITION BY complex) / SUM(sum_presence_hour)\n" +
            "                                                                                 OVER (PARTITION BY complex), 2) * 100\n" +
            "                             END AS n_base_on_complex,\n" +
            "                         assistant,\n" +
            "                         assistant_id,\n" +
            "                         CASE\n" +
            "                             WHEN SUM(sum_presence_hour)\n" +
            "                                      OVER (PARTITION BY assistant) = 0 THEN\n" +
            "                                 0\n" +
            "                             ELSE\n" +
            "                                     round(SUM(DISTINCT\n" +
            "                                               CASE\n" +
            "                                                   WHEN tbl_course.e_technical_type = 2 THEN\n" +
            "                                                       sum_presence_hour\n" +
            "                                                   END\n" +
            "                                               )\n" +
            "                                               OVER (PARTITION BY assistant) / SUM(sum_presence_hour)\n" +
            "                                                                                   OVER (PARTITION BY assistant), 2) *\n" +
            "                                     100\n" +
            "                             END AS n_base_on_assistant,\n" +
            "                         affairs,\n" +
            "                         affairs_id,\n" +
            "                         CASE\n" +
            "                             WHEN SUM(sum_presence_hour)\n" +
            "                                      OVER (PARTITION BY affairs) = 0 THEN\n" +
            "                                 0\n" +
            "                             ELSE\n" +
            "                                     round(SUM(DISTINCT\n" +
            "                                               CASE\n" +
            "                                                   WHEN tbl_course.e_technical_type = 2 THEN\n" +
            "                                                       sum_presence_hour\n" +
            "                                                   END\n" +
            "                                               )\n" +
            "                                               OVER (PARTITION BY affairs) / SUM(sum_presence_hour)\n" +
            "                                                                                 OVER (PARTITION BY affairs), 2) * 100\n" +
            "                             END AS n_base_on_affairs\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT SUM(s.presence_hour)   AS sum_presence_hour,\n" +
            "                                  SUM(s.presence_minute) AS sum_presence_minute,\n" +
            "                                  SUM(s.absence_hour)    AS sum_absence_hour,\n" +
            "                                  SUM(s.absence_minute)  AS sum_absence_minute,\n" +
            "                                  s.class_id             AS class_id,\n" +
            "                                  s.affairs,\n" +
            "                                  s.assistant,\n" +
            "                                  s.assistant_id,\n" +
            "                                  s.affairs_id,\n" +
            "                                  s.complex_id,\n" +
            "                                  s.complex,\n" +
            "                                  s.e_technical_type,\n" +
            "                                  s.c_end_date,\n" +
            "                                  s.c_start_date,\n" +
            "                                  s.f_course,\n" +
            "                                  CASE\n" +
            "                                      WHEN s.e_technical_type = '1' THEN\n" +
            "                                          'عمومی'\n" +
            "                                      WHEN s.e_technical_type = '2' THEN\n" +
            "                                          'تخصصی'\n" +
            "                                      WHEN s.e_technical_type = '3' THEN\n" +
            "                                          'مدیریتی'\n" +
            "                                      END                AS technical_title\n" +
            "                  FROM (\n" +
            "                           SELECT class.id               AS class_id,\n" +
            "                                  std.id                 AS student_id,\n" +
            "                                  SUM(\n" +
            "                                          CASE\n" +
            "                                              WHEN att.c_state IN ('1', '2') THEN\n" +
            "                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') -\n" +
            "                                                                  to_date(csession.c_session_start_hour,\n" +
            "                                                                          'HH24:MI')) * 24, 1)\n" +
            "                                              ELSE\n" +
            "                                                  0\n" +
            "                                              END\n" +
            "                                      )                  AS presence_hour,\n" +
            "                                  SUM(\n" +
            "                                          CASE\n" +
            "                                              WHEN att.c_state IN ('1', '2') THEN\n" +
            "                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') -\n" +
            "                                                                  to_date(csession.c_session_start_hour,\n" +
            "                                                                          'HH24:MI')) * 24 * 60)\n" +
            "                                              ELSE\n" +
            "                                                  0\n" +
            "                                              END\n" +
            "                                      )                  AS presence_minute,\n" +
            "                                  SUM(\n" +
            "                                          CASE\n" +
            "                                              WHEN att.c_state IN ('3', '4') THEN\n" +
            "                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') -\n" +
            "                                                                  to_date(csession.c_session_start_hour,\n" +
            "                                                                          'HH24:MI')) * 24, 1)\n" +
            "                                              ELSE\n" +
            "                                                  0\n" +
            "                                              END\n" +
            "                                      )                  AS absence_hour,\n" +
            "                                  SUM(\n" +
            "                                          CASE\n" +
            "                                              WHEN att.c_state IN ('3', '4') THEN\n" +
            "                                                  round(to_number(to_date(csession.c_session_end_hour, 'HH24:MI') -\n" +
            "                                                                  to_date(csession.c_session_start_hour,\n" +
            "                                                                          'HH24:MI')) * 24 * 60)\n" +
            "                                              ELSE\n" +
            "                                                  0\n" +
            "                                              END\n" +
            "                                      )                  AS absence_minute,\n" +
            "                                  class.c_start_date,\n" +
            "                                  class.f_course,\n" +
            "                                  class.c_end_date,\n" +
            "                                  tbl_course.e_technical_type,\n" +
            "                                  view_complex.c_title   AS complex,\n" +
            "                                  class.complex_id,\n" +
            "                                  class.assistant_id,\n" +
            "                                  class.affairs_id,\n" +
            "                                  view_assistant.c_title AS assistant,\n" +
            "                                  view_affairs.c_title   AS affairs\n" +
            "                           FROM tbl_attendance att\n" +
            "                                    INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                                    INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                                    INNER JOIN tbl_class class ON csession.f_class_id = class.id\n" +
            "                                    INNER JOIN tbl_course ON class.f_course = tbl_course.id\n" +
            "                                    LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                                    LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                                    LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "                           GROUP BY class.id,\n" +
            "                                    std.id,\n" +
            "                                    class.c_start_date,\n" +
            "                                    class.f_course,\n" +
            "                                    class.c_end_date,\n" +
            "                                    tbl_course.e_technical_type,\n" +
            "                                    view_complex.c_title,\n" +
            "                                    class.complex_id,\n" +
            "                                    class.assistant_id,\n" +
            "                                    class.affairs_id,\n" +
            "                                    view_assistant.c_title,\n" +
            "                                    view_affairs.c_title,\n" +
            "                                    csession.c_session_date,\n" +
            "                                    class.c_code\n" +
            "                       ) s\n" +
            "                  GROUP BY s.class_id,\n" +
            "                           s.affairs,\n" +
            "                           s.assistant,\n" +
            "                           s.assistant_id,\n" +
            "                           s.affairs_id,\n" +
            "                           s.complex_id,\n" +
            "                           s.complex,\n" +
            "                           s.e_technical_type,\n" +
            "                           s.c_end_date,\n" +
            "                           s.c_start_date,\n" +
            "                           s.f_course\n" +
            "              )\n" +
            "                  INNER JOIN tbl_course ON f_course = tbl_course.id\n" +
            "         WHERE c_start_date >=:fromDate\n" +
            "           AND c_start_date <=:toDate\n" +
            "           AND f_course IN (\n" +
            "             SELECT DISTINCT tbl_course.id\n" +
            "             FROM tbl_needs_assessment\n" +
            "                      INNER JOIN tbl_skill ON tbl_needs_assessment.f_skill = tbl_skill.id\n" +
            "                      INNER JOIN tbl_course ON tbl_skill.f_main_objective_course = tbl_course.id\n" +
            "             WHERE tbl_skill.e_deleted IS NULL\n" +
            "         )\n" +
            "           AND (:complexNull = 1 OR complex IN (:complex))\n" +
            "           AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "           AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "     ) res", nativeQuery = true)
    List<GenericStatisticalIndexReport> getTechnicalTrainingNeeds(String fromDate,
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
            "SELECT DISTINCT\n" +
            "    complex                      AS complex,\n" +
            "    complex_id as complex_id,\n" +
            "    SUM(sum_presence_hour)\n" +
            "    OVER(PARTITION BY complex)   AS n_base_on_complex,\n" +
            "    assistant                    AS assistant,\n" +
            "    assistant_id as assistant_id,\n" +
            "    SUM(sum_presence_hour)\n" +
            "    OVER(PARTITION BY assistant) AS n_base_on_assistant,\n" +
            "    affairs                      AS affairs,\n" +
            "    affairs_id as affairs_id,\n" +
            "    SUM(sum_presence_hour)\n" +
            "    OVER(PARTITION BY affairs)   AS n_base_on_affairs\n" +
            "FROM\n" +
            "    (\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            CASE\n" +
            "                WHEN s.e_technical_type = '1' THEN\n" +
            "                    'عمومی'\n" +
            "                WHEN s.e_technical_type = '2' THEN\n" +
            "                    'تخصصی'\n" +
            "                WHEN s.e_technical_type = '3' THEN\n" +
            "                    'مدیریتی'\n" +
            "            END                    AS technical_title\n" +
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
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date\n" +
            "    )\n" +
            "    WHERE\n" +
            " \n" +
            "    c_start_date >= :fromDate\n" +
            "    and\n" +
            "        c_start_date <= :toDate\n" +
            "        AND (:complexNull = 1 OR complex IN (:complex))\n" +
            "         AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "          AND (:affairsNull = 1 OR affairs IN (:affairs)) ) res", nativeQuery = true)
    List<GenericStatisticalIndexReport> getTotalHours(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);


    @Query(value = "SELECT rowNum AS id,\n" +
            "                             res.*\n" +
            "                       FROM (\n" +
            "SELECT \n" +
            "DISTINCT\n" +
            "    complex ,\n" +
            "    complex_id,\n" +
            "    n_base_on_complex,\n" +
            "    assistant,\n" +
            "    assistant_id,\n" +
            "    n_base_on_assistant,\n" +
            "    affairs,\n" +
            "    affairs_id,\n" +
            "    n_base_on_affairs\n" +
            "    \n" +
            "    FROM (\n" +
            "SELECT DISTINCT\n" +
            "    complex,\n" +
            "    complex_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY complex) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY complex, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                 OVER(PARTITION BY complex), 2)\n" +
            "    END AS n_base_on_complex,\n" +
            "    assistant,\n" +
            "    assistant_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY assistant) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY assistant, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                   OVER(PARTITION BY assistant), 2)\n" +
            "    END AS n_base_on_assistant,\n" +
            "    affairs,\n" +
            "    affairs_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY affairs) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY affairs, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                 OVER(PARTITION BY affairs), 2)\n" +
            "    END AS n_base_on_affairs,\n" +
            "    e_technical_type ,\n" +
            "    c_start_date,\n" +
            "    c_end_date\n" +
            "    \n" +
            "FROM\n" +
            "    (\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            CASE\n" +
            "                WHEN s.e_technical_type = '1' THEN\n" +
            "                    'عمومی'\n" +
            "                WHEN s.e_technical_type = '2' THEN\n" +
            "                    'تخصصی'\n" +
            "                WHEN s.e_technical_type = '3' THEN\n" +
            "                    'مدیریتی'\n" +
            "            END                    AS technical_title\n" +
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
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "                 \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    std.id,\n" +
            "                    class.c_start_date,\n" +
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date\n" +
            "    ))\n" +
            "    WHERE\n" +
            "    e_technical_type = 1\n" +
            "    and\n" +
            "        c_start_date >= :fromDate\n" +
            "    and\n" +
            "       c_start_date <= :toDate\n" +
            "        \n" +
            "        AND (:complexNull = 1 OR complex IN (:complex))\n" +
            "        AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "        AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "        ) res\n" +
            "  ", nativeQuery = true)
    List<GenericStatisticalIndexReport> saraneomomi(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);

    @Query(value = "SELECT rowNum AS id,\n" +
            "                             res.*\n" +
            "                       FROM (\n" +
            "SELECT \n" +
            "DISTINCT\n" +
            "    complex ,\n" +
            "    complex_id,\n" +
            "    n_base_on_complex,\n" +
            "    assistant,\n" +
            "    assistant_id,\n" +
            "    n_base_on_assistant,\n" +
            "    affairs,\n" +
            "    affairs_id,\n" +
            "    n_base_on_affairs\n" +
            "    \n" +
            "    FROM (\n" +
            "SELECT DISTINCT\n" +
            "    complex,\n" +
            "    complex_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY complex) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY complex, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                 OVER(PARTITION BY complex), 2)\n" +
            "    END AS n_base_on_complex,\n" +
            "    assistant,\n" +
            "    assistant_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY assistant) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY assistant, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                   OVER(PARTITION BY assistant), 2)\n" +
            "    END AS n_base_on_assistant,\n" +
            "    affairs,\n" +
            "    affairs_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY affairs) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY affairs, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                 OVER(PARTITION BY affairs), 2)\n" +
            "    END AS n_base_on_affairs,\n" +
            "    e_technical_type ,\n" +
            "    c_start_date,\n" +
            "    c_end_date\n" +
            "    \n" +
            "FROM\n" +
            "    (\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            CASE\n" +
            "                WHEN s.e_technical_type = '1' THEN\n" +
            "                    'عمومی'\n" +
            "                WHEN s.e_technical_type = '2' THEN\n" +
            "                    'تخصصی'\n" +
            "                WHEN s.e_technical_type = '3' THEN\n" +
            "                    'مدیریتی'\n" +
            "            END                    AS technical_title\n" +
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
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "                 \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    std.id,\n" +
            "                    class.c_start_date,\n" +
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date\n" +
            "    ))\n" +
            "    WHERE\n" +
            "    e_technical_type = 2\n" +
            "    and\n" +
            "        c_start_date >= :fromDate\n" +
            "    and\n" +
            "       c_start_date <= :toDate\n" +
            "        \n" +
            "        AND (:complexNull = 1 OR complex IN (:complex))\n" +
            "        AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "        AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "        ) res\n" +
            "  ", nativeQuery = true)
    List<GenericStatisticalIndexReport> saratakhasosi(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);

    @Query(value = "SELECT rowNum AS id,\n" +
            "                             res.*\n" +
            "                       FROM (\n" +
            "SELECT \n" +
            "DISTINCT\n" +
            "    complex ,\n" +
            "    complex_id,\n" +
            "    n_base_on_complex,\n" +
            "    assistant,\n" +
            "    assistant_id,\n" +
            "    n_base_on_assistant,\n" +
            "    affairs,\n" +
            "    affairs_id,\n" +
            "    n_base_on_affairs\n" +
            "    \n" +
            "    FROM (\n" +
            "SELECT DISTINCT\n" +
            "    complex,\n" +
            "    complex_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY complex) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY complex, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                 OVER(PARTITION BY complex), 2)\n" +
            "    END AS n_base_on_complex,\n" +
            "    assistant,\n" +
            "    assistant_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY assistant) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY assistant, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                   OVER(PARTITION BY assistant), 2)\n" +
            "    END AS n_base_on_assistant,\n" +
            "    affairs,\n" +
            "    affairs_id,\n" +
            "    CASE\n" +
            "        WHEN SUM(sum_presence_hour)\n" +
            "             OVER(PARTITION BY affairs) = 0 THEN\n" +
            "            0\n" +
            "        ELSE\n" +
            "            round(SUM(sum_presence_hour)\n" +
            "                  OVER(PARTITION BY affairs, e_technical_type) / SUM(sum_presence_hour)\n" +
            "                                                                 OVER(PARTITION BY affairs), 2)\n" +
            "    END AS n_base_on_affairs,\n" +
            "    e_technical_type ,\n" +
            "    c_start_date,\n" +
            "    c_end_date\n" +
            "    \n" +
            "FROM\n" +
            "    (\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            CASE\n" +
            "                WHEN s.e_technical_type = '1' THEN\n" +
            "                    'عمومی'\n" +
            "                WHEN s.e_technical_type = '2' THEN\n" +
            "                    'تخصصی'\n" +
            "                WHEN s.e_technical_type = '3' THEN\n" +
            "                    'مدیریتی'\n" +
            "            END                    AS technical_title\n" +
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
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "                 \n" +
            "                GROUP BY\n" +
            "                    class.id,\n" +
            "                    std.id,\n" +
            "                    class.c_start_date,\n" +
            "                    class.c_end_date,\n" +
            "                    tbl_course.e_technical_type,\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date\n" +
            "    ))\n" +
            "    WHERE\n" +
            "    e_technical_type = 3\n" +
            "    and\n" +
            "        c_start_date >= :fromDate\n" +
            "    and\n" +
            "       c_start_date <= :toDate\n" +
            "        \n" +
            "        AND (:complexNull = 1 OR complex IN (:complex))\n" +
            "        AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "        AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "        ) res\n" +
            "  ", nativeQuery = true)
    List<GenericStatisticalIndexReport> saraneModiriati(String fromDate,
                                                                  String toDate,
                                                                  List<Object> complex,
                                                                  int complexNull,
                                                                  List<Object> assistant,
                                                                  int assistantNull,
                                                                  List<Object> affairs,
                                                                  int affairsNull);




    @Query(value = "SELECT\n" +
            "    ROWNUM AS id,\n" +
            "    res.*\n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT DISTINCT\n" +
            "            complex,\n" +
            "            CASE\n" +
            "                WHEN COUNT(national_code)\n" +
            "                     OVER(PARTITION BY complex) = 0 THEN\n" +
            "                    0\n" +
            "                ELSE\n" +
            "                    round(COUNT(DISTINCT\n" +
            "                        CASE\n" +
            "                            WHEN ghabol LIKE '%قبول%' THEN\n" +
            "                                national_code\n" +
            "                        END\n" +
            "                    )\n" +
            "                          OVER(PARTITION BY complex) / COUNT(national_code)\n" +
            "                                                       OVER(PARTITION BY complex), 2) * 100\n" +
            "            END AS n_base_on_complex,\n" +
            "            assistant,\n" +
            "            CASE\n" +
            "                WHEN COUNT(national_code)\n" +
            "                     OVER(PARTITION BY assistant) = 0 THEN\n" +
            "                    0\n" +
            "                ELSE\n" +
            "                    round(COUNT(DISTINCT\n" +
            "                        CASE\n" +
            "                            WHEN ghabol LIKE '%قبول%' THEN\n" +
            "                                national_code\n" +
            "                        END\n" +
            "                    )\n" +
            "                          OVER(PARTITION BY assistant) / COUNT(national_code)\n" +
            "                                                         OVER(PARTITION BY assistant), 2) * 100\n" +
            "            END AS n_base_on_assistant,\n" +
            "            affairs,\n" +
            "            CASE\n" +
            "                WHEN COUNT(national_code)\n" +
            "                     OVER(PARTITION BY affairs) = 0 THEN\n" +
            "                    0\n" +
            "                ELSE\n" +
            "                    round(COUNT(DISTINCT\n" +
            "                        CASE\n" +
            "                            WHEN ghabol LIKE '%قبول%' THEN\n" +
            "                                national_code\n" +
            "                        END\n" +
            "                    )\n" +
            "                          OVER(PARTITION BY affairs) / COUNT(national_code)\n" +
            "                                                       OVER(PARTITION BY affairs), 2) * 100\n" +
            "            END AS n_base_on_affairs,\n" +
            "            complex_id,\n" +
            "            assistant_id,\n" +
            "            affairs_id\n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT DISTINCT\n" +
            "                    tbl_student.national_code,\n" +
            "                    tbl_class_student.class_id,\n" +
            "                    tbl_student.id              AS student_id,\n" +
            "                    tbl_class.complex_id,\n" +
            "                    tbl_class.assistant_id,\n" +
            "                    tbl_class.affairs_id,\n" +
            "                    view_complex.c_title        AS complex,\n" +
            "                    view_affairs.c_title        AS affairs,\n" +
            "                    view_assistant.c_title      AS assistant,\n" +
            "                    tbl_class.c_start_date,\n" +
            "                    tbl_class.c_end_date,\n" +
            "                    tbl_class_student.scores_state_id,\n" +
            "                    tbl_parameter_value.c_title AS ghabol\n" +
            "                FROM\n" +
            "                         tbl_class_student\n" +
            "                    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "                    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                    LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                    LEFT JOIN view_assistant ON tbl_class.assistant_id = view_assistant.id\n" +
            "                    LEFT JOIN view_affairs ON tbl_class.affairs_id = view_affairs.id\n" +
            "                    INNER JOIN tbl_parameter_value ON tbl_class_student.scores_state_id = tbl_parameter_value.id\n" +
            "                WHERE\n" +
            "                    tbl_class_student.e_deleted IS NULL\n" +
            "                    and\n" +
            "    tbl_class.c_start_date >= :fromDate\n" +
            "    and\n" +
            "        tbl_class.c_start_date <= :toDate\n" +
            "            )\n" +
            "        WHERE\n" +
            "               (:complexNull = 1 OR complex IN (:complex))\n" +
            "               AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "               AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "               \n" +
            "    ) res", nativeQuery = true)
    List<GenericStatisticalIndexReport> gozarAzAmozesh(String fromDate,
                                                        String toDate,
                                                        List<Object> complex,
                                                        int complexNull,
                                                        List<Object> assistant,
                                                        int assistantNull,
                                                        List<Object> affairs,
                                                        int affairsNull);



    @Query(value = "SELECT rowNum AS id,\n" +
            "                  res.*\n" +
            "            FROM (\n" +
            "SELECT\n" +
            "DISTINCT\n" +
            "complex\n" +
            "     \n" +
            "     \n" +
            "\n" +
            ",\n" +
            "                                                                                                                  case\n" +
            "when count(id)  OVER(PARTITION BY complex) = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(count(distinct case when learning = 1 then id end)\n" +
            "          OVER(PARTITION BY complex) / count(id)\n" +
            "                                                         OVER(PARTITION BY complex), 2) * 100 \n" +
            "end AS n_base_on_complex\n" +
            "\n" +
            ",\n" +
            "\n" +
            "assistant\n" +
            "     \n" +
            "     \n" +
            "\n" +
            ",\n" +
            "                                                                                                                  case\n" +
            "when count(id)  OVER(PARTITION BY assistant) = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(count(distinct case when learning = 1 then id end)\n" +
            "          OVER(PARTITION BY assistant) / count(id)\n" +
            "                                                         OVER(PARTITION BY assistant), 2) * 100 \n" +
            "end AS n_base_on_assistant\n" +
            "\n" +
            ",\n" +
            "\n" +
            "affairs\n" +
            "     \n" +
            "     \n" +
            "\n" +
            ",\n" +
            "                                                                                                                  case\n" +
            "when count(id)  OVER(PARTITION BY affairs) = 0 -- the divisor\n" +
            "then 0 -- a default value\n" +
            "else round(count(distinct case when learning = 1 then id end)\n" +
            "          OVER(PARTITION BY affairs) / count(id)\n" +
            "                                                         OVER(PARTITION BY affairs), 2) * 100 \n" +
            "end AS n_base_on_affairs,\n" +
            "\n" +
            "  complex_id,\n" +
            "    assistant_id,\n" +
            "    affairs_id\n" +
            "\n" +
            "\n" +
            "     \n" +
            "     \n" +
            "            \n" +
            "                                                         \n" +
            "                                                         \n" +
            "    \n" +
            "     FROM\n" +
            " (\n" +
            "SELECT DISTINCT\n" +
            "    tbl_class.id,\n" +
            "    tbl_class.c_end_date,\n" +
            "    tbl_class.c_start_date,\n" +
            "    tbl_class.complex_id,\n" +
            "    tbl_class.affairs_id,\n" +
            "    tbl_class.assistant_id,\n" +
            "    view_complex.c_title   AS complex,\n" +
            "    view_assistant.c_title AS assistant,\n" +
            "    view_affairs.c_title   AS affairs,\n" +
            "    tbl_class.c_status,\n" +
            "    tbl_evaluation_analysis.b_learning_pass as learning\n" +
            "FROM\n" +
            "    tbl_class\n" +
            "    LEFT JOIN view_affairs ON tbl_class.affairs_id = view_affairs.id\n" +
            "    LEFT JOIN view_assistant ON tbl_class.assistant_id = view_assistant.id\n" +
            "    LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "    INNER JOIN tbl_evaluation_analysis ON tbl_class.id = tbl_evaluation_analysis.f_tclass\n" +
            "    \n" +
            "WHERE\n" +
            "    tbl_class.c_status IN ( 2, 3, 5 )\n" +
            " \n" +
            "    and\n" +
            "    tbl_class.c_start_date >= :fromDate\n" +
            "    and\n" +
            "        tbl_class.c_start_date <= :toDate\n" +
            "\n" +
            "    )    WHERE (:complexNull = 1 OR complex IN (:complex))\n" +
            "     AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "     AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "     )res", nativeQuery = true)
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



    @Query(value = "SELECT rowNum AS id,\n" +
            "                               res.*\n" +
            "                        FROM (\n" +
            "\n" +
            "SELECT DISTINCT\n" +
            "    complex                      AS complex,\n" +
            "    complex_id,\n" +
            "    SUM(sum_presence_hour)\n" +
            "    OVER(PARTITION BY complex)   AS n_base_on_complex,\n" +
            "    assistant                    AS assistant,\n" +
            "    assistant_id,\n" +
            "    SUM(sum_presence_hour)\n" +
            "    OVER(PARTITION BY assistant) AS n_base_on_assistant,\n" +
            "    affairs                      AS affairs,\n" +
            "    affairs_id,\n" +
            "    SUM(sum_presence_hour)\n" +
            "    OVER(PARTITION BY affairs)   AS n_base_on_affairs,\n" +
            "    c_start_date,\n" +
            "    c_end_date\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            s.f_course,\n" +
            "            CASE\n" +
            "                WHEN s.e_technical_type = '1' THEN\n" +
            "                    'عمومی'\n" +
            "                WHEN s.e_technical_type = '2' THEN\n" +
            "                    'تخصصی'\n" +
            "                WHEN s.e_technical_type = '3' THEN\n" +
            "                    'مدیریتی'\n" +
            "            END                    AS technical_title\n" +
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
            "            s.c_end_date,\n" +
            "            s.c_start_date,\n" +
            "            s.f_course\n" +
            "    )\n" +
            "    INNER JOIN tbl_course ON f_course = tbl_course.id\n" +
            "WHERE\n" +
            "        c_start_date >= :fromDate\n" +
            "    AND c_start_date <= :toDate\n" +
            "    AND \n" +
            "    f_course IN (\n" +
            "        SELECT DISTINCT\n" +
            "            tbl_course.id\n" +
            "        FROM\n" +
            "                 tbl_needs_assessment\n" +
            "            INNER JOIN tbl_skill ON tbl_needs_assessment.f_skill = tbl_skill.id\n" +
            "            INNER JOIN tbl_course ON tbl_skill.f_main_objective_course = tbl_course.id\n" +
            "        WHERE\n" +
            "            tbl_skill.e_deleted IS NULL\n" +
            "    )\n" +
            "    \n" +
            "   AND (:complexNull = 1 OR complex IN (:complex))\n" +
            "   AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "    AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "    )res", nativeQuery = true)
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
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
    @Query(value = " -- -- nesbat amozesh hay otj\n" +
            "SELECT\n" +
            "rowNum AS id,\n" +
            "    res.* FROM(\n" +
            " with kol as(\n" +
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
            "                INNER JOIN tbl_class_student classstd\n" +
            "                ON classstd.class_id = class.id\n" +
            "                 LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "        WHERE 1=1\n" +
            "                 and class.C_START_DATE >= :fromDate\n" +
            "                  and class.C_START_DATE <= :toDate\n" +
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
            "otj as(\n" +
            "    SELECT DISTINCT\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS sum_presence_hour_otj_mojtama,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS sum_presence_hour_otj_moavenat,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS sum_presence_hour_otj_omoor,\n" +
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
            "         and class.C_TEACHING_TYPE =  'آموزش حین کار'\n" +
            "    and class.C_START_DATE >= :fromDate\n" +
            "                  and class.C_START_DATE <= :toDate\n" +
            "          -- and class.C_START_DATE <=@\n" +
            "          -- and class.C_END_DATE   =>@\n" +
            "     --      and view_complex.id =@\n" +
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
            ",sum(cast (  (otj.sum_presence_hour_otj_mojtama /kol.kol_nafar_satat_pish_bini_mojtama) *100 as decimal(6,2)) ) OVER ( PARTITION BY kol.mojtama_id ) AS n_base_on_complex\n" +
            "\n" +
            ", kol.moavenat_id  as assistant_id\n" +
            ", kol.moavenat as assistant\n" +
            ",sum( cast ( (otj.sum_presence_hour_otj_moavenat /kol.kol_nafar_satat_pish_bini_moavenat)*100 as decimal(6,2))) OVER ( PARTITION BY  kol.moavenat_id ) AS n_base_on_assistant\n" +
            "\n" +
            ",kol.omoor_id as affairs_id\n" +
            ",kol.omoor as affairs\n" +
            ",sum(cast ( (otj.sum_presence_hour_otj_omoor /kol.kol_nafar_satat_pish_bini_omoor)*100 as decimal(6,2)) ) OVER ( PARTITION BY kol.omoor_id ) AS n_base_on_affairs\n" +
            "\n" +
            "FROM\n" +
            " kol\n" +
            "LEFT JOIN   otj\n" +
            "on\n" +
            " otj.mojtama_id = kol.mojtama_id\n" +
            " and otj.moavenat_id = kol.moavenat_id\n" +
            " and otj.omoor_id = kol.omoor_id\n" +
            "\n" +
            "group by\n" +
            "kol.mojtama_id\n" +
            ",kol.mojtama\n" +
            ",otj.sum_presence_hour_otj_mojtama \n" +
            ",otj.sum_presence_hour_otj_moavenat \n" +
            ",otj.sum_presence_hour_otj_omoor \n" +
            ",kol.kol_nafar_satat_pish_bini_mojtama\n" +
            ",kol.kol_nafar_satat_pish_bini_moavenat\n" +
            ",kol.kol_nafar_satat_pish_bini_omoor\n" +
            ", kol.moavenat_id\n" +
            ", kol.moavenat\n" +
            ",kol.omoor_id\n" +
            ",kol.omoor\n" +
            ")res\n" +
            "where\n" +
            "(:complexNull = 1 OR complex IN (:complex))\n" +
            "AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
            "         and p.DELETED =0\n" +
            "         and ( \n" +
            "            p.POST_GRADE_TITLE is not null\n" +
            "            and p.POST_GRADE_TITLE not like '%سرپرست و کارشناس ارشد%' --farsi\n" +
            "            and p.POST_GRADE_TITLE not like '%رئیس%'  --farsi\n" +
            "            and p.POST_GRADE_TITLE not like '%معاون مدیرعامل%'  --farsi\n" +
            "            and p.POST_GRADE_TITLE not like  '%اجرایی%' --farsi\n" +
            "            and p.POST_GRADE_TITLE not like  '%مدیرعامل%' --farsi\n" +
            "            and p.POST_GRADE_TITLE not like  '%مسئول و کارشناس%' --farsi\n" +
            "            and p.POST_GRADE_TITLE not like  '%مدیر%' --farsi\n" +
            "           \n" +
            "           and p.POST_GRADE_TITLE not like '%سرپرست و کارشناس ارشد%' --arabic\n" +
            "           and p.POST_GRADE_TITLE not like '%رئیس%' --arabic\n" +
            "           and p.POST_GRADE_TITLE not like '%معاون مدیرعامل%' --arabic\n" +
            "           and p.POST_GRADE_TITLE not like '%اجرایی%' --arabic\n" +
            "           and p.POST_GRADE_TITLE not like '%مدیرعامل%' --arabic\n" +
            "           and p.POST_GRADE_TITLE not like '%مسئول و کارشناس%' --arabic\n" +
            "           and p.POST_GRADE_TITLE not like '%مدیر%' --arabic\n" +
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
            "         and p.DELETED =0\n" +
            "         and ( p.POST_GRADE_TITLE like '%سرپرست و کارشناس ارشد%' --farsi\n" +
            "               or\n" +
            "               p.POST_GRADE_TITLE like '%سرپرست و کارشناس ارشد%' --arabic\n" +
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
            "         and p.DELETED =0\n" +
            "         and ( p.POST_GRADE_TITLE like '%مدیر%' --farsi\n" +
            "               or\n" +
            "               p.POST_GRADE_TITLE like '%مدیر%' --arabic\n" +
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
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





    @Query(value = "  -- nerkh nofoz amozesh be tafkik omoor\n" +
            "\n" +
            "SELECT \n" +
            "                                                   rowNum AS id,\n" +
            "                                                    res.* FROM(\n" +
            "    SELECT DISTINCT\n" +
            "    \n" +
            "          \n" +
            "        s.mojtama_id as complex_id,\n" +
            "        s.mojtama as complex,\n" +
            "        SUM(s.presence_hour) over (partition by  s.mojtama)  AS n_base_on_complex,\n" +
            "        \n" +
            "        s.moavenat_id as assistant_id,\n" +
            "        s.moavenat as assistant,\n" +
            "        SUM(s.presence_hour) over (partition by  s.moavenat)  AS n_base_on_assistant,\n" +
            "        \n" +
            "        s.omoor_id as affairs_id,\n" +
            "        s.omoor as affairs,\n" +
            "        SUM(s.presence_hour) over (partition by  s.omoor)  AS n_base_on_affairs\n" +
            "    \n" +
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
            "                view_affairs.c_title   AS omoor,\n" +
            "                std.CCP_AFFAIRS        AS student_omoor  \n" +
            "            FROM\n" +
            "                     tbl_attendance att\n" +
            "                INNER JOIN tbl_student std ON att.f_student = std.id\n" +
            "                INNER JOIN tbl_session csession ON att.f_session = csession.id\n" +
            "                INNER JOIN tbl_class   class ON csession.f_class_id = class.id\n" +
            "                LEFT JOIN view_complex ON class.complex_id = view_complex.id\n" +
            "                LEFT JOIN view_affairs ON class.affairs_id = view_affairs.id\n" +
            "                LEFT JOIN view_assistant ON class.assistant_id = view_assistant.id\n" +
            "          WHERE 1=1\n" +
            "          and class.C_START_DATE >= :fromDate  \n" +
            "                                                                       and class.C_START_DATE <= :toDate\n" +
            "--            and class.C_STATUS in (3,5) --finish/lock\n" +
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
            "                class.c_code,\n" +
            "                std.CCP_AFFAIRS \n" +
            "        ) s\n" +
            "        where 1=1\n" +
            "             and (  s.mojtama_id is not null\n" +
            "                     and moavenat_id is not null\n" +
            "                     and s.omoor_id is not null\n" +
            "                     and  s.student_omoor is not null\n" +
            "                 )\n" +
            "    GROUP BY\n" +
            "        s.presence_hour,\n" +
            "        s.mojtama_id,\n" +
            "        s.mojtama,\n" +
            "        s.moavenat_id,\n" +
            "        s.moavenat,\n" +
            "        s.omoor_id,\n" +
            "        s.omoor,\n" +
            "        s.student_omoor \n" +
            "\n" +
            ")res\n" +
            "          \n" +
            "            where \n" +
            "                                                        (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                                  AND (:assistantNull = 1 OR assistant IN (:assistant)) \n" +
            "                                                        AND (:affairsNull = 1 OR affairs IN (:affairs))\n", nativeQuery = true)
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
            "    LEFT JOIN tbl_post ON tbl_needs_assessment.f_object = devtraining.tbl_post.id AND tbl_needs_assessment.c_object_type = 'Post'\n" +
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


    @Query(value = "-- nerkh_poshesh_arzyabi_sathe_vakonesh\n" +
            "SELECT rowNum AS id,\n" +
            "                                          res.*\n" +
            "                                   FROM (\n" +
            "select distinct\n" +
            "       mojtama_id as complex_id\n" +
            "       ,mojtama                                                                                                            as complex\n" +
            "       ,max(cast ((count_class_id_in_mojtama /dorehha_ejrashode_mojtama ) *100 as decimal(6,2) )) over ( partition by mojtama)      as  n_base_on_complex\n" +
            "       ,moavenat_id as assistant_id\n" +
            "       ,moavenat                                                                                                            as assistant\n" +
            "       ,max(cast ((count_class_id_in_moavenat /dorehha_ejrashode_moavenat ) *100 as decimal(6,2) )) over ( partition by moavenat)    as   n_base_on_assistant\n" +
            "       ,omoor_id as affairs_id\n" +
            "       ,omoor                                                                                                               as affairs\n" +
            "       ,max(cast ((count_class_id_in_omoor /dorehha_ejrashode_omoor ) *100 as decimal(6,2) )) over ( partition by omoor)          as   n_base_on_affairs\n" +
            "  \n" +
            "from(\n" +
            "        select distinct\n" +
            "            (select count(c.id) \n" +
            "              from TBL_CLASS c\n" +
            "               inner join  VIEW_COMPLEX   co  on c.COMPLEX_ID = co.id\n" +
            "              where \n" +
            "              c.C_STATUS in (2,3,5)\n" +
            "                and c.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and c.C_START_DATE <= :toDate\n" +
            " --              and  c.C_START_DATE <=@\n" +
            "--                and c.C_END_DATE =>@\n" +
            "--                and co.id =@\n" +
            "                   \n" +
            "              )   as dorehha_ejrashode_mojtama\n" +
            "              \n" +
            "              ,(select count(c.id)  \n" +
            "              from TBL_CLASS c\n" +
            "                inner join  VIEW_ASSISTANT si  on c.ASSISTANT_ID = si.id\n" +
            "                where \n" +
            "              c.C_STATUS in (2,3,5)\n" +
            "                  and c.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and c.C_START_DATE <= :toDate\n" +
            "--               and  c.C_START_DATE <=@\n" +
            "--                and c.C_END_DATE =>@\n" +
            "--                and si.id =@\n" +
            "              )   as dorehha_ejrashode_moavenat\n" +
            "              \n" +
            "              ,(select count(c.id)  \n" +
            "              from TBL_CLASS c\n" +
            "              inner join  VIEW_AFFAIRS af    on c.AFFAIRS_ID = af.id\n" +
            "              where \n" +
            "              c.C_STATUS in (2,3,5)\n" +
            "                  and c.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and c.C_START_DATE <= :toDate\n" +
            "              -- and  c.C_START_DATE <=@\n" +
            "--                and c.C_END_DATE =>@\n" +
            "--                and af.id =@\n" +
            "              )   as dorehha_ejrashode_omoor\n" +
            "              \n" +
            "              ,arzyabi_per_class.count_class_id_in_mojtama   as count_class_id_in_mojtama\n" +
            "              ,arzyabi_per_class.count_class_id_in_moavenat  as count_class_id_in_moavenat\n" +
            "              ,arzyabi_per_class.count_class_id_in_omoor     as count_class_id_in_omoor\n" +
            "              ,mojtama  \n" +
            "              ,moavenat\n" +
            "              ,omoor\n" +
            "               ,mojtama_id\n" +
            "               ,moavenat_id\n" +
            "               ,omoor_id\n" +
            "         from\n" +
            "            TBL_CLASS c\n" +
            "              left join (  select  class_id                                       as class_id\n" +
            "                                   ,count (class_id) over (partition by mojtama ) as count_class_id_in_mojtama\n" +
            "                                   ,count (class_id) over (partition by moavenat ) as count_class_id_in_moavenat\n" +
            "                                   ,count (class_id) over (partition by omoor ) as count_class_id_in_omoor\n" +
            "                                   ,mojtama  \n" +
            "                                   ,moavenat\n" +
            "                                   ,omoor\n" +
            "                                   ,mojtama_id\n" +
            "                                   ,moavenat_id\n" +
            "                                   ,omoor_id\n" +
            "                                     from\n" +
            "                                    (         select \n" +
            "                                               c.id        as class_id   \n" +
            "                                              ,co.C_TITLE  as mojtama\n" +
            "                                              ,si.C_TITLE  as moavenat\n" +
            "                                              ,af.C_TITLE  as omoor\n" +
            "                                               ,co.id      as mojtama_id\n" +
            "                                               ,si.id      as moavenat_id\n" +
            "                                               ,af.id      as omoor_id    \n" +
            "                                              from\n" +
            "                                                    TBL_CLASS c\n" +
            "                                                    inner join tbl_evaluation e\n" +
            "                                                      on  e.f_class_id = c.id\n" +
            "                                                      \n" +
            "                                                      left join (select c.id as id\n" +
            "                                                                  from\n" +
            "                                                                 TBL_CLASS c\n" +
            "                                                             left join TBL_EVALUATION_ANALYSIS   n    \n" +
            "                                                               on  n.F_TCLASS = c.id \n" +
            "                                                             where  n.B_REACTION_PASS = 1 -- pass shodeh\n" +
            "                                                               )pass\n" +
            "                                                              on pass.id = c.id\n" +
            "--                                                     \n" +
            "                                                      left join  VIEW_COMPLEX   co  on c.COMPLEX_ID = co.id\n" +
            "                                                      left join  VIEW_ASSISTANT si  on c.ASSISTANT_ID = si.id\n" +
            "                                                      left join  VIEW_AFFAIRS af  on c.AFFAIRS_ID = af.id\n" +
            "                                                    outer apply ( select to_number(c_value) as c_value from TBL_PARAMETER_VALUE v where v.C_CODE = 'minQusER' ) nr    \n" +
            "                                                    outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = '52' ) faraghir\n" +
            "                                                    outer apply ( select id as id from TBL_PARAMETER_VALUE v where v.C_CODE = 'Reactive' ) arzyabi_vakoneshi\n" +
            "                                             where\n" +
            "                                                e.F_EVALUATED_TYPE_ID = faraghir.id  -- 188 --faraghir \n" +
            "                                                and  e.f_evaluation_level_id =  arzyabi_vakoneshi.id --154  -- arzyabi_vakoneshi\n" +
            "                                                \n" +
            "                                                  and c.C_START_DATE >= :fromDate  \n" +
            "                                                                                  and c.C_START_DATE <= :toDate\n" +
            "                                                --and c.C_START_DATE <=@\n" +
            "                                                --and c.C_END_DATE =>@\n" +
            "--                                                and co.id =@\n" +
            "--                                                and si.id = @\n" +
            "--                                                and  af.id =@\n" +
            "\n" +
            "                                            group by\n" +
            "                                                c.id\n" +
            "                                               ,co.C_TITLE   \n" +
            "                                               ,si.C_TITLE  \n" +
            "                                               ,af.C_TITLE\n" +
            "                                               ,co.id    \n" +
            "                                               ,si.id     \n" +
            "                                               ,af.id     \n" +
            "                                               ,e.id\n" +
            "                                               ,nr.c_value\n" +
            "                                               ,pass.id\n" +
            "                                               \n" +
            "                                            having ( cast ((count(pass.id) / count(e.id)  )*100 as decimal(6,2)) )  >= nr.c_value\n" +
            "                                     )\n" +
            "                              group by\n" +
            "                                 class_id\n" +
            "                                 ,mojtama\n" +
            "                                 ,moavenat\n" +
            "                                 ,omoor\n" +
            "                                 ,mojtama_id\n" +
            "                                 ,moavenat_id\n" +
            "                                 ,omoor_id\n" +
            "                                    \n" +
            "                      )    arzyabi_per_class\n" +
            "                      on arzyabi_per_class.class_id = c.id \n" +
            ")  \n" +
            "\n" +
            "group by \n" +
            "  mojtama\n" +
            "  ,moavenat\n" +
            "  ,omoor\n" +
            "  ,mojtama_id\n" +
            "  ,moavenat_id\n" +
            "  ,omoor_id\n" +
            "  ,dorehha_ejrashode_mojtama\n" +
            "   ,dorehha_ejrashode_moavenat\n" +
            "    ,dorehha_ejrashode_omoor\n" +
            "  ,count_class_id_in_mojtama\n" +
            "  ,count_class_id_in_moavenat\n" +
            "  ,count_class_id_in_omoor\n" +
            "    \n" +
            " ) res\n" +
            "  where  \n" +
            "                                                                    (:complexNull = 1 OR complex IN (:complex)) \n" +
            "                                                               AND (:assistantNull = 1 OR assistant IN (:assistant))\n" +
            "                                                                     AND (:affairsNull = 1 OR affairs IN (:affairs))\n" +
            "\n" +
            "\n" +
            " ", nativeQuery = true)
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
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
            "         p.EMPLOYMENT_STATUS_ID = 210 --eshteghal\n" +
            "         and p.DELETED = 0\n" +
            "         and ( p.POST_GRADE_TITLE like '%مدیر%' --farsi\n" +
            "               or\n" +
            "               p.POST_GRADE_TITLE like '%مدیر%' --arabic\n" +
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


}