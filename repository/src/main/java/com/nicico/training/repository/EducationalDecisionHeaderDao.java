package com.nicico.training.repository;

import com.nicico.training.model.EducationalDecisionHeader;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EducationalDecisionHeaderDao extends JpaRepository<EducationalDecisionHeader, Long>, JpaSpecificationExecutor<EducationalDecisionHeader> {

    @Query(value = "select * from tbl_educational_decision_header edh where edh.item_from_date <=:fromDate AND edh.item_to_date >=:fromDate", nativeQuery = true)
    List<EducationalDecisionHeader> findAllByFromDate(String fromDate);
}