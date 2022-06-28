package com.nicico.training.repository;

import com.nicico.training.model.OperationalChart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface OperationalChartDAO extends JpaRepository<OperationalChart, Long>, JpaSpecificationExecutor<OperationalChart> {
}
