package com.nicico.training.repository;

import com.nicico.training.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

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

    @Query(value = "SELECT ca.c_title_fa FROM tbl_teaching_history teach\n" +
            "    LEFT JOIN tbl_teaching_history_category teachsub ON teach.id = teachsub.f_teaching_history\n" +
            "    LEFT JOIN tbl_category ca ON ca.id = teachsub.f_category\n" +
            "WHERE\n" +
            "    teach.id =:teachHistoryId",nativeQuery = true)
    List<String> findCategoryNamesByTeachHistoryId(Long teachHistoryId);
    @Query(value = "select c_rc.*\n" +
            "\n" +
            "from \n" +
            "    TBL_CATEGORY c_rc   \n" +
            "        inner join  TBL_OPERATIONAL_ROLE_CATEGORY   rc    \n" +
            "          on c_rc.id = rc.F_CATEGORY  \n" +
            "        inner join TBL_OPERATIONAL_ROLE r\n" +
            "          on rc.F_OPERATIONAL_ROLE = r.id \n" +
            "         inner join  TBL_OPERATIONAL_ROLE_USER_IDS  rell \n" +
            "          on    rell.F_OPERATIONAL_ROLE = r.id \n" +
            "where \n" +
            "rell.user_ids = :userId", nativeQuery = true)
    Set<Category> findAllByUserId (@Param("userId") Long userId);

}
