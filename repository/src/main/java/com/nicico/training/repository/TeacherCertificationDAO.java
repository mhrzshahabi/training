package com.nicico.training.repository;

import com.nicico.training.model.TeacherCertification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherCertificationDAO extends JpaRepository<TeacherCertification, Long>, JpaSpecificationExecutor<TeacherCertification> {

    boolean existsByCourseTitleAndTeacherId(String SubjectTitle,Long teacherId);

    boolean existsByCourseTitleAndTeacherIdAndIdIsNot(String SubjectTitle,Long teacherId,Long id);

    List<TeacherCertification> findAllByTeacherId(Long teacherId);
    @Query(value =" select f_category from tbl_teacher_certification_category where f_teacher_certification= :tcId",nativeQuery = true)
    List<Long> getCategories(Long tcId);
    @Query(value = "select f_subcategory from tbl_teacher_certification_subcategory where f_teacher_certification= :tcId",nativeQuery = true)
    List<Long> getSubcategories(Long tcId);
}
