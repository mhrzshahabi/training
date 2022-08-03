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
            "           AND c_end_date <=:toDate\n" +
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
}