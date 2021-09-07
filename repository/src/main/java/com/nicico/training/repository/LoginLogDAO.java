package com.nicico.training.repository;

import com.nicico.training.model.LoginLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface LoginLogDAO extends JpaRepository<LoginLog, Long>, JpaSpecificationExecutor<LoginLog> {
}
