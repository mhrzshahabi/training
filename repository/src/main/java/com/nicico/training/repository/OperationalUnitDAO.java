package com.nicico.training.repository;

import com.nicico.training.model.OperationalUnit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface OperationalUnitDAO extends JpaRepository<OperationalUnit, Long>, JpaSpecificationExecutor<OperationalUnit> {

    boolean existsByUnitCodeOrOperationalUnit(String unitCode, String operationalUnit);

    boolean existsByUnitCodeOrOperationalUnitAndIdNot(String unitCode, String operationalUnit, Long Id);

    boolean existsByUnitCodeOrOperationalUnitAndIdIsNot(String unitCode, String operationalUnit, Long Id);

    boolean existsByUnitCodeAndIdIsNotOrOperationalUnitAndIdIsNot(String unitCode, Long Id1, String operationalUnit, Long Id2);

}
