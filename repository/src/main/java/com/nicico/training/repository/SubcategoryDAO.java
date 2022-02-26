package com.nicico.training.repository;

import com.nicico.training.model.Subcategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubcategoryDAO extends JpaRepository<Subcategory, Long>, JpaSpecificationExecutor<Subcategory> {

    List<Subcategory> findAllByCategoryId(Long categoryId);

    @Query(value = "SELECT f_subcategory FROM tbl_teacher_subcategory WHERE f_teacher = :teacherId",nativeQuery = true)
    List<Long> findAllWithTeacher(Long teacherId);

    @Query(value = "SELECT sub.c_title_fa FROM tbl_employment_history emp\n" +
            "    LEFT JOIN tbl_employment_history_subcategory empsub ON emp.id = empsub.f_employment_history\n" +
            "    LEFT JOIN tbl_sub_category sub ON sub.id = empsub.f_subcategory\n" +
            "WHERE\n" +
            "    emp.id =:empHistoryId",nativeQuery = true)
    List<String> findSubCategoryNamesByEmpHistoryId(Long empHistoryId);
}
