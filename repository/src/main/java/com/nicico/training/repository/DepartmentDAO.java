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

    @Query("FROM Department d  WHERE d.depParrentId = :parentId"/* and d.treeVersion = 'MID-001'*/)
    List<Department> getByDepParrentId(@Param("parentId") Long parentId);

    @Query("FROM Department d  WHERE d.parentDepartment is null"/* and d.treeVersion = 'MID-001'*/)
    List<Department> findRootNode();

}
