package com.nicico.training.repository;

import com.nicico.training.model.SynonymOAUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SynonymOAUserDAO extends JpaRepository<SynonymOAUser, Long>, JpaSpecificationExecutor<SynonymOAUser> {
    Optional<SynonymOAUser> findByNationalCode(String nationalCode);
}