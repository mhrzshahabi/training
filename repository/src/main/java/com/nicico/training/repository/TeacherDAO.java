package com.nicico.training.repository;

import com.nicico.training.model.PersonalInfo;
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
import java.util.Map;
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

    @Transactional
    @Query(value = "SELECT  p.c_national_code FROM tbl_teacher t  LEFT JOIN tbl_personal_info  p ON t.f_personality = p.id WHERE t.id = ?", nativeQuery = true)
    String getTeacherNationalCode(Long teacherID);

    @Transactional
    @Query(value = "SELECT t.ID FROM tbl_teacher t  LEFT JOIN tbl_personal_info  p ON t.F_PERSONALITY = p.id WHERE p.C_NATIONAL_CODE =:nationalCode", nativeQuery = true)
    Long getTeacherId(String nationalCode);

    @Transactional
    @Query(value = "SELECT t.ID FROM tbl_teacher t  LEFT JOIN tbl_personal_info  p ON t.F_PERSONALITY = p.id WHERE p.C_NATIONAL_CODE =:nationalCode AND t.B_ENABLED=1", nativeQuery = true)
    Long getTeacherIdIfTeacherIsActive(String nationalCode);

    @Query(value = "select tr.NAME AS " + "\"name\""+
            "  FROM TBL_ROLE tr \n" +
            "INNER JOIN TBL_TEACHER_ROLES ttr ON ttr.ROLE_ID = tr.ID \n" +
            "INNER JOIN TBL_TEACHER tt ON tt.ID = ttr.TEACHER_ID \n" +
            "LEFT JOIN TBL_PERSONAL_INFO tpi ON tpi.ID = tt.F_PERSONALITY \n" +
            "WHERE tpi.C_NATIONAL_CODE = :nationalCode AND tt.B_ENABLED=1",nativeQuery = true)
    List<Map<String,Object>> findAllTeacherRoleByNationalCode(@Param("nationalCode") String nationalCode);


    Optional<Teacher> findByPersonality(PersonalInfo personalInfo);

    @Query(value = "select t.C_TEACHER_CODE AS " + "\"code\"" +
            ",contact.C_MOBILE AS"+ "\"mobile\""+
            " from TBL_TEACHER t \n" +
            "Left join TBL_PERSONAL_INFO info ON info.ID = t.F_PERSONALITY \n" +
            "left join TBL_CONTACT_INFO contact on contact.ID = info.F_CONTACT_INFO "+
            "WHERE contact.C_MOBILE like :mobile AND t.C_TEACHER_CODE= :nationalCode",nativeQuery = true)
    List<Map<String,Object>> findAllByNationalCodeAndMobileNumber(@Param("mobile") String mobileNumber,@Param("nationalCode") String nationalCode);

    @Query(value = "SELECT\n" + " * FROM tbl_teacher WHERE e_deleted is NULL AND b_enabled= 1",nativeQuery = true)
    Page<Teacher> findAllActiveTeacher(Pageable pageable);

}