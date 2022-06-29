package com.nicico.training.repository;

import com.nicico.training.model.SynonymPersonnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SynonymPersonnelDAO extends JpaRepository<SynonymPersonnel, Long>, JpaSpecificationExecutor<SynonymPersonnel> {

    @Query(value = "select * from view_synonym_personnel where national_code = :nationalCode AND deleted = 0" , nativeQuery = true)
    SynonymPersonnel findSynonymPersonnelDataByNationalCode(String nationalCode);

    @Query(value = "select * from view_synonym_personnel where emp_no = :personnelNo2 AND deleted = 0" , nativeQuery = true)
    SynonymPersonnel findSynonymPersonnelDataByPersonnelNo2(String personnelNo2);

    Optional<SynonymPersonnel> findByPersonnelNoAndDeleted(String nationalCode, Integer deleted);

    Optional<SynonymPersonnel> findFirstByPostCode(String postCode);
}