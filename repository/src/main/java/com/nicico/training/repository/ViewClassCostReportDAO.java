package com.nicico.training.repository;

import com.nicico.training.model.ViewClassCostReporting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewClassCostReportDAO extends JpaRepository<ViewClassCostReporting, Long>, JpaSpecificationExecutor<ViewClassCostReporting> {
}
