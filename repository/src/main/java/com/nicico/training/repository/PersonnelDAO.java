package com.nicico.training.repository;

import com.nicico.training.model.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PersonnelDAO extends JpaRepository<Personnel, Long>, JpaSpecificationExecutor<Personnel> {

    Optional<Personnel> findOneByPersonnelNo(String personnelNo);
    Optional<Personnel[]> findOneByNationalCode(String nationalCode);

}
