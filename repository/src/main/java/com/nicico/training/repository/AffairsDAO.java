package com.nicico.training.repository;

import com.nicico.training.model.Affairs;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface AffairsDAO extends JpaRepository<Affairs, Long>, JpaSpecificationExecutor<Affairs> {
}