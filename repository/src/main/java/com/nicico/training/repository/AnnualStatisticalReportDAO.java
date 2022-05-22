package com.nicico.training.repository;

import com.nicico.training.model.AnnualStatisticalReport;
import com.nicico.training.model.compositeKey.AnnualStatisticalReportKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnnualStatisticalReportDAO extends JpaRepository<AnnualStatisticalReport, AnnualStatisticalReportKey>, JpaSpecificationExecutor<AnnualStatisticalReport> {

    @Query(value = "WITH r AS( " +
            "    SELECT  " +
            "        institute.id           AS institute_id, " +
            "        institute.c_title_fa   AS institute_title_fa, " +
            "   course.n_theory_duration     AS course_duration,    \n" +
            "class.f_teacher         AS f_teacher,"+
            " course.e_technical_type     AS course_technical,    "+
            "        course.category_id     AS category_id, " +
            "        class.c_status         AS c_status, " +
            "        class.n_h_duration     AS n_h_duration, " +
            "        class.id               AS class_id " +
            "    FROM  " +
            "        tbl_institute                   institute " +
            "        INNER JOIN tbl_class            class ON class.f_institute_organizer = institute.id " +
            "        INNER JOIN tbl_course           course ON course.id = class.f_course " +
            "        INNER JOIN tbl_term             term ON term.id = class.f_term " +
            "        LEFT JOIN tbl_target_society    target ON target.f_class_id = class.id " +
            "        LEFT JOIN tbl_department        dep ON dep.id = target.f_society_id " +
            "    WHERE  " +
            "        (:termNull = 1 OR term.id IN (:termId))" +
            "        AND (:yearNull = 1 OR SUBSTR(term.c_startdate,1,4) IN (:years))" +
            "        AND (CASE WHEN :hoze IS NULL THEN 1 WHEN dep.c_hoze_title =:hoze THEN 1 END) IS NOT NULL " +
            "        AND (:instituteNull = 1 OR  institute.id IN (:instituteId))" +
            "        AND (CASE WHEN :moavenat IS NULL THEN 1 WHEN dep.c_moavenat_title =:moavenat THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :omor IS NULL THEN 1 WHEN dep.c_omor_title =:omor THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :vahed IS NULL THEN 1 WHEN dep.c_vahed_title =:vahed THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :ghesmat IS NULL THEN 1 WHEN dep.c_ghesmat_title =:ghesmat THEN 1 END) IS NOT NULL " +
            "        AND (:categoryNull = 1 OR course.category_id IN (:categoryId))" +
            "        AND (CASE WHEN :startDate IS NULL THEN 1 WHEN class.c_start_date >= :startDate THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :endDate IS NULL THEN 1 WHEN class.c_start_date <= :endDate THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :startDate2 IS NULL THEN 1 WHEN class.c_end_date >= :startDate2 THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :endDate2 IS NULL THEN 1 WHEN class.c_end_date <= :endDate2 THEN 1 END) IS NOT NULL " +
            ") " +
            "SELECT " +
            "    r.institute_id          AS institute_id, " +
            "    r.institute_title_fa    AS institute_title_fa, " +
            "    r.category_id           AS category_id, " +
            "    NVL(SUM(CASE WHEN r.c_status = '1' THEN 1 ELSE 0 END),0) AS barnamerizi_class_count, " +
            "    nvl((\n" +
            "        SELECT\n" +
            "            COUNT(*)\n" +
            "        FROM\n" +
            "                 r r2\n" +
            "            INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id\n" +
            "        WHERE\n" +
            "                r2.institute_id = r.institute_id\n" +
            "            AND r2.category_id = r.category_id\n" +
            "           \n" +
            "            AND classstd.scores_state_id IN(400, 401)\n" +
            "    ), 0)                AS student_count_ghabool,"+
            "    NVL(SUM(CASE WHEN r.c_status = '2' THEN 1 ELSE 0 END),0) AS ejra_class_count, " +
            "              NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id \n" +
            "                 INNER JOIN tbl_student std ON std.id = classstd.student_id\n" +
            "                 WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) AND (std.p_type is null) ),0) AS student_sayer,    \n" +
            "\n" +
            "                 \n" +
            "                 \n" +
            "                                  NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id \n" +
            "                 INNER JOIN tbl_student std ON std.id = classstd.student_id\n" +
            "                 WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) AND (std.p_type = 'Personal') ),0) AS student_personal,\n" +
            "                 \n" +
            "                 \n" +
            "                             NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id \n" +
            "                 INNER JOIN tbl_student std ON std.id = classstd.student_id\n" +
            "                 WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) AND (std.p_type = 'ContractorPersonal') ),0) AS student_contractor_personal,"+
            "    NVL(SUM(CASE WHEN r.c_status = '3' THEN 1 ELSE 0 END),0) AS finished_class_count, " +
            "    NVL(SUM(CASE WHEN r.c_status = '4' THEN 1 ELSE 0 END),0) AS canceled_class_count, " +
            "    NVL(SUM(CASE WHEN r.c_status = '5' THEN 1 ELSE 0 END),0) AS ekhtetam_class_count, " +
            "                   nvl((    \n" +
            "                     SELECT    \n" +
            "                         COUNT(*)    \n" +
            "                     FROM    \n" +
            "                              r r2    \n" +
            "                         left JOIN tbl_teacher teacher ON teacher.id = r2.f_teacher    \n" +
            "                     WHERE    \n" +
            "                             r2.institute_id = r.institute_id    \n" +
            "                         AND r2.category_id = r.category_id    \n" +
            "                            \n" +
            "                         AND teacher.B_PERSONNEL = 1    \n" +
            "                 ), 0)                AS ostad_count_dakheli, \n" +
            "ROUND( \n" +
            "nvl((    \n" +
            "                     SELECT    \n" +
            "                         COUNT(*)    \n" +
            "                     FROM    \n" +
            "                              r r2    \n" +
            "                         left JOIN tbl_teacher teacher ON teacher.id = r2.f_teacher    \n" +
            "                     WHERE    \n" +
            "                             r2.institute_id = r.institute_id    \n" +
            "                         AND r2.category_id = r.category_id    \n" +
            "                            \n" +
            "                         AND teacher.B_PERSONNEL = 1    \n" +
            "                 ), 0)  /   nullif(SUM(CASE WHEN r.c_status in ('1','2','3','4','5')  THEN 1 ELSE 0 END),0)       , 2)   * 100     AS darsad_ostad_dakheli, "+
            "                   NVL(SUM(CASE WHEN r.c_status in ('1','2','3','4','5')  THEN 1 ELSE 0 END),0) AS class_count,  \n" +
"                                  NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=1)  THEN r.course_duration ELSE 0 END),0) AS sum_of_omomi,  \n" +
            "                               ROUND(    NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=1)  THEN r.course_duration ELSE 0 END),0)/  nullif(  SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds))  THEN r.n_h_duration ELSE 0 END),0),2) AS sarane_omomi,    \n" +
            "                                  NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=2)  THEN r.course_duration ELSE 0 END),0) AS sum_of_takhasosi,    \n" +
            "                               ROUND(   NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=2)  THEN r.course_duration ELSE 0 END),0)/ nullif( SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds))  THEN r.n_h_duration ELSE 0 END),0),2) AS sarane_takhasosi,   "+

            "    NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds))  THEN r.n_h_duration ELSE 0 END),0) AS sum_of_duration, " +
            "    NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) ),0) AS student_count, " +
            "    NVL((SELECT SUM(r2.n_h_duration * COUNT(*)) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds))  GROUP BY r2.class_id, r2.n_h_duration),0) AS sum_of_student_hour  " +
            "FROM " +
            "    r " +
            "GROUP BY " +
            "    r.institute_id, " +
            "    r.institute_title_fa, " +
            "    r.category_id ", nativeQuery = true)
    List<AnnualStatisticalReport> AnnualStatistical(@Param("termId") List<Long> termId,
                                                    @Param("termNull") int termNull,
                                                    @Param("years") List<String> years,
                                                    @Param("yearNull") int yearNull,
                                                    @Param("hoze") String hoze,
                                                    @Param("instituteId") List<Long> instituteId,
                                                    @Param("instituteNull") int instituteNull,
                                                    @Param("moavenat") String moavenat,
                                                    @Param("omor") String omor,
                                                    @Param("vahed") String vahed,
                                                    @Param("ghesmat") String ghesmat,
                                                    @Param("categoryId") List<Long> categoryId,
                                                    @Param("categoryNull") int categoryNull,
                                                    @Param("startDate") String startDate,
                                                    @Param("endDate") String endDate,
                                                    @Param("startDate2") String startDate2,
                                                    @Param("endDate2") String endDate2,
                                                    @Param("statusNull") int statusNull,
                                                    @Param("classStatusIds") List<Long> classStatusIds);


    @Query(value ="WITH r AS(" +
            "                SELECT" +
            "                    institute.id           AS institute_id," +
            "   course.n_theory_duration     AS course_duration,    \n" +
            " course.e_technical_type     AS course_technical,    "+
            "class.f_teacher         AS f_teacher,"+
            "                    institute.c_title_fa   AS institute_title_fa," +
            "                    0     AS category_id, " +
            "                    class.c_status         AS c_status," +
            "                    class.n_h_duration     AS n_h_duration," +
            "                    class.id               AS class_id " +
            "                FROM  " +
            "                    tbl_institute                   institute" +
            "                    INNER JOIN tbl_class            class ON class.f_institute_organizer = institute.id" +
            "                    INNER JOIN tbl_course           course ON course.id = class.f_course" +
            "                    INNER JOIN tbl_term             term ON term.id = class.f_term" +
            "                    LEFT JOIN tbl_target_society    target ON target.f_class_id = class.id" +
            "                    LEFT JOIN tbl_department        dep ON dep.id = target.f_society_id" +
            "                WHERE   " +
            "        (:termNull = 1 OR term.id IN (:termId))" +
            "        AND (:yearNull = 1 OR SUBSTR(term.c_startdate,1,4) IN (:years))" +
            "        AND (CASE WHEN :hoze IS NULL THEN 1 WHEN dep.c_hoze_title =:hoze THEN 1 END) IS NOT NULL " +
            "        AND (:instituteNull = 1 OR  institute.id IN (:instituteId))" +
            "        AND (CASE WHEN :moavenat IS NULL THEN 1 WHEN dep.c_moavenat_title =:moavenat THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :omor IS NULL THEN 1 WHEN dep.c_omor_title =:omor THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :vahed IS NULL THEN 1 WHEN dep.c_vahed_title =:vahed THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :ghesmat IS NULL THEN 1 WHEN dep.c_ghesmat_title =:ghesmat THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :startDate IS NULL THEN 1 WHEN class.c_start_date >= :startDate THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :endDate IS NULL THEN 1 WHEN class.c_start_date <= :endDate THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :startDate2 IS NULL THEN 1 WHEN class.c_end_date >= :startDate2 THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :endDate2 IS NULL THEN 1 WHEN class.c_end_date <= :endDate2 THEN 1 END) IS NOT NULL " +
            ") " +
            "            SELECT  " +
            "                r.institute_id          AS institute_id," +
            "                r.institute_title_fa    AS institute_title_fa," +
            "                   NVL(SUM(CASE WHEN r.c_status in ('1','2','3','4','5')  THEN 1 ELSE 0 END),0) AS class_count,  \n" +

            "                   nvl((    \n" +
            "                     SELECT    \n" +
            "                         COUNT(*)    \n" +
            "                     FROM    \n" +
            "                              r r2    \n" +
            "                         left JOIN tbl_teacher teacher ON teacher.id = r2.f_teacher    \n" +
            "                     WHERE    \n" +
            "                             r2.institute_id = r.institute_id    \n" +
            "                         AND r2.category_id = r.category_id    \n" +
            "                            \n" +
            "                         AND teacher.B_PERSONNEL = 1    \n" +
            "                 ), 0)                AS ostad_count_dakheli, \n" +
            "ROUND( \n" +
            "nvl((    \n" +
            "                     SELECT    \n" +
            "                         COUNT(*)    \n" +
            "                     FROM    \n" +
            "                              r r2    \n" +
            "                         left JOIN tbl_teacher teacher ON teacher.id = r2.f_teacher    \n" +
            "                     WHERE    \n" +
            "                             r2.institute_id = r.institute_id    \n" +
            "                         AND r2.category_id = r.category_id    \n" +
            "                            \n" +
            "                         AND teacher.B_PERSONNEL = 1    \n" +
            "                 ), 0)  /   nullif(SUM(CASE WHEN r.c_status in ('1','2','3','4','5')  THEN 1 ELSE 0 END),0)       , 2) * 100      AS darsad_ostad_dakheli, "+
            "    NVL(SUM(CASE WHEN r.c_status = '1' THEN 1 ELSE 0 END),0) AS barnamerizi_class_count, " +
            "    NVL(SUM(CASE WHEN r.c_status = '2' THEN 1 ELSE 0 END),0) AS ejra_class_count, " +
            "    NVL(SUM(CASE WHEN r.c_status = '3' THEN 1 ELSE 0 END),0) AS finished_class_count, " +
            "    NVL(SUM(CASE WHEN r.c_status = '4' THEN 1 ELSE 0 END),0) AS canceled_class_count, " +
            "              NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id \n" +
            "                 INNER JOIN tbl_student std ON std.id = classstd.student_id\n" +
            "                 WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) AND (std.p_type is null) ),0) AS student_sayer,    \n" +
            "\n" +
            "                 \n" +
            "                 \n" +
            "                                  NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id \n" +
            "                 INNER JOIN tbl_student std ON std.id = classstd.student_id\n" +
            "                 WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) AND (std.p_type = 'Personal') ),0) AS student_personal,\n" +
            "                 \n" +
            "                 \n" +
            "                             NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id \n" +
            "                 INNER JOIN tbl_student std ON std.id = classstd.student_id\n" +
            "                 WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) AND (std.p_type = 'ContractorPersonal') ),0) AS student_contractor_personal,"+
            "    nvl((\n" +
            "        SELECT\n" +
            "            COUNT(*)\n" +
            "        FROM\n" +
            "                 r r2\n" +
            "            INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id\n" +
            "        WHERE\n" +
            "                r2.institute_id = r.institute_id\n" +
            "            AND r2.category_id = r.category_id\n" +
            "           \n" +
            "            AND classstd.scores_state_id IN(400, 401)\n" +
            "    ), 0)                AS student_count_ghabool,"+
            "    NVL(SUM(CASE WHEN r.c_status = '5' THEN 1 ELSE 0 END),0) AS ekhtetam_class_count, " +
            "                                  NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=1)  THEN r.course_duration ELSE 0 END),0) AS sum_of_omomi,  \n" +
            "                               ROUND(    NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=1)  THEN r.course_duration ELSE 0 END),0)/  nullif(  SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds))  THEN r.n_h_duration ELSE 0 END),0),2) AS sarane_omomi,    \n" +
            "                                  NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=2)  THEN r.course_duration ELSE 0 END),0) AS sum_of_takhasosi,    \n" +
            "                               ROUND(   NVL(SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds)) AND (course_technical=2)  THEN r.course_duration ELSE 0 END),0)/ nullif( SUM(CASE WHEN  (:statusNull = 1 OR r.c_status IN (:classStatusIds))  THEN r.n_h_duration ELSE 0 END),0),2) AS sarane_takhasosi,   "+
            "                NVL(SUM(CASE WHEN (:statusNull = 1 OR r.c_status IN (:classStatusIds))  THEN r.n_h_duration ELSE 0 END),0) AS sum_of_duration," +
            "                NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id WHERE r2.institute_id = r.institute_id AND  (:statusNull = 1 OR r2.c_status IN (:classStatusIds)) ),0) AS student_count," +
            "                NVL((SELECT SUM(r2.n_h_duration * COUNT(*)) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id WHERE r2.institute_id = r.institute_id AND (:statusNull = 1 OR r2.c_status IN (:classStatusIds))  GROUP BY r2.class_id, r2.n_h_duration),0) AS sum_of_student_hour" +
            "            FROM " +
            "                r  " +
            "            GROUP BY " +
            "                r.institute_id,  " +
            "                r.institute_title_fa  ", nativeQuery = true)
    List<AnnualStatisticalReport> AnnualStatisticalReportShahrBabak(
            @Param("termId") List<Long> termId,
            @Param("termNull") int termNull,
            @Param("years") List<String> years,
            @Param("yearNull") int yearNull,
            @Param("hoze") String hoze,
            @Param("instituteId") List<Long> instituteId,
            @Param("instituteNull") int instituteNull,
            @Param("moavenat") String moavenat,
            @Param("omor") String omor,
            @Param("vahed") String vahed,
            @Param("ghesmat") String ghesmat,
            @Param("startDate") String startDate,
            @Param("endDate") String endDate,
            @Param("startDate2") String startDate2,
            @Param("endDate2") String endDate2,
            @Param("statusNull") int statusNull,
            @Param("classStatusIds") List<Long> classStatusIds);
}

