package com.nicico.training.repository;

import com.nicico.training.model.SynonymPersonnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;



@Repository
public interface SynonymPersonnelDAO extends JpaRepository<SynonymPersonnel, Long>, JpaSpecificationExecutor<SynonymPersonnel> {

}