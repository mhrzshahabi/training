package com.nicico.training.repository;


import com.nicico.training.model.NeedAssessmentGroupResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NeedAssessmentGroupResultDAO extends JpaRepository<NeedAssessmentGroupResult, Long> {
    List<NeedAssessmentGroupResult> findAllByCreatedByOrderByIdDesc(String createBy);

    NeedAssessmentGroupResult findByExcelReference(String reference);
}
