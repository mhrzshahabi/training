package com.nicico.training.repository;

import com.nicico.training.model.Complex;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ComplexDAO extends JpaRepository<Complex, Long>, JpaSpecificationExecutor<Complex> {

    @Query(value = "SELECT id FROM view_complex where c_title =:complexTitle", nativeQuery = true)
    Long getComplexIdByComplexTitle(String complexTitle);

    @Query(value = "SELECT c_title FROM view_complex where id =:complexId", nativeQuery = true)
    String getComplexTitleByComplexId(@Param("complexId") Long complexId);
}