package com.nicico.training.repository;

import com.nicico.training.model.InstituteAccount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface InstituteAccountDAO extends JpaRepository<InstituteAccount, Long>, JpaSpecificationExecutor<InstituteAccount> {
}
