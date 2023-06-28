package com.nicico.training.repository;


import com.nicico.training.model.Agreement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AgreementDAO extends JpaRepository<Agreement, Long>, JpaSpecificationExecutor<Agreement> {
    Optional<Agreement> findByProcessInstanceId(String processInstanceId);
}
