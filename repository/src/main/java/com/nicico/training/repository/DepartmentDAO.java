package com.nicico.training.repository;

import com.nicico.training.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DepartmentDAO extends JpaRepository<Department, Long>, JpaSpecificationExecutor<Department> {

    List<Department> findAllByParentId(@Param("parentId") Long parentId);

    @Query("FROM Department d  WHERE d.parentDepartment is null"/* and d.treeVersion = 'MID-001'*/)
    List<Department> findRootNode();

    //Amin HK
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

    @Query(value = "select * from TBL_DEPARTMENT where id = f_parent and e_enabled is null", nativeQuery = true)
    List<Department> getRoot();
}
