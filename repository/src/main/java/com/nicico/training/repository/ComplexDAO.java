package com.nicico.training.repository;

import com.nicico.training.model.Complex;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ComplexDAO extends JpaRepository<Complex, Long>, JpaSpecificationExecutor<Complex> {
}