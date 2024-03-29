package com.nicico.training.repository;

import com.nicico.training.model.FamilyPersonnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface FamilyPersonnelDAO extends JpaRepository<FamilyPersonnel, Long>, JpaSpecificationExecutor<FamilyPersonnel> {

}
