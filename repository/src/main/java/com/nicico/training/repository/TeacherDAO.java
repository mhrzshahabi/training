package com.nicico.training.repository;

import com.nicico.training.model.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface TeacherDAO extends JpaRepository<Teacher, Long>, JpaSpecificationExecutor<Teacher> {

    @Transactional
    Optional<Teacher> findByTeacherCode(@Param("teacherCode") String teacherCode);

    @Transactional
    @Query(value = "select tt.* from TBL_TEACHER tt  where Not EXISTS(select F_TEACHER from TBL_INSTITUTE_TEACHER tit where  tit.F_TEACHER=tt.ID and tit.F_INSTITUTE = ?)", nativeQuery = true)
    List<Teacher> getUnAttachedTeachersByInstituteId(Long instituteID, Pageable pageable);

    @Transactional
    @Query(value = "select count(*) from TBL_TEACHER tt  where Not EXISTS(select F_TEACHER from TBL_INSTITUTE_TEACHER tit where  tit.F_TEACHER=tt.ID and tit.F_INSTITUTE = ?)", nativeQuery = true)
    Integer getUnAttachedTeachersCountByInstituteId(Long instituteID);

//    List<Teacher> findByCategoriesAndPersonality_EducationLevelId(Set<Category> categories, Long educationLevelId);

    @Transactional
    @EntityGraph(attributePaths = {"personality","personality.educationLevel","employmentHistories","employmentHistories.categories","employmentHistories.subCategories","teachingHistories","teachingHistories.categories","teachingHistories.subCategories","teacherCertifications","teacherCertifications.categories","teacherCertifications.subCategories","majorCategory","majorSubCategory","publications","publications.categories","publications.subCategories","foreignLangKnowledges"})
    List<Teacher> findByCategories_IdAndPersonality_EducationLevel_CodeGreaterThanEqualAndInBlackList(Long id, Integer code, Boolean inBlackList);
//    List<Teacher> findTeachersBy

    @EntityGraph(attributePaths = {"subCategories","categories","personality","personality.contactInfo","personality.educationLevel","personality.educationMajor","personality.contactInfo.homeAddress","personality.contactInfo.workAddress"})
    @Override
    List<Teacher> findAll(@Nullable Specification<Teacher> var1);


    @Transactional
    @Query(value = "select CONCAT(CONCAT(C_FIRST_NAME_FA, ' '), C_LAST_NAME_FA) from TBL_TEACHER t LEFT JOIN TBL_PERSONAL_INFO p ON t.F_PERSONALITY = p.ID where t.ID = ?", nativeQuery = true)
    String getTeacherFullName(Long teacherID);

    List<Teacher> findDistinctByTclasseCourseId(Long courseId);
}
