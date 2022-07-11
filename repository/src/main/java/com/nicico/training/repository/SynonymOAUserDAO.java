package com.nicico.training.repository;

import com.nicico.training.model.SynonymOAUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SynonymOAUserDAO extends JpaRepository<SynonymOAUser, Long>, JpaSpecificationExecutor<SynonymOAUser> {

}