package com.nicico.training.repository;

import com.nicico.training.model.Bank;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BankDAO extends JpaRepository<Bank,Long>, JpaSpecificationExecutor<Bank> {
}
