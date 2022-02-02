package com.nicico.training.repository;

import com.nicico.training.model.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface PersonnelDAO extends JpaRepository<Personnel, Long>, JpaSpecificationExecutor<Personnel> {

    Optional<Personnel> findFirstByPersonnelNo(String personnelNo);

    Optional<Personnel> findFirstByNationalCodeAndDeleted(String nationalCode,Integer deleted);

    Optional<Personnel> findByNationalCodeAndDeleted(String nationalCode,Integer deleted);

    Optional<Personnel>  findFirstByNationalCode(String nationalCode);

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

    Optional<Personnel> findById(Long Id);

    @Query(value = "SELECT complex_title FROM tbl_personnel where national_code = :national_code AND deleted=0 AND ROWNUM < 2", nativeQuery = true)
    String getComplexTitleByNationalCode(String national_code);

    @Transactional
    @Query(value = "select CONCAT(CONCAT(first_name, ' '), last_name) from tbl_personnel p where p.ID = ?", nativeQuery = true)
    String getPersonnelFullName(Long personnelID);

    @Query(value = "SELECT DISTINCT POST_GRADE_TITLE FROM TBL_PERSONNEL WHERE POST_GRADE_TITLE IS NOT NULL", nativeQuery = true)
    List<String> findAllPostGrade();

    List<Personnel> findAllByNationalCodeOrderByIdDesc(String nationalCode);

    List<Personnel> findAllByPersonnelNoOrderByIdDesc(String personnelNo);

    @Query(value = "select pr.id from TBL_PERSONNEL pr inner join (select distinct(f_planner) as f_planner from tbl_class) cls on pr.id = f_planner inner join tbl_department dpr on dpr.id = pr.f_department_id where c_mojtame_code = :mojtameCode", nativeQuery = true)
    List<Long> inDepartmentIsPlanner(@Param("mojtameCode")String mojtameCode);

    @Query(value = "select * from TBL_PERSONNEL where f_contact_info = :id and active = 1 and deleted = 0" , nativeQuery = true)
    Optional<Personnel> findByContactInfoId(Long id);

    @Query(value = "select * from TBL_PERSONNEL where f_contact_info IN(:ids)" , nativeQuery = true)
    List<Personnel> findAllByContactInfoIds(List<Long> ids);

    @Query(value = "select * from TBL_PERSONNEL where personnel_no = :PersonnelNumber AND  active = 1 AND  deleted = 0" , nativeQuery = true)
    Personnel findPersonnelDataByPersonnelNumber(String PersonnelNumber);
}