package com.nicico.training.repository;

import com.nicico.training.model.AccountInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountInfoDAO extends JpaRepository<AccountInfo, Long>, JpaSpecificationExecutor<AccountInfo> {
}
