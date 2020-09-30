package com.nicico.training.repository;

import com.nicico.training.model.ViewActivePersonnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface ViewActivePersonnelDAO extends JpaRepository<ViewActivePersonnel, Long>, JpaSpecificationExecutor<ViewActivePersonnel> {

    Optional<ViewActivePersonnel> findFirstByPersonnelNo(String personnelNo);

    Optional<ViewActivePersonnel[]> findOneByNationalCode(String nationalCode);

    ViewActivePersonnel[] findByNationalCode(String nationalCode);

    @Query(value = "SELECT * FROM view_active_personnel where national_code = :national_code AND Personnel_No = :Personnel_No AND ROWNUM < 2", nativeQuery = true)
    ViewActivePersonnel findByNationalCodeAndPersonnelNo(String national_code, String Personnel_No);

    List<ViewActivePersonnel> findOneByPostCode(String postCode);

    List<ViewActivePersonnel> findOneByJobNo(String jobNo);

    @Query(value = "SELECT DISTINCT  view_active_personnel.company_name FROM view_active_personnel WHERE  view_active_personnel.company_name is not null order by  view_active_personnel.company_name", nativeQuery = true)
    List<String> findAllCompanyFromPersonnel();

    @Query(value = "SELECT DISTINCT  view_active_personnel.complex_title FROM view_active_personnel WHERE  view_active_personnel.complex_title is not null order by  view_active_personnel.complex_title", nativeQuery = true)
    List<String> findAllComplexFromPersonnel();

    @Query(value = "SELECT DISTINCT view_active_personnel.ccp_assistant FROM view_active_personnel WHERE view_active_personnel.ccp_assistant IS NOT NULL ORDER BY view_active_personnel.ccp_assistant", nativeQuery = true)
    List<String> findAllAssistantFromPersonnel();

    @Query(value = "SELECT DISTINCT view_active_personnel.ccp_affairs FROM view_active_personnel WHERE view_active_personnel.ccp_affairs IS NOT NULL ORDER BY view_active_personnel.ccp_affairs", nativeQuery = true)
    List<String> findAllAffairsFromPersonnel();

    @Query(value = "SELECT DISTINCT view_active_personnel.ccp_section FROM view_active_personnel WHERE view_active_personnel.ccp_section IS NOT NULL ORDER BY view_active_personnel.ccp_section", nativeQuery = true)
    List<String> findAllSectionFromPersonnel();

    @Query(value = "SELECT DISTINCT view_active_personnel.ccp_unit FROM view_active_personnel WHERE view_active_personnel.ccp_unit IS NOT NULL ORDER BY  view_active_personnel.ccp_unit", nativeQuery = true)
    List<String> findAllUnitFromPersonnel();

    @Query(value = "SELECT DISTINCT view_active_personnel.ccp_area FROM view_active_personnel WHERE view_active_personnel.ccp_area IS NOT NULL ORDER BY  view_active_personnel.ccp_area", nativeQuery = true)
    List<String> findAllAreaFromPersonnel();

    List<ViewActivePersonnel> findByPersonnelNoInOrPersonnelNo2In(List<String> personnelNos, List<String> personnelNos2);

    ViewActivePersonnel findPersonnelByPersonnelNo(String personnelNo);

    ViewActivePersonnel findPersonnelById(Long personnelId);

    Optional<ViewActivePersonnel> findById(Long Id);

    @Query(value = "SELECT complex_title FROM view_active_personnel where national_code = :national_code AND ROWNUM < 2", nativeQuery = true)
    String getComplexTitleByNationalCode(String national_code);

    @Transactional
    @Query(value = "select CONCAT(CONCAT(first_name, ' '), last_name) from view_active_personnel p where p.ID = ?", nativeQuery = true)
    String getPersonnelFullName(Long personnelID);

    @Query(value = "SELECT MAX(ID) FROM view_active_personnel where PERSONNEL_NO = :PERSONNEL_NO", nativeQuery = true)
    Long getPersonnelIdByPersonnelNo(String PERSONNEL_NO);

    @Query(value = "SELECT DISTINCT POST_GRADE_TITLE FROM view_active_personnel WHERE POST_GRADE_TITLE IS NOT NULL", nativeQuery = true)
    List<String> findAllPostGrade();

    ViewActivePersonnel findFirstByPostId(Long postId);


}

