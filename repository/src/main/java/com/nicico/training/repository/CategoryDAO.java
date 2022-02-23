package com.nicico.training.repository;

import com.nicico.training.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryDAO extends JpaRepository<Category, Long>, JpaSpecificationExecutor<Category> {

    @Query(value = "SELECT f_category FROM tbl_teacher_category WHERE f_teacher = :teacherId",nativeQuery = true)
    List<Long> findAllWithTeacher(Long teacherId);

    @Query(value = "SELECT ca.c_title_fa FROM tbl_employment_history emp\n" +
            "    LEFT JOIN tbl_employment_history_category empca ON emp.id = empca.f_employment_history\n" +
            "    LEFT JOIN tbl_category ca ON ca.id = empca.f_category\n" +
            "WHERE\n" +
            "    emp.id =:empHistoryId",nativeQuery = true)
    List<String> findCategoryNamesByEmpHistoryId(Long empHistoryId);
}
