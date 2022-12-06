package com.nicico.training.repository;

import com.nicico.training.model.ViewBehavioralEvaluationFormulaReport;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface ViewBehavioralEvaluationFormulaReportDAO extends BaseDAO<ViewBehavioralEvaluationFormulaReport, Long> {
    List<ViewBehavioralEvaluationFormulaReport> findAllByClassStartDateGreaterThanEqualAndClassEndDateLessThanEqualAndCategoryIdInAndSubCategoryIdInAndClassCode(String classStartDate, String classEndDate, List<Long> categoryIds, List<Long> subCategoryIds, String classCode);

    @Query(value = """
            SELECT
                *
            FROM
                view_behavioral_evaluation_formula_report v
            WHERE
                v.class_start_date >= :classStartDate
                AND v.class_end_date <= :classEndDate
                AND ( :catsNullCheck = 1 OR v.category_id IN :categoryIds)
                AND ( :subCatsNullCheck = 1 OR v.sub_category_id IN :subCategoryIds)
                AND (:classCodeNullCheck = 1 OR v.class_code = :classCode)
                        """, nativeQuery = true)
    List<ViewBehavioralEvaluationFormulaReport> getAllByAllParams(@Param("classStartDate") String classStartDate,
                                                                  @Param("classEndDate") String classEndDate,
                                                                  @Param("categoryIds") List<Long> categoryIds,
                                                                  @Param("catsNullCheck") int catsNullCheck,
                                                                  @Param("subCategoryIds") List<Long> subCategoryIds,
                                                                  @Param("subCatsNullCheck") int subCatsNullCheck,
                                                                  @Param("classCode") String classCode,
                                                                  @Param("classCodeNullCheck") int classCodeNullCheck);
}
