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



//    @Query(value = "", nativeQuery = true)
//    List<GenericStatisticalIndexReport> posheshFardi(String fromDate,
//                                                       String toDate,
//                                                       List<Object> complex,
//                                                       int complexNull,
//                                                       List<Object> assistant,
//                                                       int assistantNull,
//                                                       List<Object> affairs,
//                                                       int affairsNull);
//}
}