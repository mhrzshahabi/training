package com.nicico.training.repository;

import com.nicico.training.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DepartmentDAO extends JpaRepository<Department, Long>, JpaSpecificationExecutor<Department> {

    List<Department> findAllByParentId(@Param("parentId") Long parentId);

    @Query("FROM Department d  WHERE d.parentDepartment is null"/* and d.treeVersion = 'MID-001'*/)
    List<Department> findRootNode();

    @Query(value = "SELECT DISTINCT tbl_department.c_omor_title FROM tbl_department WHERE tbl_department.c_omor_title IS NOT NULL ORDER BY  tbl_department.c_omor_title", nativeQuery = true)
    List<String> findAllAffairsFromDepartment();

    @Query(value = "SELECT DISTINCT tbl_department.c_vahed_title FROM tbl_department WHERE tbl_department.c_vahed_title IS NOT NULL ORDER BY  tbl_department.c_vahed_title", nativeQuery = true)
    List<String> findAllUnitsFromDepartment();

    @Query(value = "SELECT DISTINCT tbl_department.c_moavenat_title FROM tbl_department WHERE tbl_department.c_moavenat_title IS NOT NULL ORDER BY  tbl_department.c_moavenat_title", nativeQuery = true)
    List<String> findAllAssistantsFromDepartment();

    @Query(value = "SELECT DISTINCT tbl_department.c_hoze_title FROM tbl_department WHERE tbl_department.c_hoze_title IS NOT NULL ORDER BY  tbl_department.c_hoze_title", nativeQuery = true)
    List<String> findAllAreasFromDepartment();

    @Query(value = "SELECT DISTINCT tbl_department.c_hoze_title FROM tbl_department WHERE tbl_department.c_hoze_title IS NOT NULL ORDER BY  tbl_department.c_hoze_title", nativeQuery = true)
    List<String> findAllComplexsFromDepartment();

    @Query(value = "SELECT DISTINCT tbl_department.c_ghesmat_title FROM tbl_department WHERE tbl_department.c_ghesmat_title IS NOT NULL ORDER BY  tbl_department.c_ghesmat_title", nativeQuery = true)
    List<String> findAllSectionsFromDepartment();

    @Query(value = "select * from tbl_department where c_code = c_parent_code and e_enabled is null", nativeQuery = true)
    List<Department> getRoot();

    Optional<Department> getByCode(String code);

    @Query(value = "SELECT c_mojtame_title FROM tbl_department where id =:id AND e_deleted IS NULL", nativeQuery = true)
    String getComplexTitleById(Long id);

    @Query(value = """
            SELECT
                id
            FROM
                VIEW_COMPLEX
            WHERE
             c_title IN (
                    :complexTitles
                )
            """, nativeQuery = true)
    List<Long> getComplexIdsByTitle(@Param("complexTitles") List<String> complexTitles);

    @Query(value = """
            SELECT
                id
            FROM
                VIEW_ASSISTANT
            WHERE
            C_MOAVENAT_TITLE IN (
                    :assistantTitles
                )
            """, nativeQuery = true)
    List<Long> getAssistantIdsByTitle(@Param("assistantTitles") List<String> assistantTitles);

    @Query(value = """
            SELECT
                id
            FROM
                VIEW_AFFAIRS
            WHERE
             C_OMOR_TITLE IN (
                    :affairsTitles
                )
            """, nativeQuery = true)
    List<Long> getAffairIdsByTitle(@Param("affairsTitles") List<String> affairTitles);
}