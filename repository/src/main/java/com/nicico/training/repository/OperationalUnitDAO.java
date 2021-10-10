package com.nicico.training.repository;

import com.nicico.training.model.OperationalUnit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface OperationalUnitDAO extends JpaRepository<OperationalUnit, Long>, JpaSpecificationExecutor<OperationalUnit> {

    boolean existsByUnitCodeOrOperationalUnit(String unitCode, String operationalUnit);
    boolean existsByOperationalUnit(String operationalUnit);
    boolean existsByUnitCode(String unitCode);

    @Query(value = "select count(*) from tbl_operational_unit ", nativeQuery = true)
    int countAllRecords();

    boolean existsByUnitCodeAndIdIsNotOrOperationalUnitAndIdIsNot(String unitCode, Long Id1, String operationalUnit, Long Id2);
}
