package com.nicico.training.repository;

import com.nicico.training.model.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PersonnelDAO extends JpaRepository<Personnel, String>, JpaSpecificationExecutor<Personnel> {

    Optional<Personnel> findOneByPersonnelNo(String personnelNo);

    Optional<Personnel[]> findOneByNationalCode(String nationalCode);

    Personnel[] findByNationalCode(String nationalCode);

    List<Personnel> findOneByPostCode(String postCode);

    List<Personnel> findOneByJobNo(String jobNo);

    @Query(value = "SELECT DISTINCT  tbl_personnel.company_name FROM tbl_personnel WHERE  tbl_personnel.company_name is not null order by  tbl_personnel.company_name", nativeQuery = true)
    List<String> findAllCompanyFromPersonnel();

    @Query(value = "SELECT DISTINCT  tbl_personnel.complex_title FROM tbl_personnel WHERE  tbl_personnel.complex_title is not null order by  tbl_personnel.complex_title", nativeQuery = true)
    List<String> findAllComplexFromPersonnel();

    @Query(value = "SELECT DISTINCT tbl_personnel.ccp_assistant FROM tbl_personnel WHERE tbl_personnel.ccp_assistant IS NOT NULL ORDER BY tbl_personnel.ccp_assistant", nativeQuery = true)
    List<String> findAllAssistantFromPersonnel();

    @Query(value = "SELECT DISTINCT tbl_personnel.ccp_affairs FROM tbl_personnel WHERE tbl_personnel.ccp_affairs IS NOT NULL ORDER BY tbl_personnel.ccp_affairs", nativeQuery = true)
    List<String> findAllAffairsFromPersonnel();

    @Query(value = "SELECT DISTINCT tbl_personnel.ccp_section FROM tbl_personnel WHERE tbl_personnel.ccp_section IS NOT NULL ORDER BY tbl_personnel.ccp_section", nativeQuery = true)
    List<String> findAllSectionFromPersonnel();

    @Query(value = "SELECT DISTINCT tbl_personnel.ccp_unit FROM tbl_personnel WHERE tbl_personnel.ccp_unit IS NOT NULL ORDER BY  tbl_personnel.ccp_unit", nativeQuery = true)
    List<String> findAllUnitFromPersonnel();

    @Query(value = "SELECT DISTINCT tbl_personnel.ccp_area FROM tbl_personnel WHERE tbl_personnel.ccp_area IS NOT NULL ORDER BY  tbl_personnel.ccp_area", nativeQuery = true)
    List<String> findAllAreaFromPersonnel();

    Personnel findPersonnelByPersonnelNo(String personnelNo);

}