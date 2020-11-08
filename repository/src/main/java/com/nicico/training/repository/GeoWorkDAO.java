package com.nicico.training.repository;

import com.nicico.training.model.GeoWork;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface GeoWorkDAO extends JpaRepository<GeoWork, Long>, JpaSpecificationExecutor<GeoWork> {
}