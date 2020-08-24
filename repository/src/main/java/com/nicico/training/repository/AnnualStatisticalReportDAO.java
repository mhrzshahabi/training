package com.nicico.training.repository;
import com.nicico.training.model.AnnualStatisticalReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.apache.commons.lang3.StringUtils;
import java.util.List;

@Repository
public interface AnnualStatisticalReportDAO extends JpaRepository<AnnualStatisticalReport, Long>, JpaSpecificationExecutor<AnnualStatisticalReport> {

    @Query(value = "WITH r AS( " +
            "    SELECT  " +
            "        institute.id           AS institute_id, " +
            "        institute.c_title_fa   AS institute_title_fa, " +
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
            "        (:termId = -1 OR term.id =:termId)" +//"        (CASE WHEN :termId IS NULL THEN 1 WHEN term.id =:termId THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :years IS NULL THEN 1 WHEN SUBSTR(term.c_startdate,1,4) =:years THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :hoze IS NULL THEN 1 WHEN dep.c_hoze_title =:hoze THEN 1 END) IS NOT NULL " +
            "        AND (:instituteId = -1 OR  institute.id =:instituteId)"+
            "        AND (CASE WHEN :moavenat IS NULL THEN 1 WHEN dep.c_moavenat_title =:moavenat THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :omor IS NULL THEN 1 WHEN dep.c_omor_title =:omor THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :vahed IS NULL THEN 1 WHEN dep.c_vahed_title =:vahed THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :ghesmat IS NULL THEN 1 WHEN dep.c_ghesmat_title =:ghesmat THEN 1 END) IS NOT NULL " +
            "        AND (:categoryId = -1 OR course.category_id =:categoryId)" +//"        AND (CASE WHEN :categoryId IS NULL THEN 1 WHEN course.category_id =:categoryId THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :startDate IS NULL THEN 1 WHEN class.c_start_date >= :startDate THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :startDate2 IS NULL THEN 1 WHEN class.c_start_date <= :startDate2 THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :endDate IS NULL THEN 1 WHEN class.c_end_date >= :endDate THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :endDate2 IS NULL THEN 1 WHEN class.c_end_date <= :endDate2 THEN 1 END) IS NOT NULL " +
            ") " +
            "SELECT " +
            "    r.institute_id          AS institute_id, " +
            "    r.institute_title_fa    AS institute_title_fa, " +
            "    r.category_id           AS category_id, " +
            "    NVL(SUM(CASE WHEN r.c_status = '3' THEN 1 ELSE 0 END),0) AS finished_class_count, " +
            "    NVL(SUM(CASE WHEN r.c_status = '4' THEN 1 ELSE 0 END),0) AS canceled_class_count, " +
            "    NVL(SUM(CASE WHEN r.c_status = '3' THEN r.n_h_duration ELSE 0 END),0) AS sum_of_duration, " +
            "    NVL((SELECT COUNT(*) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND r2.c_status = '3'),0) AS student_count, " +
            "    NVL((SELECT SUM(r2.n_h_duration * COUNT(*)) FROM r r2 INNER JOIN tbl_class_student classstd ON classstd.class_id = r2.class_id WHERE r2.institute_id = r.institute_id AND r2.category_id = r.category_id AND r2.c_status = '3' GROUP BY r2.class_id, r2.n_h_duration),0) AS sum_of_student_hour  " +
            "FROM " +
            "    r " +
            "GROUP BY " +
            "    r.institute_id, " +
            "    r.institute_title_fa, " +
            "    r.category_id ", nativeQuery = true)

    List<AnnualStatisticalReport> AnnualStatistical(@Param("termId") Long termId,@Param("years")  String years,@Param("hoze") String  hoze,@Param("instituteId") Long instituteId,@Param("moavenat") String moavenat,@Param("omor") String omor ,@Param("vahed") String vahed,@Param("ghesmat") String ghesmat,@Param("categoryId") Long categoryId,@Param("startDate") String startDate ,@Param("endDate") String endDate,@Param("startDate2") String startDate2 ,@Param("endDate2") String endDate2);
}
