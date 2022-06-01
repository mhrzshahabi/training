package com.nicico.training.repository;

import com.nicico.training.model.Subcategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

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

    @Query(value = "SELECT sub.c_title_fa FROM tbl_teaching_history teach\n" +
            "    LEFT JOIN tbl_teaching_history_subcategory teachsub ON teach.id = teachsub.f_teaching_history\n" +
            "    LEFT JOIN tbl_sub_category sub ON sub.id = teachsub.f_subcategory\n" +
            "WHERE\n" +
            "    teach.id =:teachHistoryId",nativeQuery = true)
    List<String> findSubCategoryNamesByTeachHistoryId(Long teachHistoryId);

    @Query(value = "select c_ruc.* from TBL_OPERATIONAL_ROLE r  inner join  TBL_OPERATIONAL_ROLE_USER_IDS  rell  on    rell.F_OPERATIONAL_ROLE = r.id inner join  TBL_OPERATIONAL_ROLE_SUBCATEGORY rsc   on rsc.F_OPERATIONAL_ROLE = r.id inner join TBL_SUB_CATEGORY c_ruc  on c_ruc.id = rsc.F_SUBCATEGORY  on c_ruc.id = rsc.F_SUBCATEGORY  where \n" +
            "rell.user_ids = :userId" , nativeQuery = true)
    Set<Subcategory> findAllByUserId (@Param("userId") Long userId);
}
