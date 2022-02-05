package com.nicico.training.repository;

import com.nicico.training.model.Institute;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface InstituteDAO extends JpaRepository<Institute, Long>, JpaSpecificationExecutor<Institute> {
}
