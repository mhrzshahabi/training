package com.nicico.training.repository;

import com.nicico.training.model.OperationalUnit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface OperationalUnitDAO extends JpaRepository<OperationalUnit, Long>, JpaSpecificationExecutor<OperationalUnit> {

}
