package com.nicico.training.repository;

import com.nicico.training.model.ClassContract;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ClassContractDAO extends JpaRepository<ClassContract, Long>, JpaSpecificationExecutor<ClassContract> {
}
