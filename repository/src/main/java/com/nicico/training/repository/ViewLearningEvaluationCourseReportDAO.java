package com.nicico.training.repository;

import com.nicico.training.model.ViewLearningEvaluationCourseReport;
import com.nicico.training.model.ViewLearningEvaluationStudentReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewLearningEvaluationCourseReportDAO extends JpaRepository<ViewLearningEvaluationCourseReport, Long>, JpaSpecificationExecutor<ViewLearningEvaluationCourseReport> {


    @Query(value = """
                    SELECT
                        *
                    FROM
                        view_learning_evaluation_course_report
                    WHERE
                   ( :complexNullCheck = 1 OR complex IN :complexlist )
                    AND (:moavenatNullCheck = 1 OR moavenat IN :moavenatlist)
                    AND (:omorNullCheck = 1 OR omor IN :omorlist)
                    AND (:classCodeNullCheck = 1 OR class_code IN :classcodelist)
                    AND (CASE WHEN :startfrom IS NULL THEN 1 WHEN class_start_date >= :startfrom THEN 1 END ) IS NOT NULL 
                    AND (CASE WHEN :startto IS NULL THEN 1 WHEN class_start_date <= :startto THEN 1 END ) IS NOT NULL 
                    AND (CASE WHEN :endfrom IS NULL THEN 1 WHEN class_end_date >= :endfrom THEN 1 END ) IS NOT NULL 
                    AND (CASE WHEN :endto IS NULL THEN 1 WHEN class_end_date <= :endto THEN 1 END ) IS NOT NULL 
                    AND (:categoryNullCheck = 1 OR category_id IN (:categorylist) )    
                    AND (:subCategoryNullCheck = 1 OR sub_category_id IN (:subcategorylist) )                      
                    AND (SUBSTR(term_code,1,4) = :classYear )
                    AND (:termIdNull = 1 OR term_id IN (:term_ids) )
                    AND (:teacherIdNull = 1 OR teacher_id = :teacherId ) 
                    AND (CASE WHEN :institute IS NULL THEN 1 WHEN institute = :institute THEN 1 END ) IS NOT NULL 
                    AND ((:teachingmethod = 'همه') OR (teaching_method = :teachingmethod) )
            """, nativeQuery = true)
    List<ViewLearningEvaluationCourseReport> findAllByFilters(@Param("complexlist") List<String> complexList,
                                                               @Param("complexNullCheck") int complexNullCheck,
                                                               @Param("moavenatlist") List<String> moavenatList,
                                                               @Param("moavenatNullCheck") int moavenatNullCheck,
                                                               @Param("omorlist") List<String> studentOmorList,
                                                               @Param("omorNullCheck") int omorNullCheck,
                                                               @Param("classcodelist") List<String> classCodeList,
                                                               @Param("classCodeNullCheck") int classCodeNullCheck,
                                                               @Param("startfrom") String startFrom,
                                                               @Param("startto") String startTo,
                                                               @Param("endfrom") String endFrom,
                                                               @Param("endto") String endTo,
                                                               @Param("categorylist") List<Long> categoryIds,
                                                               @Param("categoryNullCheck") int categoryNullCheck,
                                                               @Param("subcategorylist") List<Long> subCategoryIds,
                                                               @Param("subCategoryNullCheck") int subCategoryNullCheck,
                                                               @Param("classYear") String classYear,
                                                               @Param("term_ids") List<Long> termIds,
                                                               @Param("termIdNull") int termIdNullCheck,
                                                               @Param("teacherId") Long teacherId,
                                                               @Param("teacherIdNull") int teacherIdNull,
                                                               @Param("institute") String institute,
                                                               @Param("teachingmethod") String teachingMethod
    );
}
