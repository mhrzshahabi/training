package com.nicico.training.repository;

import com.nicico.training.model.EducationalDecision;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EducationalDecisionDao extends JpaRepository<EducationalDecision, Long>, JpaSpecificationExecutor<EducationalDecision> {

    List<EducationalDecision> findAllByRefAndEducationalDecisionHeaderId(String ref, Long id);

    @Query(value = "select * from tbl_educational_decision ed where ed.f_educational_decision_header =:headerId AND ed.item_from_date <=:fromDate AND ed.item_to_date >=:fromDate AND ed.ref =:ref", nativeQuery = true)
    List<EducationalDecision> findAllByHeaderIdAndFromDateAndRef(Long headerId, String fromDate, String ref);
}