package com.nicico.training.repository;

import com.nicico.training.model.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PersonnelDAO extends JpaRepository<Personnel, String>, JpaSpecificationExecutor<Personnel> {

    Optional<Personnel> findOneByPersonnelNo(String personnelNo);

    Optional<Personnel[]> findOneByNationalCode(String nationalCode);

    List<Personnel> findOneByPostCode(String postCode);

    List<Personnel> findOneByJobNo(String jobNo);

}
