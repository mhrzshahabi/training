package com.nicico.training.repository;

import com.nicico.training.model.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface PersonnelDAO extends JpaRepository<Personnel, Long>, JpaSpecificationExecutor<Personnel> {

    Optional<Personnel> findFirstByPersonnelNo(String personnelNo);

    Optional<Personnel[]> findOneByNationalCode(String nationalCode);

    Personnel[] findByNationalCode(String nationalCode);

    @Query(value = "SELECT * FROM tbl_personnel where national_code = :national_code AND Personnel_No = :Personnel_No AND active = 1 AND employment_status_id=5 AND ROWNUM < 2", nativeQuery = true)
    Personnel findByNationalCodeAndPersonnelNo(String national_code,String Personnel_No);

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

    List<Personnel> findByPersonnelNoInOrPersonnelNo2In(List<String> personnelNos, List<String> personnelNos2);

    Personnel findPersonnelByPersonnelNo(String personnelNo);

    Personnel findPersonnelById(Long personnelId);

    Optional<Personnel> findById(Long Id);

    @Query(value = "SELECT complex_title FROM tbl_personnel where national_code = :national_code AND active = 1 AND employment_status_id=5 AND ROWNUM < 2", nativeQuery = true)
    String getComplexTitleByNationalCode(String national_code);

    @Transactional
    @Query(value = "select CONCAT(CONCAT(first_name, ' '), last_name) from tbl_personnel p where p.ID = ?", nativeQuery = true)
    String getPersonnelFullName(Long personnelID);

    @Query(value = "SELECT MAX(ID) FROM tbl_personnel where PERSONNEL_NO = :PERSONNEL_NO AND active = 1 AND employment_status_id=5", nativeQuery = true)
    Long getPersonnelIdByPersonnelNo(String PERSONNEL_NO);


}